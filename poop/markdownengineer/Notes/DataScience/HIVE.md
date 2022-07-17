# HIVE 数仓

目录

1. [HIVE 数仓](#hive-数仓)
   1. [HIVE](#hive)
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
    - sort by 不是全局排序, 其在数据进入 reducer 前完成排序; 如果进行排序, 并且设置 `mapred.reduce.tasks>1`, 则只保证每个 Reducer 的输出有序, 不保证全局有序.
    - sort by 不受 `hive.mapred.mode` 是否为 strict, nostrict 的影响.
    - sort by 的数据只能保证在同一个 Reduce 中的数据可以按指定字段排序.
    - 使用 sort by 可以指定执行的 Reduce 个数 `set mapred.reduce.task s= N`; 对输出的数据执行归并排序, 可以得到全部结果.
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
    <!-- 合并 block 减少 Task 数量 -->
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
        <name>hive.fetch.Task.conversion</name>
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
        <name>mapreduce.job.jvm.numTasks</name>
        <value>n</value>
        <description>${n} Tasks to run per JVM. -1 for unlimited.</description>
    </property>
</configuration>
```

#### HIVE CLI 调整

```shell
// 合并 Block 减少 Task 数量
set ngmr.partition.automerge = true;
// JVM 重用
set mapreduce.job.jvm.numTasks=n;
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
- Optimized Row Columnar 格式: ![orc](/asset/img/notes/orc.png)

    - HIVE 0.11 引入的储存格式, ORC 文件由数个 Stripe 组成, Stripe 实际相当于 RowGroup 概念, 大小由 4mb 到 250mb 不等, 这样做可以提升顺序读的性能.

    - 一个 ORC 文件可以分为若干个 Stripe, 每个 Stripe 由 Index Data, Row Data, Stripe Footer 三个部分组成, 其中
        - indexData: 某些列的索引数据; 一个轻量级的 index, 默认是每隔 1 万行做一个索引. 这里做的索引只是记录某行的各字段在 Row Data 中的 offset.
        - rowData: 真正的数据存储; 存的是具体的数据, 先取部分行, 对其按列进行储存, 并编码各列, 分成多个 Stream 来储存,
        - StripFooter: Stripe 的元数据信息.
    - 每个文件都有一个 File Footer, 负责存储 Stripe 的行数, Column 的数据类型信息等; 每个文件尾部有一个 PostScript, 负责记录整个文件的压缩类型和 FileFooter 的长度信息. 在读取文件时采用从后向前的顺序: 首先寻址到文件尾部读取 PostScript, 解析出 FileFooter 的长度, 再读取 FileFooter, 并解析读取 Stripe 信息.

- PARQUET: ![PARQUET](/asset/img/notes/parquet.jpg)
    - PARQUET 是面向分析性业务的列式存储格式, 文件以二进制形式储存, 其中包含文件数据和元数据, 所以此格式是自解析的.
    - 通常情况下, 储存 PARQUET 数据都会按照 Block 的大小设置_行组_的大小, 配合 Mapper 处理任务的最小单位 (1 Block) 优化任务执行并行量.

> 存储文件的查询速度总结: ORC > TextFile > Parquet
