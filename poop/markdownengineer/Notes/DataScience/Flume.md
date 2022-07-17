# 数据采集器 Flume

目录

1. [数据采集器 Flume](#数据采集器-flume)
   1. [Flume](#flume)
      1. [Source, Sink, Channel 的作用](#source-sink-channel-的作用)
      2. [Flume 高可用](#flume-高可用)
         1. [Flume 采集数据会丢失么](#flume-采集数据会丢失么)
         2. [Failover](#failover)
         3. [Load Balance](#load-balance)
         4. [Flume 数据传输的监控](#flume-数据传输的监控)
      3. [Flume 上传文件到 HDFS 时参数大量小文件](#flume-上传文件到-hdfs-时参数大量小文件)
      4. [Flume 优化](#flume-优化)
         1. [FileChannel 优化](#filechannel-优化)
         2. [Flume 内存优化](#flume-内存优化)
         3. [Flume 参数调优](#flume-参数调优)
      5. [Flume Pipeline 用什么方式储存](#flume-pipeline-用什么方式储存)
      6. [Flume 突然下线怎么办 重启后是重新输入 Flume 么](#flume-突然下线怎么办-重启后是重新输入-flume-么)
      7. [如何设置 Flume 偏移量](#如何设置-flume-偏移量)
      8. [为什么不用 flume 直连 hbase 呢](#为什么不用-flume-直连-hbase-呢)

## Flume

核心概念是 agent, 里面包括 Source, Channel 和 Sink 三个组件. Source 运行在日志收集节点进行日志采集, 之后临时存储在 Channel 中, Sink 负责将 Channel 中的数据发送到目的地. 只有成功发送之后 Channel 中的数据才会被删除. 首先书写 Flume 配置文件, 定义 agent, Source, Channel 和 Sink 然后将其组装, 执行 `flume-ng` 命令.

### Source, Sink, Channel 的作用

- Source 组件用来收集数据, 可以处理多种日志类型.
- Channel 负责缓存采集的数据, 存入内存或者写入硬盘.
- Sink 组件用来传输数据到其他软件, 比如 HDFS, HBase.

### Flume 高可用

#### Flume 采集数据会丢失么

可以开启断点续传 `TailDirSource`.

不会, Channel 储存可以在 File 中, 传输数据有事务性. 类似数据库事务, Flume 使用两个独立的事务分别控制从 Source 到 Channel (Put 事务), 以及 Channel 到 Sink (Take 事务).

- ​TailDir Source: 断点续传, 多目录. Flume 1.6 以前需要自己自定义 Source 记录每次读取文件位置, 实现断点续传.

- File Channel: 数据存储在磁盘, 宕机数据可以保存. 但是传输速率慢. 适合对数据传输可靠性要求高的场景, 比如金融数据.

- Memory Channel: 数据存储在内存中, 宕机数据丢失. 传输速率快. 适合对数据传输可靠性要求不高的场景, 比如普通日志数据.

- Kafka Channel: 减少了 Flume 的 Sink 阶段, 提高了传输效率.

#### Failover

当采集节点故障后流式切换到其他节点.

```conf
# 定义 sink
a1.sinks = k1 k2

# 设置一个 sink 组
a1.sinkgroups = g1
# 指定 sink
a1.sinkgroups.g1.sinks = k1 k2
```

配置多个 sinks 让数据流入一个 sinkgroups 中.

```conf
# 指定 failover
a1.sinkgroups.g1.processor.type = failover
# 指定 sink 传输优先级为 n
a1.sinkgroups.g1.processor.priority.k1 = n
# 指定 k2 的优先级 n_2
a1.sinkgroups.g1.processor.priority.k2 = n_2
# 指定故障转移超时时间, 单位毫秒
a1.sinkgroups.g1.processor.maxpenalty = n
```

#### Load Balance

给 g1 group 开启负载均衡.

```conf
# 指定 sink 组负载均衡
a1.sinkgroups.g1.processor.type =load_balance
# 默认是 round robin 还可以选择 random (hash 分布并感)
a1.sinkgroups.g1.processor.selector = round_robin
# 如果 back off 被开启则sink processor 会屏蔽故障的 sink
a1.sinkgroups.g1.processor.backoff = true
```

#### Flume 数据传输的监控

使用 Ganglia 框架.

### Flume 上传文件到 HDFS 时参数大量小文件

`hdfs.rollInterval, hdfs.rollSize, hdfs.rollCount`

### Flume 优化

#### FileChannel 优化

通过配置 `dataDirs` 指向多个路径, 每个路径对应不同的硬盘, 增大 Flume 吞吐量.

`checkpointDir` 和 `backupCheckpointDir` 也尽量配置在不同硬盘对应的目录中, 保证 checkpoint 坏掉后, 可以快速使用 `backupCheckpointDir` 恢复数据.

#### Flume 内存优化

flume-env.sh 中设置 JVM heap; 单机时设置 -Xmx 与 -Xms 设置一致, 减少内存抖动和 Full GC.

#### Flume 参数调优

- Source:

    - 使用 ​TailDir Source 时可增加 FileGroups 个数, 增加 Source 个数可以提高读取数据效率.
    - 例如：当某一个目录产生的文件过多时需要将这个文件目录拆分成多个文件目录, 同时配置好多个 Source 以保证 Source 有足够的能力获取到新产生的数据。batchSize 参数决定 Source 一次批量运输到 Channel 的 event 条数, 适当调大这个参数可以提高 Source 搬运 Event 到 Channel 时的性能。

- Channel:

    - memory type 的 Channel 性能最好, 但是因为写入内存所以进程下线就会丢失数据; 选 file 模式容错性更好, 但是读写速度差; 使用 file Channel 时 dataDirs 配置多个不同盘下的目录可以提高性能.
    - Capacity 参数决定 Channel 可容纳最大的 event 条数.
    - transactionCapacity 参数决定每次 Source 往 channel 里面写的最大 event 条数和每次 Sink 从 channel 里面读的最大 event 条数; transactionCapacity 需要大于 Source 和 Sink 的 batchSize 参数.

- Sink:
    - 合理增加 Sink 数量可以改善 event 消费能力, 但是过多的 Sink 会造成系统资源的浪费.

### Flume Pipeline 用什么方式储存

内存或文件

### Flume 突然下线怎么办 重启后是重新输入 Flume 么

设置成文件储存

### 如何设置 Flume 偏移量

### 为什么不用 flume 直连 hbase 呢
