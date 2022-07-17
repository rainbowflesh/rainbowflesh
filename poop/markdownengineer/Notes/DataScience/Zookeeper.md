# 分布式中间件 Zookeeper

目录

1. [分布式中间件 Zookeeper](#分布式中间件-zookeeper)
   1. [Zookeeper](#zookeeper)
      1. [Zookeeper 的 Leader 选举机制](#zookeeper-的-leader-选举机制)
         1. [Zookeeper 服务端启动时选举](#zookeeper-服务端启动时选举)
         2. [Zookeeper 运行中的选举](#zookeeper-运行中的选举)
      2. [Leader 突然下线怎么办](#leader-突然下线怎么办)

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
