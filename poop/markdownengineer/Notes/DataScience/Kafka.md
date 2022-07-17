# 分布式中间件 Kafka

目录

1. [分布式中间件 Kafka](#分布式中间件-kafka)
   1. [Kafka](#kafka)
      1. [相关概念](#相关概念)
         1. [ISR, AR, HW, LEO](#isr-ar-hw-leo)
         2. [Kafka 拦截器, 序列化器, 分区器](#kafka-拦截器-序列化器-分区器)
         3. [kafka 数据格式都是什么](#kafka-数据格式都是什么)
         4. [kafka 的 `Broker, partition, segment` 都是啥](#kafka-的-broker-partition-segment-都是啥)
         5. [kafka 一条 Message 中包含哪些信息](#kafka-一条-message-中包含哪些信息)
      2. [Kafka 数据积压, 消费能力不足怎么处理](#kafka-数据积压-消费能力不足怎么处理)
      3. [Kafka 分区](#kafka-分区)
         1. [分区的增删](#分区的增删)
         2. [Kafka 自带的 Topic](#kafka-自带的-topic)
         3. [分区的分配的概念](#分区的分配的概念)
      4. [Kafka 怎么进行数据备份](#kafka-怎么进行数据备份)
      5. [Consumer 在 Leader 还是 Follower 中拿去数据](#consumer-在-leader-还是-follower-中拿去数据)
      6. [Kafka 数据一致性 ISR 机制](#kafka-数据一致性-isr-机制)
      7. [Kafka 数据不丢失不重复](#kafka-数据不丢失不重复)
         1. [不重复原理](#不重复原理)
         2. [Kafka 如何实现幂等性](#kafka-如何实现幂等性)
      8. [Kafka 重复消费与漏消费](#kafka-重复消费与漏消费)
         1. [重复消费](#重复消费)
         2. [漏消费](#漏消费)
      9. [Kafka 数据顺序与消息顺序](#kafka-数据顺序与消息顺序)
         1. [解决数据顺序](#解决数据顺序)
         2. [Kafka 体现消息有序性](#kafka-体现消息有序性)
      10. [Kafka 为什么速度快](#kafka-为什么速度快)
      11. [Kafka 如何清理过期数据](#kafka-如何清理过期数据)
      12. [Kafka 蓄水池机制](#kafka-蓄水池机制)

## Kafka

### 相关概念

#### ISR, AR, HW, LEO

- ISR: 与 leader 保持同步的 follower 集合叫做 in-sync-replicas.
- AR: 可用的 replica 集合叫做 available replicas.
- HW: 消息的最大序号叫做 high watermark.
- LEO: 消息的最后序号叫做 last enqueued offset.

#### Kafka 拦截器, 序列化器, 分区器

- 拦截器分为两种: 生产拦截器和消费拦截器. 生产拦截器可以在消息发送前做预处理工作; 支持配置多个拦截器形成拦截链.
- 生产者需要将消息对象进行序列化成字节码才能通过网络传输给 Kafka 服务端, 且消费者需要反序列化, 序列化器也要一致.
- 如果消息 ProducerRecord 中指定了 partition 字段, 那么就不需要分区器来处理, 因为 partition 代表的就是所要发往的分区号; 如果没有指定, 则需要分区器进行分配.

#### kafka 数据格式都是什么

Topic 主题, 然后主题进行分区, Topic 分为 Partition, Partition 包含 Message.

#### kafka 的 `Broker, partition, segment` 都是啥

一个 Kafka 服务器也称为 Broker, 它接受生产者发送的消息并存入磁盘; Broker 同时服务消费者拉取分区消息的请求, 返回目前已经提交的消息.

每一个 Partition 最终对应一个目录, 里面存储所有的消息和索引文件.

Segment File 又由 index file 和 data file 组成, 他们总是成对出现, 后缀 ".index" 和 ".log" 分表表示 Segment 索引文件和数据文件.

#### kafka 一条 Message 中包含哪些信息

包含 Header 和 Body.

一个 Kafka Message 由一个固定长度的消息头 Header 和一个变长 Body 的消息体组成.

Header 由一个字节的 magic (文件格式信息) 和四个字节的 CRC32 校验码 (判断 Body 是否正常) 组成.

当 magic 为 1 时, 会在两者中添加一个字节的数据 attributes, 用于保存文件相关的信息, 比如是否压缩.

magic 为 0 时, 则 Body 直接由 N 个字节构成一个具体键值对形式的消息.

### Kafka 数据积压, 消费能力不足怎么处理

- Kafka 可以同步增加 Topic 的分区量和消费者数量, 消费者数 = 分区数.
- 下游应用消费能力不足时, 可以提高每批次 PULL 的数量, 供不应求策略.

### Kafka 分区

#### 分区的增删

- 增加: $KAFKA_HOME/bin/kafka-topics.sh --etc --alter --topic topic-config --partitions 数量
- 减少: 木里 desu; 被删除的分区数据难以处理.

#### Kafka 自带的 Topic

\_\_consumer_offsets, 用来保护消费者的 offset.

#### 分区的分配的概念

一个 topic 多个分区, 一个消费者组含有多个消费者, 故需要将分区分配个消费者 (round robin, range).

### Kafka 怎么进行数据备份

备份是 0.8 版本后的功能.

一个备份数量为 n 的集群允许 n-1 个节点失效.

有一个节点作为 Leader 节点, 负责保存其他备份节点的列表, 并维持备份间状态同步.

### Consumer 在 Leader 还是 Follower 中拿去数据

读写操作都来自 Leader, Follower 只负责数据备份和心跳检测 Leader 存活状态, 并及时顶替.

### Kafka 数据一致性 ISR 机制

数据可靠主要是依赖于 Broker 中的 in-sync Replica 副本同步队列机制, 主要逻辑是制造冗余, 数据互备.

1. Leader 会维护一个与其保持同步的 Replica 集合, 然后保证这组集合至少有一个存活, 并且消息 Commit 成功.
2. Partition Leader 保持同步的 Partition Follower 集合, 当 ISR 中的 Partition Follower 完成数据的同步之后给 Leader 发送 ack.
3. 如果 Partition Follower 长时间 (Replica.lag.time.max.ms) 未向 Leader 同步数据, 则该 Partition Follower 将被踢出 ISR.
4. Partition Leader 发生故障之后, 就会从 ISR 中选举新的 Partition Leader.
5. 当 ISR 中所有 Replica 都向 Leader 发送 ACK 时, Leader 执行 Commit.

### Kafka 数据不丢失不重复

tldr:

- Consumer: 业务逻辑成功处理后手动提交 offset.
- 保证不重复消费: 使用主键或唯一索引的方式避免重复数据.
- 业务逻辑处理: 选择主键或唯一索引存储在 K/V 数据库里.

#### 不重复原理

首先, Kafka 并不能完全的保证消息不重复.

0.11 版本前, Kafka 有两次消息传递: Producer 发送信息给 Kafka, Consumer 接受来自 Kafka 的信息.

两次传递都会影响最终结果, 且两次传递都是精确一次, 最终结果才是精确一次

- Producer 传递消息的实现中指定了三个 ACK 值, 分别为
    1. -1 / ALL: Leader Broker 会等待消息写入且 ISR 同步后相应, 这种利用 ISR 实现可靠, 但吞吐量低.
    2. 0: Producer 不理会 Broker 的处理结果, 也不处理回调, 此时只保证高吞吐.
    3. 1: 即 Kafka 默认的 ACK 相应码, Leader Broker 写入数据便相应, 不等待 ISR 同步, 只要 Leader Broker 在线就不会丢失数据.

> 默认的 Producer 级别是 at least once.

- Consumer 消息传递靠 Offset 保证. Consumer 实现中可以指定 Offset 行为, 即 `enable.auto.commit`, 实现效果也是 at least once.

#### Kafka 如何实现幂等性

0.11 版本后, Kafka 推出来 Idempotent Producer, 完成了幂等性和事务的支持.

在这个机制中, Producer 会发送多次同样的消息, 而 Broker 只会写入一次消息, Broker 执行了消息编号去重. 幂等保证了单一分区无重复消息.

> 在 Producer 里设置 `true=enable.idempotent`

多分区时, 为了保证同步写入的一致性, 引入事务理念, 要么全部写入, 要么全部回滚. 事务保证了多分区写入消息的完整性.

> 在 Producer 里设置 `String something = transactional.id`

此时的 Consumer 端没有 Kafka 自带的策略去支持 exactly once 消息模式, 所以需要手搓一个逻辑, 比如自己管理 offset 的提交.

### Kafka 重复消费与漏消费

#### 重复消费

Consumer 消费后没有 commit offset.

通常由程序突然下线, 消费耗时长, 自动提交 offset 失败.

#### 漏消费

先提交 offset 后 consume, 有可能造成数据的重复.

### Kafka 数据顺序与消息顺序

#### 解决数据顺序

- 相同订单的数据发送到同一分区.
- 采用 Kafka 的 Partitioner 分区策略:
    1. 指定数据目标的发送分区.
    2. 根据数据的 key 获取 hashCode 进行分区.
    3. 轮询分区.
    4. 手动指定分区.
- Flume 整合 Kafka 顺序性.

#### Kafka 体现消息有序性

每个分区内的每条消息都有 offset, 只能保证分区内有序.

为了保证整个 topic 有序, 需要调整 partition 为 1.

### Kafka 为什么速度快

- 页缓存技术
    - Kafka 在操作数据的时候会写入内存, 由操作系统决定何时把内存的数据写入磁盘.
- 磁盘顺写, 即写入文件末尾保证写入速度.
- Kafka 为了解决在应用内数据的通讯损耗, 引入了零拷贝技术, 即读操作的数据进入缓存后发送给网卡, 同时拷贝描述符而非数据给 Socket 缓存.

### Kafka 如何清理过期数据

Kafka 的日志保存在 /kafka-logs 文件夹中, 默认七天清理, 当日志满足删除条件时, 会被标注为 "delete", 此时文件只是无法被索引, 文件本身不会被删除. 当超过 `log.segment.delete.delay.ms` 时间后, 文件会被文件系统删除.

### Kafka 蓄水池机制
