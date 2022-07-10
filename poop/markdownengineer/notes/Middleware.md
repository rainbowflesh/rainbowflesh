# 中间件

1. [中间件](#中间件)
   1. [Kafka](#kafka)

## Kafka

1. kafka 如何保持数据可靠? ISR 是什么? 他的工作机制是?

    - 数据可靠主要是依赖于 broker 中的 in-sync replica 副本同步队列机制, 主要逻辑是制造冗余, 数据互备, 实现机制是通过 leader 维持一个与其保持同步的 replica 集合, 然后保证这组集合至少有一个存活, 并且消息 commit 成功. Partition leader 保持同步的 Partition Follower 集合, 当 ISR 中的 Partition Follower 完成数据的同步之后给 leader 发送 ack. 如果 Partition follower 长时间 (replica.lag.time.max.ms) 未向 leader 同步数据, 则该 Partition Follower 将被踢出 ISR. Partition Leader 发生故障之后, 就会从 ISR 中选举新的 Partition Leader.

2. kafka 相关 `broker, partition, segment` 他们是都是什么? 他们关系是什么?
    - 一个 Kafka 服务器也称为 Broker, 它接受生产者发送的消息并存入磁盘; Broker 同时服务消费者拉取分区消息的请求, 返回目前已经提交的消息.
    - 每一个 Partition 最终对应一个目录, 里面存储所有的消息和索引文件.
    - Segment File 又由 index file 和 data file 组成, 他们总是成对出现, 后缀 ".index" 和 ".log" 分表表示 Segment 索引文件和数据文件.
