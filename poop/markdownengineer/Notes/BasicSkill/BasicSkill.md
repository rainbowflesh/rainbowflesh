# 码农必会技能

目录

1. [码农必会技能](#码农必会技能)
   1. [Git](#git)
      1. [git 相关 svn/git 分别是? 他们有什么区别?](#git-相关-svngit-分别是-他们有什么区别)
      2. [都说 git 管理 /切分支轻量, 他们轻量在哪里, 具体原理是?](#都说-git-管理-切分支轻量-他们轻量在哪里-具体原理是)
      3. [`git rebase xxx` 发送冲突, 他的根本原因是? 不要说具体场景 `git fetch/git pull` 他们区别是?](#git-rebase-xxx-发送冲突-他的根本原因是-不要说具体场景-git-fetchgit-pull-他们区别是)
      4. [`index / local / remote / workspace` 他们是? 比如 `git add xxx` 他发生了什么?](#index--local--remote--workspace-他们是-比如-git-add-xxx-他发生了什么)
      5. [`git pull` 做了哪些工作?](#git-pull-做了哪些工作)
      6. [`git rebase` 和 `git marge` 区别是?](#git-rebase-和-git-marge-区别是)
   2. [Docker](#docker)
      1. [Dockerfile 优化](#dockerfile-优化)
      2. [`run yum install -y balabala & run yum clean cache` 这么写有问题吗?](#run-yum-install--y-balabala--run-yum-clean-cache-这么写有问题吗)
      3. [导出镜像时如何尽可能压缩体积?](#导出镜像时如何尽可能压缩体积)
      4. [如何解决 ubuntu 容器中没有 `ping, ifconfig, killall` 等命令的问题 是否需要解决这种问题?](#如何解决-ubuntu-容器中没有-ping-ifconfig-killall-等命令的问题-是否需要解决这种问题)
      5. [简单谈谈怎么用 compse 部署个 crud 系统](#简单谈谈怎么用-compse-部署个-crud-系统)
      6. [Docker 的 overlay2 storage driver 比起 overlay 有哪些改进? 是如何做到的?](#docker-的-overlay2-storage-driver-比起-overlay-有哪些改进-是如何做到的)
      7. [swarm 内部负载均衡突然死活路由不到某一个 worker 上了, 如何解决](#swarm-内部负载均衡突然死活路由不到某一个-worker-上了-如何解决)
      8. [`RUN rm -rf some_file` 镜像大小会减小吗?](#run-rm--rf-some_file-镜像大小会减小吗)
      9. [Docker Compose 概述](#docker-compose-概述)
      10. [都是 docker 轻量级, 他轻量在哪里, 从技术角度分析, 咱们都是搞技术, 不需要从产品角度分析他为什么轻量?](#都是-docker-轻量级-他轻量在哪里-从技术角度分析-咱们都是搞技术-不需要从产品角度分析他为什么轻量)
      11. [`docker volume, bind, mount` 他们区别是什么? 如何构建最小的镜像, 说说你的思路?](#docker-volume-bind-mount-他们区别是什么-如何构建最小的镜像-说说你的思路)
      12. [`docker -p/P` 他的实现原理是什么?](#docker--pp-他的实现原理是什么)
      13. [`ADD` 和 `copy` 的区别](#add-和-copy-的区别)
      14. [简述 / 阐述 docker 的网络原理, 底层实现](#简述--阐述-docker-的网络原理-底层实现)
   3. [MySQL](#mysql)
      1. [事务的隔离级别](#事务的隔离级别)
      2. [MySQL 的引擎都有什么](#mysql-的引擎都有什么)
      3. [MySQL 的最左原则](#mysql-的最左原则)
      4. [联合索引字段顺序会产生影响吗? 产生什么影响?](#联合索引字段顺序会产生影响吗-产生什么影响)
      5. [什么情况下需要建索引? 什么情况下不建?](#什么情况下需要建索引-什么情况下不建)
      6. [mysql 查看连接数和进程数?](#mysql-查看连接数和进程数)
      7. [慢查询是什么?](#慢查询是什么)
   4. [Shell](#shell)
      1. [sh 和 bash 的区别](#sh-和-bash-的区别)
      2. [如何使用 shell 实现一个爬虫, 你描述下整个过程, 会用到哪些命令?](#如何使用-shell-实现一个爬虫-你描述下整个过程-会用到哪些命令)
      3. [shell 中 `[[]] [] (()) ()` 他们区别是?](#shell-中-----他们区别是)
      4. [shell `function` 如何返回字符串](#shell-function-如何返回字符串)
      5. [shell `$# $\*` 是什么意思](#shell---是什么意思)
      6. [shell 的 $](#shell-的-)

## Git

### git 相关 svn/git 分别是? 他们有什么区别?

### 都说 git 管理 /切分支轻量, 他们轻量在哪里, 具体原理是?

### `git rebase xxx` 发送冲突, 他的根本原因是? 不要说具体场景 `git fetch/git pull` 他们区别是?

### `index / local / remote / workspace` 他们是? 比如 `git add xxx` 他发生了什么?

### `git pull` 做了哪些工作?

- `git pull` 是 `git fetch + git merge`, 将远程仓库内容拉取到本地再与本地仓库相同分支的内容进行合并.

### `git rebase` 和 `git marge` 区别是?

## Docker

### Dockerfile 优化

- 移除 apt 的 cache, 对经常变化的指令放在最后 可以优化增量部分
- 参考 nginx 的 alpine.

### `run yum install -y balabala & run yum clean cache` 这么写有问题吗?

- 有, 一个 `run` 对应一层`layer`, docker 镜像会记录每一次 `run` 直接的 diff, 上面的单独 `run yum clean cache` 并不会减小镜像大小.

### 导出镜像时如何尽可能压缩体积?

- 11

### 如何解决 ubuntu 容器中没有 `ping, ifconfig, killall` 等命令的问题 是否需要解决这种问题?

- 22

### 简单谈谈怎么用 compse 部署个 crud 系统

### Docker 的 overlay2 storage driver 比起 overlay 有哪些改进? 是如何做到的?

### swarm 内部负载均衡突然死活路由不到某一个 worker 上了, 如何解决

### `RUN rm -rf some_file` 镜像大小会减小吗?

### Docker Compose 概述

- Compose 是一个用于定义和运行多容器 Docker 应用程序的工具, 适用于所有环境: 生产, 登台, 开发, 测试以及 CI 工作流程.

### 都是 docker 轻量级, 他轻量在哪里, 从技术角度分析, 咱们都是搞技术, 不需要从产品角度分析他为什么轻量?

### `docker volume, bind, mount` 他们区别是什么? 如何构建最小的镜像, 说说你的思路?

### `docker -p/P` 他的实现原理是什么?

### `ADD` 和 `copy` 的区别

- `ADD` 能加载网络源, `copy` 只能加载本地源, `ADD` 是 `copy` 的超集.

### 简述 / 阐述 docker 的网络原理, 底层实现

## MySQL

### 事务的隔离级别

1

### MySQL 的引擎都有什么

1

### MySQL 的最左原则

左优先, 比如现在有一张表, 里面建了三个字段 ABC, 对 A 进行主键, BC 建立索引, 就相当于创建了多个索引: A 索引, (A,B) 组合索引, (A,B,C) 组合索引; 查询时, 会根据查询最频繁的放到最左边.

### 联合索引字段顺序会产生影响吗? 产生什么影响?

- 会, 最左优先原则: 要想 SQL 执行的时候能够用到联合索引, 那么联合索引中的第一个字段一定要在 where 语句中, 并且不能让该字段参与任何运算.

### 什么情况下需要建索引? 什么情况下不建?

- 那么如果查询语句的查询条件仅用到 `primary key`, 那么就不需要增加索引, 此外如果查询条件的字段是仅包含两三个值的枚举类型, 也是不需要增加索引.

### mysql 查看连接数和进程数?

- `show processlist`

### 慢查询是什么?

- SQL 的执行时间超过 MySQL 中 `long_query_time` 参数的值的时候, 会被记录到慢查询 SQL 日志文件中.

## Shell

### sh 和 bash 的区别

长得很像的两个脚本语言, bash 更年轻更先进.

### 如何使用 shell 实现一个爬虫, 你描述下整个过程, 会用到哪些命令?

分析要爬取的内容规律或者限制 (例如有没有 UA 和用户权限) ...

- 用到的工具: curl, wget, awk, sed, seq, grep, jq, iconv, sort, tac, wc

### shell 中 `[[]] [] (()) ()` 他们区别是?

- `[[]]` 是字符串表达式, `[]` 是 `test` 命令, `(())` 是数学比较表达式, `()` 为命令组 / 命令替换.

### shell `function` 如何返回字符串

### shell `$# $\*` 是什么意思

### shell 的 $

脚本调用参数标识符

- $0 Shell 本身的文件名

- $1～$n 添加到 Shell 的各参数值. $1 是第 1 参数, $2 是第 2 参数, $n 是第 n 个.

- $$
    Shell本身的PID (ProcessID)
    $$

- $! Shell 最后运行的后台 Process 的 PID

- $? 最后运行的命令的结束代码 (返回值)

- $- 使用 Set 命令设定的 Flag 一览

- $* 所有参数列表. 若 "$\*" 用 _"_ 括起来的情况, 以"$1 $2 ... $n"的形式输出所有数.

- $@ 所有参数列表. 若 "$@" 用 _"_ 括起来的情况, 以"$1" "$2" ... "$n" 的形式输出所有参数.

- $# 添加到 Shell 的参数个数
