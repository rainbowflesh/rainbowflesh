# 计算框架 Spark

目录

1. [计算框架 Spark](#计算框架-spark)
   1. [Spark](#spark)
      1. [Spark 中 job, stage, Task 分别是什么](#spark-中-job-stage-task-分别是什么)
      2. [什么是 RDD](#什么是-rdd)
         1. [reduceByKey 和 groupByKey 的区别](#reducebykey-和-groupbykey-的区别)
         2. [RDD 的创建方式](#rdd-的创建方式)
         3. [RDD 的依赖关系](#rdd-的依赖关系)
         4. [为什么要划分依赖关系](#为什么要划分依赖关系)
         5. [RDD 的缓存持久化机制](#rdd-的缓存持久化机制)
      3. [Spark 调优](#spark-调优)
         1. [修改序列化机制压缩数据量](#修改序列化机制压缩数据量)
         2. [根据作业环境, 提交任务时调整 spark-submit.sh 参数](#根据作业环境-提交任务时调整-spark-submitsh-参数)
         3. [提高并行度](#提高并行度)
         4. [RDD 的重用和持久化](#rdd-的重用和持久化)
         5. [适当广播多次使用的变量](#适当广播多次使用的变量)
         6. [避免产生 Shuffle 可以减少网络 IO 和分区间传输消耗](#避免产生-shuffle-可以减少网络-io-和分区间传输消耗)
         7. [使用 map-side 预先聚合 Shuffle](#使用-map-side-预先聚合-shuffle)
         8. [使用高性能算子](#使用高性能算子)
      4. [SparkStreaming 在消费 Kafka 时下线, 如何保证重启后继续消费](#sparkstreaming-在消费-kafka-时下线-如何保证重启后继续消费)
      5. [Spark 累加器](#spark-累加器)
      6. [Spark 的工作机制](#spark-的工作机制)
      7. [Spark 模块都有哪些](#spark-模块都有哪些)
      8. [DStream 和 DStreamGraph 的区别](#dstream-和-dstreamgraph-的区别)

## Spark

- Spark 是基于内存计算, MapReduce 基于磁盘运算, 所以速度更快.
- Spark 拥有高效的调度算法, 基于 DAG 形成一系列有向无环图.
- Spark 通过 RDD 算子来运算, 具有转换与动作两种操作, 可以把运算结果缓存在内存, 再计算出来.
- Spark 还拥有容错机制 Linage 算子, 可以把失败的任务重新执行.

### Spark 中 job, stage, Task 分别是什么

- job 是提交给 Spark 的任务, 会被拆分为多组 Task, 每一次数据的 Shuffle 都会产生一个 stage; 每次 action 都会产生一个 job.
- stage 是 job 执行需要的阶段. 划分 stage 使每一个 stage 只有窄依赖, 可以实现流计算, 同时每一个 Task 对应一个分区, 增加了 Task 的并行运行量.
- Task 是 stage 的任务执行单元, 通常和 RDD 的 Partition 数量相同, 只是处理一个 Partition 上的数据; 每个 Task 都是一个 JVM 实例, JVM 的开启与销毁会降低系统运行效率; Task 是任务的最小单位, 最终运行在 Executor 中.

### 什么是 RDD

RDD 就是弹性分布式数据集 Resilient Distributed Datasets, Spark 的数据抽象概念, 是一种不可变分布式对象集合; 每个 RDD 都被分为多个分区, 运行在集群不同节点上, 拥有多种不同的 RDD 算子.

- transformation 中有 map().filter(), flatMap(), groupByKey(), reduceByKey(), sortByKey(), join(), cogroup(), distinct(), sample(), union(), intersection(), cartesian(), pipe() 等.

- action 中有 mapPartitions(), foreach(), collect(), count(), take(), top(), takeOrdered(), saveAsTextFile(), saveAsObjectFile(), persist(), unpersist(), checkpoint(), checkpointFile(), checkpointRDD(), getCheckpointFile() 等.

#### reduceByKey 和 groupByKey 的区别

- reduceByKey 会在结果处发送至 Reducer 前, 对每个 Mapper 在本地进行 Merge; 类似于 MapReduce 中的 Combiner, 这样做使 Map 端进行一次 Reduce 后数据量会大幅度减小, 从而降低传输量, 保证 Reduce 能够更快的进行结果计算.
- groupByKey 会对每一个 RDD 中的 value 值进行聚合形成序列 Iterator, 此操作发生在 Reduce 上, 所以会传输所有的数据, 因而造成资源浪费, 同时数据流很大的时候还会造成内存溢出 OutOfMemoryError.

#### RDD 的创建方式

使用 `makeRDD` 通过集合创建, 由本地核数决定分区数量.

使用外部数据源 HDFS 的时候, 由 Block 数量决定分区数, 最低是两个.

由另一个 RDD 得出的结果创建, 即转换时创建, 会根据父 RDD 的 reduceTask 数量决定分区.

#### RDD 的依赖关系

1. 宽依赖: 多个子 RDD 的分区依赖同一个父 RDD 的 Partition.
2. 窄依赖: 父 RDD 的 Partition 至多被子 RDD 的一个 Partition 使用.

#### 为什么要划分依赖关系

有效区分算子间的关系, 有利于 DAG 图形生和运行时依赖监察;

如果将依赖关系混淆, 将会导致运行效率的分配不均.

#### RDD 的缓存持久化机制

主要通过 cache, persist, checkpoints 实现.

1. cache 与 persist:
    - cache 默认将数据存储在内存中, 靠 persist 实现,
    - persist 定义了多种数据储存策略, 如磁盘内存多副本. 数据存储在内存中会产生内存溢出, 断点失效等问题, 不能保证数据准确和安全.
    - 不改变 RDD 的依赖关系, 程序执行完成后回收缓存.
    - 触发 cache 和 persist 需要通过 action.
    - 不会开启其他 job, 一个 action 一个 job 原则.
2. checkpoints:
    - 将数据存储在 HDFS 上实现持久化.
    - 触发 checkpoints 需要通过 action, 会开启新的 job.
    - 会改变 RDD 依赖关系, 数据丢失后无法通过依赖关系恢复数据; 程序执行结束后不会回收.

### Spark 调优

#### 修改序列化机制压缩数据量

通过 Kryo 调整序列化性能.

- `conf.set("spark.serializer","org.apache.spark.serializer.KryoSerializer ")`

#### 根据作业环境, 提交任务时调整 spark-submit.sh 参数

```shell
# 配置 Executor 数量
 --num-Executors 3
# 配置 driver 内存, 单位 gb
 --driver-memory ng
# 配置 Executor 的内存大小, 单位 gb
 --Executor-memory n
# 配置 Executor cpu 核心使用个数, 单位 个
 --Executor-cores n
```

#### 提高并行度

- 设置 Task 数量: `spark.default.parallelism`, 设置后会在 Shuffle 过程中应用; 可以通过构造 SparkConf 对象时设置 `new SparkConf().set("spark.default.parallelism","500")`
- 设置 RDD 的 Partition 数量, 使用 `rdd.repartition` 重新分区, 会生成新的 RDD 并使分区变大, 同时 Task 也会变多.
- 设置参数 `sql.Shuffle.partitions = n`, 适当增大 n 的值.

#### RDD 的重用和持久化

- 适当的重用和持久化 RDD 有利于减少代码重复和重读, 通常是 ca`che 和 persist 方式持久化.
- 持久化过程中适当的使用序列化可以减少数据的大小, 从而降低内存和 cpu 占用率, 减少网络 IO 消耗和磁盘占用; 序列化后读取数据需要反序列化, 多了一次处理.
- 序列化造成了内存溢出, 就要考虑写入磁盘了.
- 为了保持数据的可靠, 可以使用双副本机制持久化.

> 一个副本时服务宕机了就得重新计算, 持久化每个数据单元, 并多做冗余互备来容错. 适合大内存场景. `StorageLevel.MEMORY_ONLY_2`.

#### 适当广播多次使用的变量

- 假设一个 job 需要 50 个 Executor, 100 个 Task, 共享 1mb 数据.
    - 在不使用广播变量的情况下 100 个 Task 就要创建 100 个共享数据副本.
    - 使用广播变量后, 50 个 Executor 创建 50 个数据副本, 并且从就近节点的 BlockManager 上 PULL 到一个节点上, 广播变量还可以减少网络 IO.

> 通过 sparkContext 的 broadcast 方法把数据转换成广播变量:

```java
val broadcastArray:Broadcast[Array[Int]]=sc.broadcast(Array(1,2,3,4,5,6))
        sc.broadcast(Array(1,2,3,4,5,6))
```

> Executor 的 BlockManager 就可以拉取该广播变量的副本获取具体的数据, 获取广播变量中的值可以通过调用其 value 方法:

```java
val array:Array[Int]=broadcastArray.value
```

> 注意:
>
> 1. RDD 没法广播, 但是 RDD 结果可以广播.
> 2. Spark 中因为算子的真正逻辑是发送给 Executor 运行的, Executor 需要引用外部变量时, 可以使用广播变量.
> 3. 广播变量只能在 Driver 上定义和修改变量值.
> 4. 若 Executor 调用了 Driver 的变量, 不使用广播时有几个 Task 就要创建几个 Driver 的变量副本. 用了广播后只创建一个副本.

#### 避免产生 Shuffle 可以减少网络 IO 和分区间传输消耗

```Java
// join 会产生 Shuffle
// 两个 RDD 相同的 key 需要通过网络 PULL 到一个节点上, 由一个 Task 执行 join
// val rdd3 = rdd1.join(rdd2)
// 广播变量和 Map 搭配的 join 操作不会产生 Shuffle
val rdd2Data=rdd2.collect()
        val rdd2DataBroadcast=sc.broadcast(rdd2Data)
// 每个 Executor 的内存都会缓存一份 rdd2 的全量数据
// 需要结合实际硬件性能考虑广播
// 在 rdd1.map() 中, 可以从 rdd2DataBroadcast 中获取 rdd2 的所有数据
// 若遍历结果表示 rdd2 中某条数据的 key 与 rdd1 的当前数据 key 相同, 就可以 join
// 再根据业务将 rdd1 与 rdd2 可连接的数据拼接成 String 或 Tuple
        val rdd3=rdd1.map(rdd2DataBroadcast)

```

#### 使用 map-side 预先聚合 Shuffle

- 一定要使用 Shuffle 的场景下, 无法使用 map 类算子替代, 则尽量使用 map-side 预聚合算子, 即在各节点对相同的 key 聚合, 类似 MapReduce 的 Combiner. 聚合后 PULL 数据就能节省磁盘和网络 IO 开销.
- 若条件允许, 使用 `reduceByKey()` 或者 `aggregateByKey()` 来替代 `groupByKey()`, 前者可以使用自定义函数聚合 key, 后者的会使全量的数据在节点间分发, 性能相对较差.

#### 使用高性能算子

1. 使用 `mapPartitions()` 替代 `map()`
    - `mapPartitions()` 类的算子每次调用会处理 Partition 中所有的数据, 相比单条处理效率高些, 但会占用大量内存.
2. 使用 `foreachPartition()` 替代 `foreach()`
    - 原理同上.
3. 使用 `Filter()` 之后进行 `coalesce()`
    - 对一个 RDD 过滤掉较多数据后可以手动减少多余的 Partition 数量.
4. 使用 `repartitionAndSortWithinPartitions()` 替代 `repartition()` 与 `sort()` 类操作
    - Spark 官方推荐在 `repartition()` 后的排序场景下使用这个名字很长的算子, 该算子可以并行执行重新分区的 shuffle 和排序.
5. 使用 `fastutil()` 优化数据格式
    - fastutil 是 java 标准集合框架的扩展库, 提供了特殊的 map, set, list, queue; fastutil 能减少内存开销. 除了一些使用外部变量的场景外, 对付某种较大集合时也可以用 fastutil 改写外部变量.

> fastutil 需要用 maven 手动引入依赖.

### SparkStreaming 在消费 Kafka 时下线, 如何保证重启后继续消费

- 利用 checkPoint 机制, 每次 SparkSteaming 消费 Kafka 后将 Kafka Offsets 更新到 checkPoint, 重启后读取 checkPoint 就能继续.
- 在 SparkStreaming 中启用预写日志, 同步保存所有收到的 Kafka 数据到 HDFS 中, 故障后方便恢复到上次未知, 代价是储存空间占用.

### Spark 累加器

累加器相当于统筹大变量, 常用于计数统计工作. 累加器通常被视为 RDD 的 map().filter() 操作的副产物.

### Spark 的工作机制

1. Client 提交 job 后, Driver 运行 main 方法并创建 SparkContext
2. 执行 RDD 算子后形成 DAG 图, 再移交给 DAGScheduler 处理.
3. DAGScheduler 按照 RDD 的依赖关系划分 stage, 输入 Task, Scheduler 去划分 Task, .
4. set 分发到各个节点的 Executor, 并以多线程的方式执行 Task, 一个线程一个 Task, 任务结束后根据类型返回结果.

### Spark 模块都有哪些

### DStream 和 DStreamGraph 的区别
