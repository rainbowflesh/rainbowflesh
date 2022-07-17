# Hadoop 全家桶

目录

1. [Hadoop 全家桶](#hadoop-全家桶)
   1. [Hadoop](#hadoop)
      1. [Hadoop 常见输入格式](#hadoop-常见输入格式)
      2. [搭建 Hadoop 集群的主要配置文件](#搭建-hadoop-集群的主要配置文件)
      3. [正常的 Hadoop 集群进程与作用](#正常的-hadoop-集群进程与作用)
      4. [SecondaryNode 的具体作用](#secondarynode-的具体作用)
      5. [NameNode 出现故障如何恢复](#namenode-出现故障如何恢复)
      6. [Hadoop 的 Rack Awareness 是什么](#hadoop-的-rack-awareness-是什么)
      7. [Hadoop 大版本区别](#hadoop-大版本区别)
         1. [1.x](#1x)
         2. [2.x](#2x)
         3. [3.x](#3x)
      8. [Hadoop 高可用](#hadoop-高可用)
      9. [Hadoop 配置调优](#hadoop-配置调优)
   2. [HDFS](#hdfs)
      1. [HDFS 文件的一些概念](#hdfs-文件的一些概念)
      2. [HDFS 的 Block](#hdfs-的-block)
         1. [Block 和输入分割直接有什么区别](#block-和输入分割直接有什么区别)
         2. [HDFS 的 Block 怎么调整大小](#hdfs-的-block-怎么调整大小)
      3. [HDFS 对单独一个文件调整 Block 大小](#hdfs-对单独一个文件调整-block-大小)
      4. [Block 副本放置策略](#block-副本放置策略)
         1. [1.x 版本的 HDFS](#1x-版本的-hdfs)
         2. [2.x 版本的 HDFS](#2x-版本的-hdfs)
      5. [HDFS 写过程](#hdfs-写过程)
      6. [HDFS 读过程](#hdfs-读过程)
      7. [往 HDFS 里 put 文件时 HDFS 都做了什么](#往-hdfs-里-put-文件时-hdfs-都做了什么)
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

## Hadoop

### Hadoop 常见输入格式

- 文本输入: 默认输入格式.
- 序列文件输入: 要读取序列文件中的文件, 需要使用序列文件输入格式.
- KV 输入: 用于纯文本的输入.

### 搭建 Hadoop 集群的主要配置文件

- core-site.xml
    - 用于定义集群全局参数, 如 HDFS URL, Hadoop 临时目录等.
- hdfs-site.xml
    - 用于定义 HDFS 参数, 如节点名称, 数据节点的存放位置, 文件副本数, 文件读取权限等.
- mapred-site.xml
    - 用于定义 MapReduce 参数, 包括 JobHistory Server 和应用程序参数两部分, 如 Reduce 任务的默认个数, 任务能够使用的内存大小等.
- YARN-site.xml
    - 集群资源管理器的配置, 例如 ReSourceManager, NodeManager, Web 监控程序的端口.

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

当条件满足时, Secondary NameNode 将进行 CheckPoint .

这时 NameNode 滚动当前正在写的 Edits, 将刚刚滚动掉的和之前 Edits 文件进行合并. Secondary NameNode 下载 Edits 文件, 然后将 Edits 文件和自身保存的 fsimage 文件在内存中进行合并, 然后写入磁盘并上传新的 fsimage 到 nameNode, 这时 NameNode 将旧的 fsimage 用新的替换掉.

> `hdfs haadmin -getServiceState namenode_name` 查看状态.

### NameNode 出现故障如何恢复

1. 使用文件系统元数据副本 FsImage 启动新的 NameNode.
2. 配置新的数据节点和 Client 使其确认新启动的 NameNode 节点名称.
3. 一旦新的 NameNode 完成加载最后一个从 DataNode 接收到足够阻止报告的 CheckPoint FsImage, 它将开始为 Client 提供服务.

### Hadoop 的 Rack Awareness 是什么

应用于 NameNode 的算法, 用于确定如何放置块与其副本.

定义: 在同一机架内的 DataNode 之间将网络流量最小化, 比如 AB 副本在同一机架, C 在另一个.

### Hadoop 大版本区别

#### 1.x

由 HDFS 与 MapReduce 组成.

- HDFS 作为文件系统.
- MapReduce 负责计算和资源调度工作.
- 由主节点 Jobtrack 和子节点 Tasktrack 组成.
- Tasktrack 负责执行任务, 任务由 MapTask 和 ReduceTask 完成.

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

#### Block 和输入分割直接有什么区别

HDFS 将输入数据物理上划分为 Block; 输入拆分是映射器对数据的逻辑划分, 用于映射操作.

#### HDFS 的 Block 怎么调整大小

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

1. MapReduce 将得到的 Split 分配对应的 Task, 每个任务处理相对应的 Split, 以 Line 方式读取单行数据, 数据依次读到 `mapreduce.Task.io.sort.mb` 的环形缓冲区.

2. 读取过程中一旦达到阈值 `mapreduce.map.sort.spill.percent` 则进行溢写操作, Spiller 线程溢写到磁盘 `mapreduce.cluster.local.dir` 目录中, 期间进行 K/V 分区, 分区数由 Reduce 数决定, 默认使用 HashPartitioner.

3. 再将分区中数据按照 Key 分组和排序, 默认是字典和升序. 如果设置了 setCombinerClass 则会对每个分区中的数据进行 Combiner 操作. `output.compress` 还会压缩溢写的数据.

4. 之后 Merge 根据分区规则, 将数据归并到一个文件里等待 Reduce PULL 到一个节点上, .

5. NodeManager 将启动一个 `mapreduce_Shuffle` 服务将数据以 HTTP 的方式 PULL 到一个节点上, 到 Reduce 上. Reduce 处理达到阈值或 Map 输出达到阈值便 Merge (同一分区的一组数据会先进行归并), Sort (将归并好的数据进行排序), group (判断迭代器中的元素是否可以迭代), 处理完成后 MapReduce 将同一分区内的数据写入 HDFS.

> 其中 Reduce 的 Merge 达到阈值会触发, Sort 则是维持 Map 阶段的排序, Group 设置 `setGroupingComparatorClass` 后才会触发.

流程:

1. Client 启动一个 Job, 向 JobTracker 请求一个 JobID.
2. Client 将所需数据上传给 HDFS, 包括 MapReduce 打包的 jar 文件, 配置文件, 以及计算所需的输入划分信息; 这些文件储存在 JobTracker 的 JobID 目录中, jar 会创建多个副本, 输入划分信息对应着 JobTracker 应启动多少个 Map 任务.
3. JobTracker 将资源放入作业队列中, 调度器调度后根据输入划分信息划分 Map 任务并分发给 TaskTracker 执行.
4. TaskTracker 心跳访问 JobTracker, 访问内容包含 Map 任务进度.
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

YARN 集群以主从架构组织, 主节点 ReSourceManage 负责资源调度分配, NodeMange 负责计算节点管理, 资源监控和启动应用所需的 Combiner. YARN 一般和 MapReduce 结合, 主要对 MapReduce 中的资源计算进行维护.

### MapReduce on YARN 工作流程

1. 向 Client 提交 MapReduce Job.
2. YARN 的 ReSourceManager 进行资源分配.
3. NodeManager 加载并监控 Containers.
4. 通过 ApplicationMaster 与 ReSourceManager 进行资源的申请和状态交互, 由 NodeManagers 进行 MapReduce 运行时 Job 的管理.
5. 通过 HDFS 进行 Job 配置文件, Jar 包的节点分发.
