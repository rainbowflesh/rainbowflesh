# 目录

1. [目录](#目录)
2. [Hadoop 全家桶](#hadoop-全家桶)
   1. [Hadoop](#hadoop)
      1. [搭建 Hadoop 集群的主要配置文件](#搭建-hadoop-集群的主要配置文件)
      2. [正常的 Hadoop 集群进程与作用](#正常的-hadoop-集群进程与作用)
      3. [SecondaryNode 的具体作用](#secondarynode-的具体作用)
      4. [Hadoop 大版本区别](#hadoop-大版本区别)
         1. [1.x](#1x)
         2. [2.x](#2x)
         3. [3.x](#3x)
      5. [Hadoop 高可用](#hadoop-高可用)
      6. [Hadoop 配置调优](#hadoop-配置调优)
   2. [HDFS](#hdfs)
      1. [HDFS 文件的一些概念](#hdfs-文件的一些概念)
      2. [HDFS 的 Block](#hdfs-的-block)
      3. [HDFS 的 Block 怎么调整大小](#hdfs-的-block-怎么调整大小)
      4. [HDFS 对单独一个文件调整 Block 大小](#hdfs-对单独一个文件调整-block-大小)
      5. [Block 副本放置策略](#block-副本放置策略)
         1. [1.x 版本的 HDFS](#1x-版本的-hdfs)
         2. [2.x 版本的 HDFS](#2x-版本的-hdfs)
      6. [HDFS 写过程](#hdfs-写过程)
      7. [HDFS 读过程](#hdfs-读过程)
      8. [往 HDFS 里 put 文件时 HDFS 都做了什么](#往-hdfs-里-put-文件时-hdfs-都做了什么)
   3. [MapReduce](#mapreduce)
      1. [MapReduce 的工作原理与流程](#mapreduce-的工作原理与流程)
      2. [Map 的运行步骤](#map-的运行步骤)
      3. [MapReduce 的数据倾斜](#mapreduce-的数据倾斜)
      4. [Mapper Combiner 后会发生什么](#mapper-combiner-后会发生什么)
      5. [Map 输出的数据超出小文件内存后会发生什么](#map-输出的数据超出小文件内存后会发生什么)
      6. [Map 到 Reduce 默认的分区机制](#map-到-reduce-默认的分区机制)
      7. [Split 机制](#split-机制)
      8. [为什么 Split 不与 Block 对应](#为什么-split-不与-block-对应)
      9. [Shuffle 原理与优化](#shuffle-原理与优化)
   4. [YARN](#yarn)
      1. [YARN 的优势](#yarn-的优势)
      2. [MapReduce on YARN 工作流程](#mapreduce-on-yarn-工作流程)
   5. [HIVE](#hive)
      1. [内部表和外部表的区别](#内部表和外部表的区别)
      2. [分区和分桶的区别](#分区和分桶的区别)
         1. [分区](#分区)
         2. [分桶](#分桶)
            1. [上传到分区目录, 令分区表和数据关联](#上传到分区目录-令分区表和数据关联)
      3. [order/sort/distribute/cluster by 的区别](#ordersortdistributecluster-by-的区别)
      4. [HIVE 的数据倾斜](#hive-的数据倾斜)
         1. [针对数据内容设置合理的 Map 数量](#针对数据内容设置合理的-map-数量)
         2. [小文件合并](#小文件合并)
         3. [复杂文件增加 Map 数](#复杂文件增加-map-数)
         4. [合理设置 Reduce 数](#合理设置-reduce-数)
      5. [HIVE 的 UDF 怎么实现](#hive-的-udf-怎么实现)
      6. [HIVE 的工作流](#hive-的工作流)
      7. [HIVE 分区是否越多越好](#hive-分区是否越多越好)
      8. [HIVE 调优](#hive-调优)
         1. [hive-site.xml](#hive-sitexml)
         2. [HIVE CLI 调整](#hive-cli-调整)
      9. [HIVE 压缩](#hive-压缩)
         1. [HIVE 数据压缩](#hive-数据压缩)
            1. [压缩配置参数](#压缩配置参数)
         2. [HIVE 文件压缩](#hive-文件压缩)
   6. [HBase](#hbase)
      1. [HBase 的优点](#hbase-的优点)
      2. [HBase 与 MySQL 的区别](#hbase-与-mysql-的区别)
      3. [列式存储的特点](#列式存储的特点)
      4. [HBase 的操作, 储存与扫描机制和调优](#hbase-的操作-储存与扫描机制和调优)
   7. [Spark](#spark)
      1. [什么是 RDD, 都有那些算子](#什么是-rdd-都有那些算子)
      2. [reduceByKey 和 groupByKey 的区别](#reducebykey-和-groupbykey-的区别)
      3. [SparkStreaming 在消费 Kafka 时下限, 如何保证重启后继续消费 Kafka 之前的未知](#sparkstreaming-在消费-kafka-时下限-如何保证重启后继续消费-kafka-之前的未知)
      4. [Spark 广播变量](#spark-广播变量)
      5. [Spark 中 job, stage, Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 分别代表什么](#spark-中-job-stage-task-每个-task-都是一个-jvm-实例-jvm-的开启与销毁会降低系统运行效率-分别代表什么)
      6. [Spark 累加器](#spark-累加器)
      7. [Spark 的工作机制](#spark-的工作机制)
      8. [Spark 模块都有哪些](#spark-模块都有哪些)
      9. [DStream 和 DStreamGraph 的区别](#dstream-和-dstreamgraph-的区别)
   8. [Flume](#flume)
      1. [Flume Pipeline 用什么方式储存](#flume-pipeline-用什么方式储存)
      2. [Flume 突然下线怎么办 重启后是重新输入 Flume 么](#flume-突然下线怎么办-重启后是重新输入-flume-么)
      3. [如何设置 Flume 偏移量](#如何设置-flume-偏移量)
      4. [为什么不用 flume 直接接 hbase 呢](#为什么不用-flume-直接接-hbase-呢)
3. [中间件](#中间件)
   1. [Zookeeper](#zookeeper)
      1. [Zookeeper 的 Leader 选举机制](#zookeeper-的-leader-选举机制)
         1. [Zookeeper 服务端启动时选举](#zookeeper-服务端启动时选举)
         2. [Zookeeper 运行中的选举](#zookeeper-运行中的选举)
      2. [Leader 突然下线怎么办](#leader-突然下线怎么办)
   2. [Kafka](#kafka)
      1. [Kafka 怎么进行数据备份](#kafka-怎么进行数据备份)
      2. [Consumer 在 Leader 还是 Follower 中拿去数据](#consumer-在-leader-还是-follower-中拿去数据)
      3. [Kafka ISR 机制](#kafka-isr-机制)
      4. [Kafka 数据不丢失不重复](#kafka-数据不丢失不重复)
         1. [Kafka 如何实现幂等性](#kafka-如何实现幂等性)
      5. [Kafka 为什么速度快 - 页缓存技术](#kafka-为什么速度快---页缓存技术)
      6. [kafka 数据格式都是什么](#kafka-数据格式都是什么)
      7. [Kafka 如何清理过期数据](#kafka-如何清理过期数据)
      8. [kafka 的 `Broker, partition, segment` 都是啥](#kafka-的-broker-partition-segment-都是啥)
      9. [kafka 一条 Message 中包含哪些信息](#kafka-一条-message-中包含哪些信息)
      10. [Kafka 蓄水池机制](#kafka-蓄水池机制)
4. [基础知识](#基础知识)
   1. [SQL](#sql)
      1. [SQL 函数顺序](#sql-函数顺序)
      2. [聚合函数是否可以写在 order by 后面](#聚合函数是否可以写在-order-by-后面)
      3. [大小表 join in 如何排列](#大小表-join-in-如何排列)
      4. [MapReduce 的 SQL 题](#mapreduce-的-sql-题)
         1. [求 _SQL_ 中每个 id 的最早登录日期和最晚登录日期](#求-sql-中每个-id-的最早登录日期和最晚登录日期)
         2. [_SQL_ 有 1gb 的数据, 按照 login_date 分组](#sql-有-1gb-的数据-按照-login_date-分组)
   2. [MySQL](#mysql)
      1. [事务的隔离级别](#事务的隔离级别)
      2. [MySQL 的引擎都有什么](#mysql-的引擎都有什么)
      3. [MySQL 的最左原则](#mysql-的最左原则)
   3. [Java](#java)
      1. [volatile 关键字的意义](#volatile-关键字的意义)
      2. [Java 线程池有几个类型, 各自的作用](#java-线程池有几个类型-各自的作用)
      3. [Java 线程池的拒绝策略](#java-线程池的拒绝策略)
      4. [Java 锁机制](#java-锁机制)
      5. [JVM 了解多少](#jvm-了解多少)
      6. [JVM 内存模型](#jvm-内存模型)
      7. [JVM 垃圾回收](#jvm-垃圾回收)
         1. [G1 垃圾回收器](#g1-垃圾回收器)
      8. [main 方法 new 了一个类, 并调用他的 run 方法, JVM 中都发生了什么](#main-方法-new-了一个类-并调用他的-run-方法-jvm-中都发生了什么)
   4. [算法](#算法)
      1. [求两个字符串的公共子串最大长度](#求两个字符串的公共子串最大长度)
      2. [数组问题](#数组问题)
      3. [实现观察者模式](#实现观察者模式)
      4. [机器人问题](#机器人问题)
      5. [HashMap 实现原理](#hashmap-实现原理)
      6. [集合框架中线程安全的类有哪些](#集合框架中线程安全的类有哪些)

# Hadoop 全家桶

## Hadoop

### 搭建 Hadoop 集群的主要配置文件

- core-site.xml
    - 用于定义集群全局参数, 如 HDFS URL, Hadoop 临时目录等.
- hdfs-site.xml
    - 用于定义 HDFS 参数, 如节点名称, 数据节点的存放位置, 文件副本数, 文件读取权限等.
- mapred-site.xml
    - 用于定义 MapReduce 参数, 包括 JobHistory Server 和应用程序参数两部分, 如 Reduce 任务的默认个数, 任务能够使用的内存大小等.
- YARN-site.xml
    - 集群资源管理器的配置, 例如 ResourceManager, NodeManager, Web 监控程序的端口.

### 正常的 Hadoop 集群进程与作用

- NameNode
    - 主节点, 负责维护整个 HDFS 文件系统的目录树, 以及每个文件所对应的 Block 块信息 (元数据).
- DataNode
    - 从节点, 负责存储具体的文件数据, 并且每个 Block 可以在多个 DataNode 上存储多个副本.
- Secondary NameNode
    - 相当于一个备用的 NameNode, 当 NameNode 下线之后, 可以将 Secondary NameNode 的数据备份到 NameNode 上面, 但不能备份完整数据
    - 主要负责镜像备份, 日志与镜像定期合并.

### SecondaryNode 的具体作用

Secondary NameNode 会经常向 NameNode 发送请求,是否满足 check.

当条件满足时,Secondary NameNode 将进行 CheckPoint .

这时 NameNode 滚动当前正在写的 Edits, 将刚刚滚动掉的和之前 Edits 文件进行合并.Secondary NameNode 下载 Edits 文件, 然后将 Edits 文件和自身保存的 fsimage 文件在内存中进行合并, 然后写入磁盘并上传新的 fsimage 到 nameNode, 这时 NameNode 将旧的 fsimage 用新的替换掉.

> `hdfs haadmin -getServiceState namenode_name` 查看状态.

### Hadoop 大版本区别

#### 1.x

由 HDFS 与 MapReduce 组成.

- HDFS 作为文件系统.
- MapReduce 负责计算和资源调度工作.
- 由主节点 Jobtrack 和子节点 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 track 组成.
- Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 track 负责执行任务, 任务由 MapTask, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 和 ReduceTask, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 完成.

#### 2.x

由 HDFS, YARN, MapReduce 与其他程序组成.

- 将资源调度工作剥离出, 做成了独立的框架 YARN.

- 出现了双 NameNode 结构, 允许一个 StandbyNameNode (SecondaryNameNode) 负责热备, 通过 Quorum Journal Manager 实现数据同步.

#### 3.x

随着 2.x 使 Hadoop 能够承载更大的集群, 而文件系统的数据冗余也徒增, 3.x 主要负责改善可用性与资源利用率.

- HDFS 引入了纠删码功能.
- 可以有更多的 StandbyNameNode 了.
- 隔离 Client, 引入 Router 与 State Store 组成的拦截转发层对 Client 进行交互.

### Hadoop 高可用

> 我备份了元数据, 当整个集群崩溃, 只剩下几个 datanode 的时候, 是否可以恢复?

### Hadoop 配置调优

- MapReduce 计算是磁盘 I/O 行为, 所以调整预读缓冲区大小 (core-site.xml > buffer.size).
- 调整 Block 的大小 (hdfs-site.xml > dfs.Block.size).

## HDFS

### HDFS 文件的一些概念

- 元信息: 是数据文件的 Block 大小, 文件副本存储位置, 副本数量, Block 数量, 主要体现在 Edits 文件和 Fsimage 文件.

- 副本数: HDFS 中同一个文件在多个节点中所存储的总数量, 也是实现持久化和保证安全性的关键.

- 文件目录树: HDFS 提供了一个可以维护的文件目录, 该文件目录下存储着有关所有 HDFS 的文件.

- Block 数据节点信息: 如 a 文件在 01 和 02 节点中存储, 该信息称为数据节点信息.

- Edits: 记录 Client 执行创建,移动,修改文件的信息, 同时体现了 HDFS 的最新的状态 (二进制文件).

    - 它分布在磁盘上的多个文件, 名称由前缀 Edits 及后缀组成.后缀值是该文件包含的事务 ID,同一时刻只有一个文件处于可读写状态.为避免数据丢失,事务完成后 client 端在执行成功前,文件会进行更新和同步,当 NN 向多个目录写数据时,只有在所有操作更新并同步到每个副本之后执行才成功.

- Fsimage: 记录的是数据块的位置信息, 数据块的冗余信息 (二进制文件).

    - 由于 Edits 文件记录了最新状态信息, 并且随着操作越多, Edits 文件就会越大, 把 Edits 文件中最新的信息写到 fsimage 文件中就解决了 Edits 文件数量多不方便管理的情况. 没有体现 HDFS 的最新状态.

- 每个 fsimage 文件都是文件系统元数据的一个完整的永久性的检查点.

### HDFS 的 Block

默认保存 3 分, 每份 128 mb.

> 1.x 使用 64 mb 作为 Block 大小.

### HDFS 的 Block 怎么调整大小

在配置文件 hdfs-site.xml 中加入, 所有的 DataNode 都要加.

```xml
<property>
<name>dfs.Block.size</name>
<value>size=mb*1024*1024</value>
<description>调整大小</description>
</property>
```

> 对现有的 Block 不起作用, 若要改动可以用 DistCp (distributed copy) 工具.

### HDFS 对单独一个文件调整 Block 大小

```shell
hdfs dfs -Ddfs.Blocksize=size=mb*1024*1024 -put FILE_DIR HDFS_DIR
```

### Block 副本放置策略

#### 1.x 版本的 HDFS

1. 副本 1 放置在上传文件的 DataNode 中; 集群外提交则挑选一台磁盘和 CPU 占用率低的节点.
2. 副本 2 放置在与副本 1 不同机架的集群上.
3. 副本 3 和副本 1 放同一机架上.
4. 更多的副本随机放置.

#### 2.x 版本的 HDFS

1. 副本 1 与 1.x 版本类似.
2. 同上.
3. 放在副本 2 所在的机架上.
4. 同上.

### HDFS 写过程

1. Client 对 NameNode 发起上传请求, NameNode 检查文件和目录是否存在, 返回是否可以上传.
2. NameNode 查询从节点后返回 Client 请求的第一个 Block 的目标 DataNode.
3. Client 若请求 NameNode 使用就近原则, 则向最近的 DataNode 上传数据, DataNode 与其他节点建立 Pipeline 并逐级调用.
4. Client 上传第一个 Block 到 DataNode, DataNode 以 Package 为单位向其他节点传输 Package 并创建应答队列与等待.
5. 当第一个 Block 传输完成后, Client 再次请求 NameNode 上传第二个 Block. 此时的 Client 传输和 Block 的汇报是并行的.

### HDFS 读过程

1. Client 创建一个对象与 NameNode 进行 RPC 通信, 收到 NameNode 对象后, 请求获取文件的元数据.
2. NameNode 校验后返回元数据.
3. Client 拿到元数据后读取 DataNode 中的 Block, 并合并 Block 成单文件然后返回.

### 往 HDFS 里 put 文件时 HDFS 都做了什么

## MapReduce

### MapReduce 的工作原理与流程

原理:

1. MapReduce 将得到的 Split 分配对应的 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率, 每个任务处理相对应的 Split, 以 Line 方式读取单行数据, 数据依次读到 `mapreduce.Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率.io.sort.mb` 的环形缓冲区.

2. 读取过程中一旦达到阈值 `mapreduce.map.sort.spill.percent` 则进行溢写操作, Spiller 线程溢写到磁盘 `mapreduce.cluster.local.dir` 目录中, 期间进行 K/V 分区, 分区数由 Reduce 数决定, 默认使用 HashPartitioner.

3. 再将分区中数据按照 Key 分组和排序, 默认是字典和升序. 如果设置了 setCombinerClass 则会对每个分区中的数据进行 Combiner 操作. `output.compress` 还会压缩溢写的数据.

4. 之后 Merge 根据分区规则, 将数据归并到一个文件里等待 Reduce PULL.

5. NodeManager 将启动一个 `mapreduce_shuffle` 服务将数据以 HTTP 的方式 PULL 到 Reduce 上. Reduce 处理达到阈值或 Map 输出达到阈值便 Merge (同一分区的一组数据会先进行归并), Sort (将归并好的数据进行排序), group (判断迭代器中的元素是否可以迭代), 处理完成后 MapReduce 将同一分区内的数据写入 HDFS.

> 其中 Reduce 的 Merge 达到阈值会触发, Sort 则是维持 Map 阶段的排序, Group 设置 `setGroupingComparatorClass` 后才会触发.

流程:

1. Client 启动一个 Job, 向 JobTracker 请求一个 JobID.
2. Client 将所需数据上传给 HDFS, 包括 MapReduce 打包的 jar 文件, 配置文件, 以及计算所需的输入划分信息; 这些文件储存在 JobTracker 的 JobID 目录中, jar 会创建多个副本, 输入划分信息对应着 JobTracker 应启动多少个 Map 任务.
3. JobTracker 将资源放入作业队列中, 调度器调度后根据输入划分信息划分 Map 任务并分发给 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 Tracker 执行.
4. Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 Tracker 心跳访问 JobTracker, 访问内容包含 Map 任务进度.
5. 最后一个任务完成后, JobTracker 设置这个任务为成功, 并返回给 Client, Client 再通知给操作者.

### Map 的运行步骤

1. Mapper 根据文件分区.
2. Sort 将 Mapper 产生的结果按照 Key 进行排列.
3. Combiner 将 Key 相同的记录合并.
4. Partition 把数据均衡的分发给 Reducer.
5. Shuffle 将 Mapper 的结果传输给 Reduce, 也是数据倾斜会出现的步骤.

### MapReduce 的数据倾斜

> 数据倾斜发生在 Reduce 端. Mapper 处理完数据传给 Reduce, 此时 Reduce 会因为大量的 Key 导致执行时间过长引起堵塞.

优化数据倾斜:

对数据进行清洗与治理. 可以在 Mapper 期间将大量相同的 Key 打散, 比如添加 N 以内的随机数前缀; 可以对数据较多的 Key 进行子扩展, 先进行局部操作, 再去除随机数后 Combiner, 避免在 Shuffle 时出现数据倾斜.

### Mapper Combiner 后会发生什么

运行速度会提升, Mapper 到 Reduce 的数据量也会变少, 因为 Combiner 把相同的 Key 合并了.

### Map 输出的数据超出小文件内存后会发生什么

数据会写入到磁盘中. Map, Reduce 是 I/O 操作.

### Map 到 Reduce 默认的分区机制

对 Map 中的 Key 取哈希值, 对 Reduce 的个数取模.

### Split 机制

Spilt 是 MapReduce 中 Map 之前的概念. Split 切片大小默认为 Block 的 1.1 倍, 在 `FileInputFormat` 中计算切片大小的逻辑:

```Java
public static final String SPLIT_MAXSIZE = "mapreduce.input.fileinputformat.split.maxsize";
public static final String SPLIT_MINSIZE = "mapreduce.input.fileinputformat.split.minsize";

protected long computeSplitSize(long BlockSize, long minSize, long maxSize) {
        return Math.max(minSize, Math.min(maxSize, BlockSize));
}
```

### 为什么 Split 不与 Block 对应

大量小文件场景下 Map 进程造成的资源严重浪费.

### Shuffle 原理与优化

## YARN

### YARN 的优势

YARN 集群以主从架构组织, 主节点 ResourceManage 负责资源调度分配, NodeMange 负责计算节点管理, 资源监控和启动应用所需的 Combiner. YARN 一般和 MapReduce 结合, 主要对 MapReduce 中的资源计算进行维护.

### MapReduce on YARN 工作流程

1. 向 Client 提交 MapReduce Job.
2. YARN 的 ResourceManager 进行资源分配.
3. NodeManager 加载并监控 Containers.
4. 通过 ApplicationMaster 与 ResourceManager 进行资源的申请和状态交互, 由 NodeManagers 进行 MapReduce 运行时 Job 的管理.
5. 通过 HDFS 进行 Job 配置文件, Jar 包的节点分发.

## HIVE

HIVE 是基于 Hadoop 的一个数据仓库工具, 可以将结构化的数据文件映射为一张数据库表, 并提供类 SQL 查询功能.

### 内部表和外部表的区别

- 内部表是 HIVE 管理的, 外部表是 HDFS 管理的.
- 创建表时: 内部表会将数据移动到数仓指向的路径; 外表仅记录所在的路径, 不对数据位置做改变.
- 删除表时: 内部表会删除元数据与储存数据; 删除外部表只会删除元数据. 这样外部表相对安全, 组织和数据共享也更灵活.

> 通常情况下使用外部表保证数据安全, 中间表, 结果表则使用内部表 (管理表).

### 分区和分桶的区别

#### 分区

指按照数据表的某列或某几列进行分区, 区域从形式上可以理解为文件目录, 若大量的数据保存在一个目录下, 查询的时候会很慢而且占用大量资源.

这个时候就可以按照数据中具有特征和共同性的字段作为分区字段, 不同特征存在不同分区, 这时查询只需要按照字段名就能在特定分区下查询.

> 简单理解分区就是 HDFS 上分目录, 分桶就是分成单独文件.

#### 分桶

分桶则是对分区更细粒度的划分.

分桶将整个数据内容安装某列属性值的哈希值进行分区. 按照某一属性分为 N 个桶, 就是对该属性值的哈希值对 N 取模, 按照结果对数据分桶.

##### 上传到分区目录, 令分区表和数据关联

- 上传数据后修复表:

```shell
dfs -mkdir -p path
dfs -put path
msck repair table table_name
```

- 上传数据后添加分区

```shell
dfs -mkdir -p path
dfs -put path
alter table table_name add partition (partition_colN=partition_valueN);
```

> 直接将新的分区文件上传到 HDFS, HIVE 没有对应元数据所以无法查询到.

### order/sort/distribute/cluster by 的区别

- order by 会对所给的全部数据进行全局排序, 不管数据量, 只启动一个 Reducer 来处理.
- sort by 会根据数据量的大小启动数个 Reducer 来处理, 并且进入 Reducer 前为每个 Reducer 产生一个排序文件.
    - sort by 不是全局排序, 其在数据进入 reducer 前完成排序; 如果进行排序, 并且设置 `mapred.reduce.Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率s>1`, 则只保证每个 Reducer 的输出有序, 不保证全局有序.
    - sort by 不受 `hive.mapred.mode` 是否为 strict, nostrict 的影响.
    - sort by 的数据只能保证在同一个 Reduce 中的数据可以按指定字段排序.
    - 使用 sort by 可以指定执行的 Reduce 个数 `set mapred.reduce.Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 s= N`; 对输出的数据执行归并排序, 可以得到全部结果.
        > 注意: 可以用 Limit 子句减少数据量. 使用 Limit N 后, 传输到 Reduce 端 (单机) 的数据记录减少到 $N\times{MapNumber}$ . 否则由于数据过大可能出不了结果.
- distribute by 控制 Map 结果的分发, 将相同字段的 Map 输出分发到一个 Reducer 上处理.
- cluster by 是前两者的结合版, 当 distribute by 和 sort by 后面所跟的列名相同时, 就等同于直接使用 cluster by 该列名, 但是 cluster by 指定的列, 最终的排序结果是降序排列, 且无法指定 asc / desc.

### HIVE 的数据倾斜

> 通过 YARN 监控平台的 Task 的运行状态, 超时和失败的都可能是发生数据倾斜的地方.

数据倾斜的根源是 Key 分布不均匀, 不让数据分区, 直接在 map 端搞定, 或者在分区时清洗集中无效的 Key, 或打乱 Key 使其进入到不同的 Reduce 中.

#### 针对数据内容设置合理的 Map 数量

主要的决定因素有: input 的文件总个数, input 的文件大小, 集群设置的文件块大小.

通常情况下, 作业会通过 input 的目录产生一个或者多个 map 任务.

> map 数越多越好?

不. 如果一个任务有很多小文件 (远远小于块大小 128m), 则每个小文件也会被当做一个块, 用一个 map 任务来完成, 而一个 map 任务启动和初始化的时间远远大于逻辑处理的时间, 就会造成很大的资源浪费. 而且, 同时可执行的 map 数是受限的.

> 保证每个 map 都是 128 mb?

不. 比如有一个 127m 的文件, 正常会用一个 map 去完成, 但这个文件只有一个或者两个小字段, 却有大量记录, 如果 map 处理的逻辑比较复杂, 用一个 map 任务去做, 肯定也比较耗时.

#### 小文件合并

在 Map 前合并小文件. 例如合并小于 iAmSize 的文件:

```sql
set mapred.max.split.size = iAmSize;
set mapred.min.split.size.per.node = iAmSize;
set mapred.min.split.size.per.rack = iAmSize;
set hive.input.format = org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
```

#### 复杂文件增加 Map 数

当 Input 的文件都很大, 任务逻辑复杂, Map 执行非常慢的时候, 可以考虑增加 Map 数, 来使得每个 Map 处理的数据量减少, 从而提高任务的执行效率.

> 根据 `computeSliteSize(Math.max(minSize,Math.min(maxSize,blocksize)))` 公式调整 maxSize 最大值. 让 maxSize 最大值低于 blocksize 就可以增加 map 的个数

```sql
-- 默认值为 1 --
set mapreduce.input.fileinputformat.split.minsize = 1

-- 默认值 Long.MAXValue, 默认情况下, 切片大小 = blocksize --
set mapreduce.input.fileinputformat.split.maxsize = Long.MAXValue

-- 切片最大值, 参数如果比 blocksize 小, 则会让切片变小, 且等于配置的参数值. --
set maxsize:
-- 切片最小值, 参数调的比 blockSize 大, 则让切片变得比 blocksize 大. --
set minsize:
-- 设置 maxsize 大小为 N mb, 即单个 fileSplit 的大小为 N mb. --
set mapreduce.input.fileinputformat.split.maxsize = N*1024*1024;
```

#### 合理设置 Reduce 数

设置每一个 job 中 reduce 个数 `set mapreduce.job.reduces = N;`.

### HIVE 的 UDF 怎么实现

UDF 是 Hive 提供的自定义函数工具.

### HIVE 的工作流

1. 查询: HIVE 接口, 命令行或 Web UI 发送查询驱动程序.
2. get Plan: 驱动程序查询编译器.
3. 语法分析.
4. 语义分析.
5. 逻辑计划产生.
6. 逻辑计划优化.
7. 物理计划生成.
8. 物理计划优化.
9. 物理计划执行.
10. 返回查询结果.

### HIVE 分区是否越多越好

- HIVE 如果拥有过多的分区, 由于底层储存是在 HDFS 上的, HDFS 只存储大文件, 过多的分区会加重 NameNode 的负担.

- HIVE 会转化为 MapReduce, 再转化为多个 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率.

> 合理的分区不应该有过多的分区和文件目录, 并且每个目录下的文件应该足够大.

### HIVE 调优

> 不根据业务内容的调优都是整蛊.

#### hive-site.xml

```xml
<configuration>
    <!-- 合并 block 减少 task 数量 -->
    <property>
        <name>ngmr.partition.automerge</name>
        <value>true</value>
    </property>
    <!-- 将 n 个 block 排给单个线程处理 -->
    <property>
        <name>ngmr.partition.mergesize.mb</name>
        <value>n</value>
    </property>
    <!-- 小文件合并 -->
    <property>
        <name>hive.merge.sparkfiles</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.map.agg</name>
        <value>true</value>
    </property>
    <!-- 使用向量化查询 -->
    <property>
        <name>hive.vectorized.execution.enabled</name>
        <value>true</value>
    </property>
    <!-- cbo 优化 HIVE 查询 -->
    <property>
        <name>hive.cbo.enable</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.stats.fetch.column.stats</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.stats.fetch.partition.stats</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.compute.query.using.stats</name>
        <value>true</value>
    </property>
    <!-- 数据压缩 -->
    <property>
        <name>hive.exec.compress.intermediate</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.exec.compress.output</name>
        <value>true</value>
    </property>
    <!-- 简单 SQL 不使用 Spark -->
    <property>
        <name>hive.fetch.task.conversion</name>
        <value>more</value>
    </property>
    <!--
    有数据倾斜的时候进行负载均衡;
    group by 操作是否允许数据倾斜, 默认是false, 当设置为true时, 执行计划会生成两个 Map / Reduce 作业, 第一个 MapReduce 会将 Map 的结果随机分发到 Reduce 中, 达到负载均衡的目的来解决数据倾斜.
    -->
    <property>
        <name>hive.groupby.skewindata</name>
        <value>true</value>
    </property>
    <!-- 列裁剪, 默认为 true, 在做查询时只读取用到的列. -->
    <property>
        <name>hive.optimize.cp</name>
        <value>true</value>
    </property>
    <!-- JVM 重用 -->
    <property>
        <name>mapreduce.job.jvm.numtasks</name>
        <value>n</value>
        <description>${n} tasks to run per JVM. -1 for unlimited.</description>
    </property>
</configuration>
```

#### HIVE CLI 调整

```shell
// 合并 Block 减少 Task 数量
set ngmr.partition.automerge = true;
// JVM 重用
set mapreduce.job.jvm.numtasks=n;   
// 将 n 个 Block 排给单个线程处理
set ngmr.partition.mergesize.mb = n;
// 小文件合并
set hive.merge.sparkfiles = true;
set hive.map.agg = true;
// 使用向量化查询
set hive.vectorized.execution.enabled = true;
// cbo 优化 HIVE 查询
set hive.cbo.enable = true;
set hive.stats.fetch.column.stats = true;
set hive.stats.fetch.partition.stats = true;
set hive.compute.query.using.stats = true;
// 数据压缩
set hive.exec.compress.intermediate = true;
set hive.exec.compress.output = true;
// 有数据倾斜的时候进行负载均衡; group by 操作是否允许数据倾斜, 默认是false, 当设置为true时, 执行计划会生成两个 Map / Reduce 作业, 第一个 MapReduce 会将 Map 的结果随机分发到 Reduce 中, 达到负载均衡的目的来解决数据倾斜.
set hive.groupby.skewindata =  true;
// 列裁剪, 默认为 true, 在做查询时只读取用到的列.
set hive.optimize.cp = true;
```

### HIVE 压缩

#### HIVE 数据压缩

- 空间优先 bzip2

- 速度优先 snappy

##### 压缩配置参数

要在 Hadoop 中使用压缩, 在 mapred-site.xml 中配置如下:

```xml
<configuration>
<!-- something else... -->
    <property>
        <name>mapreduce.map.output.compress</name>
        <value>true</value>
        <description>Compress when Mapper output, true for enable.</description>
    </property>
    <property>
        <name>mapreduce.map.output.compress.codec</name>
        <value>org.apache.hadoop.io.compress.${iAmCodecName}</value>
        <description>Codec with LZO, LZ4, snappy.</description>
    </property>
    <property>
        <name>mapreduce.output.fileoutputformat.compress</name>
        <value>true</value>
        <description>Compress when Reducer output, true for enable.</description>
    </property>
    <property>
        <name>mapreduce.output.fileoutputformat.compress.codec</name>
        <value>org.apache.hadoop.io.compress.${iAmCodecName}</value>
        <description>Codec with LZO, LZ4, snappy.</description>
    </property>
    <property>
        <name>mapreduce.output.fileoutputformat.compress.type</name>
        <value>RECORD</value>
        <description>Compress logger</description>
    </property>
</configuration>
```

在 core-site.xml 中配置如下:

```xml
<configuration>
    <property>
        <name>io.compression.codecs</name>
        <!-- <value>org.apache.hadoop.io.compress.DefaultCodec</value> -->
        <!-- <value>org.apache.hadoop.io.compress.GzipCodec</value> -->
        <!-- <value>org.apache.hadoop.io.compress.BZip2Codec</value> -->
        <value>org.apache.hadoop.io.compress.Lz4Codec</value>
        <description>输入压缩阶段; Hadoop 使用文件扩展名判断是否支持某种编解码器</description>
    </property>
</configuration>
```

#### HIVE 文件压缩

HIVE 支持的存储数的格式主要有 TEXTFILE (行式存储), SEQUENCEFILE (行式存储), ORC (列式存储), PARQUET (列式存储).

- TEXTFILE 格式:
    - 默认格式, 数据不做压缩, 磁盘空间开销大, 数据解析开销大. 若使用 Bzip2 等压缩, HIVE 不会对数据进行切分, 从而无法进行并行操作.
- Optimized Row Columnar 格式:
    ![orc](/asset/img/notes/orc.png)
    - HIVE 0.11 引入的储存格式, ORC 文件由数个 Stripe 组成, Stripe 实际相当于 RowGroup 概念, 大小由 4mb 到 250mb 不等, 这样做可以提升顺序读的性能.

    - 一个 ORC 文件可以分为若干个 Stripe, 每个 Stripe 由 Index Data, Row Data, Stripe Footer 三个部分组成, 其中
        - indexData: 某些列的索引数据; 一个轻量级的 index, 默认是每隔 1 万行做一个索引. 这里做的索引只是记录某行的各字段在 Row Data 中的 offset.
        - rowData: 真正的数据存储; 存的是具体的数据, 先取部分行, 对其按列进行储存, 并编码各列, 分成多个 Stream 来储存,
        - StripFooter: Stripe 的元数据信息.
    - 每个文件都有一个 File Footer, 负责存储 Stripe 的行数, Column 的数据类型信息等; 每个文件尾部有一个 PostScript, 负责记录整个文件的压缩类型和 FileFooter 的长度信息. 在读取文件时采用从后向前的顺序: 首先寻址到文件尾部读取 PostScript, 解析出 FileFooter 的长度, 再读取 FileFooter, 并解析读取 Stripe 信息.
- PARQUET:
    ![PARQUET](/asset/img/notes/parquet.jpg)
    - PARQUET 是面向分析性业务的列式存储格式, 文件以二进制形式储存, 其中包含文件数据和元数据, 所以此格式是自解析的.
    - 通常情况下, 储存 PARQUET 数据都会按照 Block 的大小设置_行组_的大小, 配合 Mapper 处理任务的最小单位 (1 Block) 优化任务执行并行量.

## HBase

### HBase 的优点

### HBase 与 MySQL 的区别

### 列式存储的特点

### HBase 的操作, 储存与扫描机制和调优

## Spark

- Spark 是基于内存计算, MapReduce 基于磁盘运算, 所以速度更快.
- Spark 拥有高效的调度算法, 基于 DAG 形成一系列有向无环图.
- Spark 通过 RDD 算子来运算, 具有转换与动作两种操作, 可以把运算结果缓存在内存, 再计算出来.
- Spark 还拥有容错机制 Linage 算子, 可以把失败的任务重新执行.

### 什么是 RDD, 都有那些算子

RDD 就是弹性分布式数据集 Resilient Distributed Datasets, 是一种不可变分布式对象集合, 每个 RDD 都被分为多个分区, 运行在集群不同节点上, 拥有多种不同的 RDD 算子.

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

### Spark 中 job, stage, Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 分别代表什么

- job 是提交给 Spark 的任务.
- stage 是每一个 job 执行需要几个阶段.
- Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 是每一个 job 执行需要分为几次任务, Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 是任务的最小单位, 最终运行在 Executor 中.

### Spark 累加器

累加器相当于统筹大变量, 常用于计数统计工作. 累加器通常被视为 RDD 的 map().filter() 操作的副产物.

### Spark 的工作机制

1. Client 提交 job 后, Driver 运行 main 方法并创建 SparkContext
2. 执行 RDD 算子后形成 DAG 图, 再移交给 DAGScheduler 处理.
3. DAGScheduler 按照 RDD 的依赖关系划分 stage, 输入 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率 Scheduler 去划分 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率.
4. set 分发到各个节点的 Executor, 并以多线程的方式执行 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率, 一个线程一个 Task, 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率, 任务结束后根据类型返回结果.

### Spark 模块都有哪些

### DStream 和 DStreamGraph 的区别

## Flume

1

### Flume Pipeline 用什么方式储存

内存或文件

### Flume 突然下线怎么办 重启后是重新输入 Flume 么

设置成文件储存

### 如何设置 Flume 偏移量

### 为什么不用 flume 直接接 hbase 呢

# 中间件

## Zookeeper

Zookeeper 是一个分布式协调服务, 集群由 Leader 和 Follower 组成.

### Zookeeper 的 Leader 选举机制

超过两台的 Zookeeper 集群就会选举 Leader.

Zookeeper 提供的选举算法有三种:

- LeaderElection
- AuthFastLeaderElection
- FastLeaderElection 默认的为 FastLeaderElection.

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

- Consumer 消息传递靠 Offset 保证. Consumer 实现中可以指定 Offset 行为, 即 `enable.auto.commit`, 实现效果也是 at least once.

#### Kafka 如何实现幂等性

0.11 版本后, Kafka 推出来 Idempotent Producer, 完成了幂等性和事务的支持.

在这个机制中, Producer 会发送多次同样的消息, 而 Broker 只会写入一次消息, Broker 执行了消息编号去重. 幂等保证了单一分区无重复消息.

> 在 Producer 里设置 `true=enable.idempotent`

多分区时, 为了保证同步写入的一致性, 引入事务理念, 要么全部写入, 要么全部回滚. 事务保证了多分区写入消息的完整性.

> 在 Producer 里设置 `String something = transactional.id`

此时的 Consumer 端没有 Kafka 自带的策略去支持 exactly once 消息模式, 所以需要手搓一个逻辑, 比如自己管理 offset 的提交.

### Kafka 为什么速度快 - 页缓存技术

使用 Page Cache, 磁盘顺序写, 零拷贝的方式实现,

- Kafka 在操作数据的时候会写入内存, 由操作系统决定何时把内存的数据写入磁盘.
- 磁盘顺写, 即写入文件末尾保证写入速度.
- Kafka 为了解决在应用内数据的通讯损耗, 引入了零拷贝技术, 即读操作的数据进入缓存后发送给网卡, 同时拷贝描述符而非数据给 Socket 缓存.

### kafka 数据格式都是什么

Topic 主题, 然后主题进行分区, Topic 分为 Partition, Partition 包含 Message.

### Kafka 如何清理过期数据

Kafka 的日志保存在 /kafka-logs 文件夹中, 默认七天清理, 当日志满足删除条件时, 会被标注为 "delete", 此时文件只是无法被索引, 文件本身不会被删除. 当超过 `log.segment.delete.delay.ms` 时间后, 文件会被文件系统删除.

### kafka 的 `Broker, partition, segment` 都是啥

一个 Kafka 服务器也称为 Broker, 它接受生产者发送的消息并存入磁盘; Broker 同时服务消费者拉取分区消息的请求, 返回目前已经提交的消息.

每一个 Partition 最终对应一个目录, 里面存储所有的消息和索引文件.

Segment File 又由 index file 和 data file 组成, 他们总是成对出现, 后缀 ".index" 和 ".log" 分表表示 Segment 索引文件和数据文件.

### kafka 一条 Message 中包含哪些信息

包含 Header 和 Body.

一个 Kafka Message 由一个固定长度的消息头 Header 和一个变长 Body 的消息体组成.

Header 由一个字节的 magic (文件格式信息) 和四个字节的 CRC32 校验码 (判断 Body 是否正常) 组成.

当 magic 为 1 时, 会在两者中添加一个字节的数据 attributes, 用于保存文件相关的信息, 比如是否压缩.

magic 为 0 时, 则 Body 直接由 N 个字节构成一个具体键值对形式的消息.

### Kafka 蓄水池机制

# 基础知识

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

### SQL 函数顺序

顺序, 最上最优先.

1. from

2. join

3. on

4. where

5. select

6. group by

7. having

8. order by

9. limit

### 聚合函数是否可以写在 order by 后面

不可以.

order by 的执行顺序在 select 之后, 需使用重新定义的列名进行排序.

### 大小表 join in 如何排列

小表放前, 左查询根据小表为主.

### MapReduce 的 SQL 题

#### 求 _SQL_ 中每个 id 的最早登录日期和最晚登录日期

> 考点是 Mapper 类中的 setUp, clear 方法.

#### _SQL_ 有 1gb 的数据, 按照 login_date 分组

1. 默认块大小时分为 8 个 Mapper.
2. 定义一个对象封装这些字段, 实现序列化和反序列化.
3. 定义一个继承 Partitioner 的类, 调用对象中的 login_date 属性设置分组.

4. 在 Map 上读取文件, 通过 Split 分割; 调用 pk_pk 作为 Key, 然后局部 Sort 排序, 最后 Combiner 聚不聚合后通过 Reduce 来进行整体聚合.

## MySQL

### 事务的隔离级别

1

### MySQL 的引擎都有什么

1

### MySQL 的最左原则

左优先, 比如现在有一张表, 里面建了三个字段 ABC, 对 A 进行主键, BC 建立索引, 就相当于创建了多个索引: A 索引, (A,B) 组合索引, (A,B,C) 组合索引; 查询时, 会根据查询最频繁的放到最左边.

---

## Java

1

### volatile 关键字的意义

1

### Java 线程池有几个类型, 各自的作用

1

### Java 线程池的拒绝策略

1

### Java 锁机制

1

### JVM 了解多少

1

### JVM 内存模型

1

### JVM 垃圾回收

1

#### G1 垃圾回收器

### main 方法 new 了一个类, 并调用他的 run 方法, JVM 中都发生了什么

1

1

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
