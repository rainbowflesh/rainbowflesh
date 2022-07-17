# HBase 数仓

目录

1. [HBase 数仓](#hbase-数仓)
   1. [HBase](#hbase)
      1. [HBase 的架构](#hbase-的架构)
      2. [HBase IO 流程](#hbase-io-流程)
         1. [HBase 读取数据](#hbase-读取数据)
         2. [HBase 写入数据](#hbase-写入数据)
      3. [HBase 的操作, 储存与扫描机制和调优](#hbase-的操作-储存与扫描机制和调优)
      4. [HBase 的存储结构](#hbase-的存储结构)
      5. [HBase 与 MySQL 的区别](#hbase-与-mysql-的区别)
      6. [提高 Hbase 读写性能的做法](#提高-hbase-读写性能的做法)
         1. [I](#i)
         2. [O](#o)
      7. [RowKey 设计规则](#rowkey-设计规则)

## HBase

### HBase 的架构

主要由 HMaster, HRegionServer, Zookeeper 组成, 其中:

- HRegionServer 负责数据的读写, Client 直接与 HRegionServer 通信;
    - HBase 的表根据 RowKey 的区域分成多个 Region, Region 包含区域内所有数据; RegionServer 管理多个 Region, 负责所有的读写操作.
- HMaster 负责管理 Region 的位置和 DDL.
    - 起到协调 RegionServer 的作用, 在集群处于数据恢复或动态调整负载均衡时分配 Region.
    - 监控集群所有 RegionServer 的状态.
    - 提供 DDL API,
    - 维护 table 和 Region 的元数据信息, 负载很低.
- Zookeeper 负责维护和记录整个 HBase 集群的状态.
    - Zookeeper 探测和记录 HBase 集群中服务器的状态信息; 实例宕机时会通知 Master 节点.

### HBase IO 流程

#### HBase 读取数据

1. Client 需要获知其想要读取的信息的 Region 的位置, 此时访问不需要 HMaster 参与, 只访问 Zookeeper, 从元数据表中读取到 Region 的地址和端口等数据.
2. Client 对 RegionServer 的位置信息和源数据表进行缓存, 然后在表中确定待检索 RowKey 所在的 RegionServer 信息.
3. Client 根据数据所在的 RegionServer 的访问信息发送数据读取请求.
4. RegionServer 先从 MemStore 中查找数据, 若不存在则对 StoreFile 读取数据, 最后返回给 Client.

#### HBase 写入数据

1. Client 访问 Zookeeper 从元数据表中获取 Region 信息.
2. 根据命名空间, 表明和 RowKey 从元数据中找到写入需要的 Region 信息.
3. 找到 RegionServer 后 HLog 数据到 WAL 中, 然后写入 MemStore.
4. MemStore 达到设置阈值后写入数据到磁盘的 StoreFile 中.
5. 多个 StoreFile 文件达到 `hbase.hstore.compaction.max` 和 `hbase.hstore.compactionThreshold` 大小后触发 Compact 操作同时进行版本的合并和数据删除.

### HBase 的操作, 储存与扫描机制和调优

### HBase 的存储结构

### HBase 与 MySQL 的区别

### 提高 Hbase 读写性能的做法

#### I

1. 批量写入
2. 多线程并发写入
3. BulkLoad 写入方式
4. 预先拆分 Region

#### O

1. 多线程并发读取
2. 读任务密集的可以设置更大的 BlockCache
3. 设置 BloomFilter
4. 预先拆分 Region

### RowKey 设计规则

- 限制长度 (64kb)
- 散列性 (防止 RegionServer 产生热点问题)
- 唯一性 (字段唯一)

> 热点发生在大量 Client 直接访问集群中少数节点, 会使 Region 所在的单台实例负载过高, 引起性能下降甚至不可用, 还会影响同一个 RegionServer 上的其他 Region.

Hbase RowKey 按照字典顺序进行排序, 可以按照主键+|+时间戳的哈希值的方式设计.
