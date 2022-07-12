# 面经

1. [面经](#面经)
   1. [SQL](#sql)
   2. [Hadoop](#hadoop)
      1. [搭建 Hadoop 集群的主要配置文件](#搭建-hadoop-集群的主要配置文件)
      2. [正常的 Hadoop 集群进程与作用](#正常的-hadoop-集群进程与作用)
      3. [SecondaryNode 的具体作用](#secondarynode-的具体作用)
      4. [Hadoop 大版本区别](#hadoop-大版本区别)
         1. [1.x](#1x)
         2. [2.x](#2x)
         3. [3.x](#3x)
      5. [HDFS 的 Block](#hdfs-的-block)
      6. [HDFS 的 Block 怎么调整大小](#hdfs-的-block-怎么调整大小)
      7. [HDFS 对单独一个文件调整 Block 大小](#hdfs-对单独一个文件调整-block-大小)
      8. [HDFS 读写过程](#hdfs-读写过程)
      9. [HDFS 读写原理](#hdfs-读写原理)
      10. [Hadoop 高可用](#hadoop-高可用)
      11. [Hadoop 配置调优](#hadoop-配置调优)
      12. [SecondaryNameNode 是干什么的](#secondarynamenode-是干什么的)
      13. [往 HDFS 里 put 文件时 HDFS 都做了什么](#往-hdfs-里-put-文件时-hdfs-都做了什么)
      14. [MapReduce](#mapreduce)
         1. [MapReduce的工作原理](#mapreduce的工作原理)
         2. [Map 的运行步骤](#map-的运行步骤)
         3. [数据倾斜在 Mapper 和 Reduce 那一边发生的](#数据倾斜在-mapper-和-reduce-那一边发生的)
         4. [如何优化数据倾斜](#如何优化数据倾斜)
         5. [Mapper Combiner 后会发生什么](#mapper-combiner-后会发生什么)
         6. [Map 输出的数据超出小文件内存后会发生什么](#map-输出的数据超出小文件内存后会发生什么)
         7. [Map 到 Reduce 默认的分区机制](#map-到-reduce-默认的分区机制)
         8. [求 _SQL_ 中每个 id 的最早登录日期和最晚登录日期](#求-sql-中每个-id-的最早登录日期和最晚登录日期)
         9. [_SQL_ 有 1gb 的数据, 按照 login_date 分组](#sql-有-1gb-的数据-按照-login_date-分组)
         10. [YARN 的优势](#yarn-的优势)
         11. [Shuffle 原理与优化](#shuffle-原理与优化)
   3. [Spark](#spark)
      1. [什么是 RDD](#什么是-rdd)
      2. [RDD 都有那些算子](#rdd-都有那些算子)
      3. [reduceByKey 和 groupByKey 的区别](#reducebykey-和-groupbykey-的区别)
      4. [SparkStreaming 在消费 Kafka 时下限, 如何保证重启后继续消费 Kafka 之前的未知](#sparkstreaming-在消费-kafka-时下限-如何保证重启后继续消费-kafka-之前的未知)
      5. [Spark 广播变量](#spark-广播变量)
      6. [Spark 中 job, stage, task 分别代表什么](#spark-中-job-stage-task-分别代表什么)
      7. [Spark 累加器](#spark-累加器)
      8. [Spark 的工作机制](#spark-的工作机制)
      9. [Spark 模块](#spark-模块)
      10. [DStream 和 DStreamGraph 的区别](#dstream-和-dstreamgraph-的区别)
   4. [HIVE](#hive)
      1. [内部表和外部表的区别](#内部表和外部表的区别)
      2. [HIVE 的 UDF 怎么实现](#hive-的-udf-怎么实现)
      3. [大小表 join in 如何排列](#大小表-join-in-如何排列)
   5. [HBase](#hbase)
      1. [HBase 的优点](#hbase-的优点)
      2. [HBase 与 MySQL 的区别](#hbase-与-mysql-的区别)
      3. [列式存储的特点](#列式存储的特点)
      4. [HBase 的操作, 储存与扫描机制和调优](#hbase-的操作-储存与扫描机制和调优)
   6. [MySQL](#mysql)
      1. [事务的隔离级别](#事务的隔离级别)
      2. [MySQL 的引擎都有什么](#mysql-的引擎都有什么)
   7. [Java](#java)
      1. [volatile 关键字的意义](#volatile-关键字的意义)
      2. [Java 线程池有几个类型, 各自的作用](#java-线程池有几个类型-各自的作用)
      3. [Java 线程池的拒绝策略](#java-线程池的拒绝策略)
      4. [Java 锁机制](#java-锁机制)
      5. [JVM 了解多少](#jvm-了解多少)
      6. [JVM 内存模型](#jvm-内存模型)
      7. [JVM 垃圾回收](#jvm-垃圾回收)
      8. [main 方法 new 了一个类, 并调用他的 run 方法, JVM 中都发生了什么](#main-方法-new-了一个类-并调用他的-run-方法-jvm-中都发生了什么)
         1. [G1 垃圾回收器](#g1-垃圾回收器)
   8. [Flume](#flume)
      1. [Flume Pipeline 用什么方式储存](#flume-pipeline-用什么方式储存)
      2. [Flume 突然下线怎么办 重启后是重新输入 Flume 么](#flume-突然下线怎么办-重启后是重新输入-flume-么)
      3. [如何设置 Flume 偏移量](#如何设置-flume-偏移量)
      4. [为什么不用 flume 直接接 hbase 呢](#为什么不用-flume-直接接-hbase-呢)
   9. [Zookeeper](#zookeeper)
      1. [Zookeeper 的 Leader 选举机制](#zookeeper-的-leader-选举机制)
         1. [Zookeeper 服务端启动时选举](#zookeeper-服务端启动时选举)
         2. [Zookeeper 运行中的选举](#zookeeper-运行中的选举)
      2. [Leader 突然下线怎么办](#leader-突然下线怎么办)
   10. [Kafka](#kafka)
      1. [Kafka 怎么进行数据备份](#kafka-怎么进行数据备份)
      2. [Consumer 在 Leader 还是 Follower 中拿去数据](#consumer-在-leader-还是-follower-中拿去数据)
      3. [Kafka ISR 机制](#kafka-isr-机制)
      4. [Kafka 数据不丢失不重复](#kafka-数据不丢失不重复)
      5. [页缓存技术](#页缓存技术)
      6. [kafka 数据格式都是什么](#kafka-数据格式都是什么)
      7. [Kafka 如何清理过期数据](#kafka-如何清理过期数据)
      8. [kafka 的 `Broker, partition, segment` 都是啥](#kafka-的-broker-partition-segment-都是啥)
      9. [Kafka 如何实现幂等性](#kafka-如何实现幂等性)
      10. [Kafka 蓄水池机制](#kafka-蓄水池机制)
   11. [算法](#算法)
      1. [求两个字符串的公共子串最大长度](#求两个字符串的公共子串最大长度)
      2. [数组问题](#数组问题)
      3. [实现观察者模式](#实现观察者模式)
      4. [机器人问题](#机器人问题)
      5. [HashMap 实现原理](#hashmap-实现原理)
      6. [集合框架中线程安全的类有哪些](#集合框架中线程安全的类有哪些)

## SQL

定义一个表如下:

| pk_PK | id_INT | login_date_DATE | logout_date_DATE | PV_INT |
| :---: | :----: | :-------------: | :--------------: | ------ |
|   1   |   1    | 1970/1/1 00:00  |  1970/1/1 00:01  | 1      |
|   2   |   1    | 1970/1/2 00:00  |  1970/1/2 00:02  | 2      |
|   3   |   1    | 1970/2/1 00:00  |  1970/2/1 00:03  | 3      |
|   4   |   1    | 1970/2/2 00:00  |  1970/2/2 00:04  | 893    |
|   5   |   2    | 1970/1/1 00:00  |  1970/1/1 00:05  | 810    |
|   6   |   2    | 1970/1/2 00:00  |  1970/1/2 00:06  | 1919   |
|   7   |   2    | 1970/2/1 00:00  |  1970/2/1 00:07  | 514    |
|   8   |   2    | 1970/2/2 00:00  |  1970/2/1 00:08  | 114    |

1. 求每个 id 的最大 PV 日与累计到当天的 PV 和; 输出为: id, MAX_PV_DATE, SUM_PV_BY_MAX_PV_DATE;

## Hadoop

### 搭建 Hadoop 集群的主要配置文件

- core-site.xml
    - 其中
- hdfs-site.xml
    - 其中
- mapred-site.xml
    - 其中

### 正常的 Hadoop 集群进程与作用

- NameNode
    - 主节点, 负责维护整个 HDFS 文件系统的目录树, 以及每个文件所对应的 block 块信息 (元数据).
- DataNode
    - 从节点, 负责存储具体的文件数据, 并且每个 block 可以在多个 DataNode 上存储多个副本.
- Secondary NameNode
    - 相当于一个备用的 NameNode, 当 NameNode 下线之后, 可以将 Secondary NameNode 的数据备份到 NameNode 上面, 但不能备份完整数据
    - 主要负责镜像备份, 日志与镜像定期合并.

### SecondaryNode 的具体作用

Secondary NameNode 会经常向 NameNode 发送请求,是否满足 check.

当条件满足时,Secondary NameNode 将进行 CheckPoint .

这时 NameNode 滚动当前正在写的 edits, 将刚刚滚动掉的和之前 edits 文件进行合并.Secondary NameNode 下载 edits 文件, 然后将 edits 文件和自身保存的 fsimage 文件在内存中进行合并, 然后写入磁盘并上传新的 fsimage 到 nameNode, 这时 NameNode 将旧的 fsimage 用新的替换掉.

### Hadoop 大版本区别

#### 1.x

由 HDFS 与 MapReduce 组成.

- HDFS 作为文件系统.
- MapReduce 负责计算和资源调度工作.
- 由主节点 Jobtrack 和子节点 Tasktrack 组成.
- Tasktrack 负责执行任务, 任务由 Maptask 和 Reducetask 完成.

#### 2.x

由 HDFS, YARN, MapReduce 与其他程序组成.

- 将资源调度工作剥离出, 做成了独立的框架 YARN.

- 出现了双 NameNode 结构, 允许一个 StandbyNameNode (SecondaryNameNode) 负责热备, 通过 Quorum Journal Manager 实现数据同步.

#### 3.x

随着 2.x 使 Hadoop 能够承载更大的集群, 而文件系统的数据冗余也徒增, 3.x 主要负责改善可用性与资源利用率.

- HDFS 引入了纠删码功能.
- 可以有更多的 StandbyNameNode 了.
- 隔离 Client, 引入 Router 与 State Store 组成的拦截转发层对 Client 进行交互.

### HDFS 的 Block

默认保存 3 分, 每份 128 mb.
> 1.x 使用 64 mb 作为 block 大小.

### HDFS 的 Block 怎么调整大小

在配置文件 hdfs-site.xml 中加入, 所有的 DataNode 都要加.

```xml
<property>
<name>dfs.block.size</name>
<value>size=mb*1024*1024</value>
<description>调整大小</description>
</property> 
```

> 对现有的 Block 不起作用, 若要改动可以用 DistCp (distributed copy) 工具.

### HDFS 对单独一个文件调整 Block 大小

```shell
hdfs dfs -Ddfs.blocksize=size=mb*1024*1024 -put FILE_DIR HDFS_DIR 
```

### HDFS 读写过程

1. Client 和 NameNode 发起上传请求, NameNode 检查文件和目录是否存在, 返回是否可以上传.
2. NameNode 查询从节点后返回 Client 请求的第一个 Block 的目标 DataNode.
3. Client 若请求 NameNode 使用就近原则, 则向最近的 DataNode 上传数据, DataNode 与其他节点建立 Pipeline 并逐级调用.
4. Client 上传第一个 Block 到 DataNode, DataNode 以 Package 为单位向其他节点传输 Package 并创建应答队列与等待.
5. 当第一个 Block 传输完成后, Client 再次请求 NameNode 上传第二个 Block.

### HDFS 读写原理

### Hadoop 高可用

> 我备份了元数据, 当整个集群崩溃, 只剩下几个 datanode 的时候, 是否可以恢复?

### Hadoop 配置调优

- MapReduce 计算是磁盘 I/O 行为, 所以调整预读缓冲区大小 (core-site.xml > buffer.size).
- 调整 Block 的大小 (hdfs-site.xml > dfs.block.size).

### SecondaryNameNode 是干什么的

### 往 HDFS 里 put 文件时 HDFS 都做了什么

### MapReduce

#### MapReduce的工作原理

1. Client 启动一个 Job, 向 JobTracker 请求一个 JobID.
2. Client 将所需数据上传给 HDFS, 包括 MapReduce 打包的 jar 文件, 配置文件, 以及计算所需的输入划分信息; 这些文件储存在 JobTracker 的 JobID 目录中, jar 会创建多个副本, 输入划分信息对应着 JobTracker 应启动多少个 Map 任务.
3. JobTracker 将资源放入作业队列中, 调度器调度后根据输入划分信息划分 Map 任务并分发给 TaskTracker 执行.
4. TaskTracker 心跳访问 JobTracker, 访问内容包含 Map 任务进度.
5. 最后一个任务完成后, JobTracker 设置这个任务为成功, 并返回给 Client, Client 再通知给操作者.

#### Map 的运行步骤

1. Mapper 根据文件分区.
2. Sort 将 Mapper 产生的结果按照 key 进行排列.
3. Combiner 将 key 相同的记录合并.
4. Partition 把数据均衡的分发给 Reducer.
5. Shuffle 将 Mapper 的结果传输给 Reduce, 也是数据倾斜会出现的步骤.

#### 数据倾斜在 Mapper 和 Reduce 那一边发生的

在 Reduce 端. Mapper 处理完数据传给 Reduce, 此时 Reduce 会因为大量的 key 导致执行时间过长引起堵塞.

#### 如何优化数据倾斜

对数据进行清洗与治理. 可以在 Mapper 期间将大量相同的 key 打散, 比如添加 N 以内的随机数前缀; 可以对数据较多的 key 进行子扩展, 先进行局部操作, 再去除随机数后 Combiner, 避免在 Shuffle 时出现数据倾斜.

#### Mapper Combiner 后会发生什么

运行速度会提升, Mapper 到 Reduce 的数据量也会变少, 因为 Combiner 把相同的 key 合并了.

#### Map 输出的数据超出小文件内存后会发生什么

数据会写入到磁盘中. Map, Reduce 是 I/O 操作.

#### Map 到 Reduce 默认的分区机制

对 Map 中的 key 取哈希值, 对 Reduce 的个数取模.

#### 求 _SQL_ 中每个 id 的最早登录日期和最晚登录日期

> 考点是 Mapper 类中的 setUp, clear 方法.

#### _SQL_ 有 1gb 的数据, 按照 login_date 分组

1. 默认块大小时分为 8 个 Mapper.
2. 定义一个对象封装这些字段, 实现序列化和反序列化.
3. 定义一个继承 Partitioner 的类, 调用对象中的 login_date 属性设置分组.
4. 在 Map 上读取文件, 通过 Split 分割; 调用 pk_pk 作为 key, 然后局部 Sort 排序, 最后 Combiner 聚不聚合后通过 Reduce 来进行整体聚合.

#### YARN 的优势

YARN 集群以主从架构组织, 主节点 ResourceManage 负责资源调度分配, NodeMange 负责计算节点管理, 资源监控和启动应用所需的 Combiner. YARN 一般和 MapReduce 结合, 主要对 MapReduce 中的资源计算进行维护.

#### Shuffle 原理与优化

## Spark

- Spark 是基于内存计算, MapReduce 基于磁盘运算, 所以速度更快.
- Spark 拥有高效的调度算法, 基于 DAG 形成一系列有向无环图.
- Spark 通过 RDD 算子来运算, 具有转换与动作两种操作, 可以把运算结果缓存在内存, 再计算出来.
- Spark 还拥有容错机制 Linage 算子, 可以把失败的任务重新执行.

### 什么是 RDD

RDD 就是弹性分布式数据集 Resilient Distributed Datasets, 是一种不可变分布式对象集合, 每个 RDD 都被分为多个分区, 运行在集群不同节点上, 拥有多种不同的 RDD 算子.

### RDD 都有那些算子

- 转换操作中就有 map().filter(), flatMap(), groupByKey(), reduceByKey(), sortByKey(), join(), cogroup(), distinct(), sample(), union(), intersection(), cartesian(), pipe() 等.

- 动作操作中有 mapPartitions(), foreach(), collect(), count(), take(), top(), takeOrdered(), saveAsTextFile(), saveAsObjectFile(), persist(), unpersist(), checkpoint(), checkpointFile(), checkpointRDD(), getCheckpointFile() 等.

### reduceByKey 和 groupByKey 的区别

- reduceByKey 会在结果处发送至 Reducer 前, 对每个 Mapper 在本地进行 Merge; 类似于 MapReduce 中的 Combiner, 这样做使 Map 端进行一次 Reduce 后数据量会大幅度减小, 从而降低传输量, 保证 Reduce 能够更快的进行结果计算.
- groupByKey 会对每一个 RDD 中的 value 值进行聚合形成序列 Iterator, 此操作发生在 Reduce 上, 所以会传输所有的数据, 因而造成资源浪费, 同时数据流很大的时候还会造成内存溢出 OutOfMemoryError.

### SparkStreaming 在消费 Kafka 时下限, 如何保证重启后继续消费 Kafka 之前的未知

- 利用 checkPoint 机制, 每次 SparkSteaming 消费 Kafka 后将 Kafka Offsets 更新到 checkPoint, 重启后读取 checkPoint 就能继续.
- 在 SparkStreaming 中启用预写日志, 同步保存所有收到的 Kafka 数据到 HDFS 中, 故障后方便恢复到上次未知, 代价是储存空间占用.

### Spark 广播变量

Spark 中因为算子的真正逻辑是发送给 Executor 运行的, Executor 需要引用外部变量时, 可以使用广播变量. 广播变量只能在 Driver 上定义和修改变量值.

### Spark 中 job, stage, task 分别代表什么

- job 是提交给 Spark 的任务.
- stage 是每一个 job 执行需要几个阶段.
- task 是每一个 job 执行需要分为几次任务, task 是任务的最小单位, 最终运行在 Executor 中.

### Spark 累加器

累加器相当于统筹大变量, 常用于计数统计工作. 累加器通常被视为 RDD 的 map().filter() 操作的副产物.

### Spark 的工作机制

1. Client 提交 job 后, Driver 运行 main 方法并创建 SparkContext
2. 执行 RDD 算子后形成 DAG 图, 再移交给DAGScheduler 处理.
3. DAGScheduler 按照 RDD 的依赖关系划分 stage, 输入 task Scheduler 去划分 task.
4. set 分发到各个节点的 Executor, 并以多线程的方式执行 task, 一个线程一个 task, 任务结束后根据类型返回结果.

### Spark 模块

### DStream 和 DStreamGraph 的区别

## HIVE

Hive 是基于 Hadoop 的一个数据仓库工具, 可以将结构化的数据文件映射为一张数据库表, 并提供类 SQL 查询功能.

### 内部表和外部表的区别

内部表是 HIVE 管理的, 外部表是 HDFS  管理的.

删除内部表会删除元数据与储存数据; 删除外部表只会删除元数据.

### HIVE 的 UDF 怎么实现

UDF 是 Hive 提供的自定义函数工具.

### 大小表 join in 如何排列

小表放前, 左查询根据小表为主.

## HBase

### HBase 的优点

### HBase 与 MySQL 的区别

### 列式存储的特点

### HBase 的操作, 储存与扫描机制和调优

## MySQL

### 事务的隔离级别

### MySQL 的引擎都有什么

## Java

### volatile 关键字的意义

### Java 线程池有几个类型, 各自的作用

### Java 线程池的拒绝策略

### Java 锁机制

### JVM 了解多少

### JVM 内存模型

### JVM 垃圾回收

### main 方法 new 了一个类, 并调用他的 run 方法, JVM 中都发生了什么

#### G1 垃圾回收器

## Flume

### Flume Pipeline 用什么方式储存

内存或文件

### Flume 突然下线怎么办 重启后是重新输入 Flume 么

设置成文件储存

### 如何设置 Flume 偏移量

### 为什么不用 flume 直接接 hbase 呢

## Zookeeper

Zookeeper 是一个分布式协调服务, 集群由 Leader 和 Follower 组成.

### Zookeeper 的 Leader 选举机制

超过两台的 Zookeeper 集群就会选举 Leader.

Zookeeper 提供的选举算法有三种:

- LeaderElection
- AuthFastLeaderElection
- FastLeaderElection
默认的为 FastLeaderElection.

#### Zookeeper 服务端启动时选举

只有 LOOKING 寻找 Leader 服务状态的实例才会去执行选举算法.

1. 每一个 Server 发起一个投票投自己: 启动状态下集群中每一个实例都会默认自己是 Leader 并发起投票, 结束后改变 logicalClock 的值.
2. 从 recvQueue 接受其他实例发来的投票.
3. 选票后开始校验处理: 参照逻辑时钟验证选票是否为本轮投票, 是否来自 Looking 状态的实例.
4. 比较选票: 首先对比 ZXID, 以较大的作为 Leader; ZXID 相同, 则选取实例的唯一标识符, 选取较大的.
5. 统计选票; 偶数量的集群, 则判断是否有半数以上的实例接收到了相同的选票信息; 奇数量的集群, 则达到 $\frac{Example + 1}{2}$ 的服务器受到相同选票信息时完成.
6. 一旦选出 Leader, 则集群每个节点都更新自己的状态, Leader 进入 LEADING 状态, Follower 进入 FOLLOWER 状态.

#### Zookeeper 运行中的选举

1. 集群运行时 Leader 下线, 便会引起新的选举, 所有节点切换自身状态到 ELECT 状态.
2. 与启动时相同的选举流程.

### Leader 突然下线怎么办

## Kafka

### Kafka 怎么进行数据备份

备份是 0.8 版本后的功能.

一个备份数量为 n 的集群允许 n-1 个节点失效.

有一个节点作为 Leader 节点, 负责保存其他备份节点的列表, 并维持备份间状态同步.

### Consumer 在 Leader 还是 Follower 中拿去数据

读写操作都来自 Leader, Follower 只负责数据备份和心跳检测 Leader 存活状态, 并及时顶替.

### Kafka ISR 机制

Kafka 为了保持数据一致性而设计了 ISR 机制.

数据可靠主要是依赖于 Broker 中的 in-sync Replica 副本同步队列机制, 主要逻辑是制造冗余, 数据互备.

1. Leader 会维护一个与其保持同步的 Replica 集合, 然后保证这组集合至少有一个存活, 并且消息 Commit 成功.

2. Partition Leader 保持同步的 Partition Follower 集合, 当 ISR 中的 Partition Follower 完成数据的同步之后给 Leader 发送 ack.
3. 如果 Partition Follower 长时间 (Replica.lag.time.max.ms) 未向 Leader 同步数据, 则该 Partition Follower 将被踢出 ISR.
4. Partition Leader 发生故障之后, 就会从 ISR 中选举新的 Partition Leader.
5. 当 ISR 中所有 Replica 都向 Leader 发送 ACK 时, Leader 执行 Commit.

### Kafka 数据不丢失不重复

首先, Kafka 并不能完全的保证不丢失不重复.

0.11 版本前, Kafka 有两次消息传递: Producer 发送信息给 Kafka, Consumer 接受来自 Kafka 的信息.

两次传递都会影响最终结果, 且两次传递都是精确一次, 最终结果才是精确一次

- Producer 传递消息的实现中指定了三个 ACK 值, 分别为
  1. -1 / ALL: Leader Broker 会等待消息写入且 ISR 同步后相应, 这种利用 ISR 实现可靠, 但吞吐量低.
  2. 0: Producer 不理会 Broker 的处理结果, 也不处理回调, 此时只保证高吞吐.
  3. 1: 即 Kafka 默认的 ACK 相应码, Leader Broker 写入数据便相应, 不等待 ISR 同步, 只要 Leader Broker 在线就不会丢失数据.

> 默认的 Producer 级别是 at least once.

- Consumer 消息传递靠 Offset 保证. Consumer 实现中可以指定 Offset 行为, 即 ```enable.auto.commit```, 实现效果也是 at least once.

0.11 版本后, Kafka 推出来 Idempotent Producer, 完成了幂等性和事务的支持.

在这个机制中, Producer 会发送多次同样的消息, 而 Broker 只会写入一次消息, Broker 执行了消息编号去重. 幂等保证了单一分区无重复消息.

> 在 Producer 里设置 ```true=enable.idempotent```

多分区时, 为了保证同步写入的一致性, 引入事务理念, 要么全部写入, 要么全部回滚. 事务保证了多分区写入消息的完整性.

> 在 Producer 里设置 ```String something = transactional.id```

此时的 Consumer 端没有 Kafka 自带的策略去支持 exactly once 消息模式, 所以需要手搓一个逻辑, 比如自己管理 offset 的提交.

### 页缓存技术

使用 Page Cache, 磁盘顺序写, 零拷贝的方式实现,

- Kafka 在操作数据的时候会写入内存, 由操作系统决定何时把内存的数据写入磁盘.
- 磁盘顺写, 即写入文件末尾保证写入速度.
- Kafka 为了解决在应用内数据的通讯损耗, 引入了零拷贝技术, 即读操作的数据进入缓存后发送给网卡, 同时拷贝描述符而非数据给 Socket 缓存.

### kafka 数据格式都是什么

Topic 主题, 然后主题进行分区, Topic 分为 Partition, Partition 包含 Message.

### Kafka 如何清理过期数据

Kafka 的日志保存在 /kafka-logs 文件夹中, 默认七天清理.

### kafka 的 `Broker, partition, segment` 都是啥

一个 Kafka 服务器也称为 Broker, 它接受生产者发送的消息并存入磁盘; Broker 同时服务消费者拉取分区消息的请求, 返回目前已经提交的消息.

每一个 Partition 最终对应一个目录, 里面存储所有的消息和索引文件.

Segment File 又由 index file 和 data file 组成, 他们总是成对出现, 后缀 ".index" 和 ".log" 分表表示 Segment 索引文件和数据文件.

### Kafka 如何实现幂等性

### Kafka 蓄水池机制

## 算法

### 求两个字符串的公共子串最大长度

```java
String a="abcdsfasdfa";
String b="abcsdfews";
```

### 数组问题

- 有一个整数数组, 根据快速排序, 找出数组中第 K 大的数

- 给定一个数组, 定义数组大小为 n, 则 1 < k < n, 返回 k, 同时保证数存在.

- 数组 S 有 n 个整数, 随机三个整数 a, b, c 使 a + b + c = 0, 求所有可能的三元组

### 实现观察者模式

### 机器人问题

> 有一个机器人的位于一个 m × n 个网格左上角, 机器人每一时刻只能向下或者向右移动一步, 机器人试图达到网格的右下角. 问有多少条不同的路径?

### HashMap 实现原理

### 集合框架中线程安全的类有哪些
