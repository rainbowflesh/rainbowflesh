# DevOps

1. [DevOps](#devops)
   1. [Infrastructure as code (LaC) 思想, 你是怎么理解的?](#infrastructure-as-code-lac-思想-你是怎么理解的)
   2. [资产管理 / 配置管理他们分别是? 区别是?](#资产管理--配置管理他们分别是-区别是)
   3. [持续集成 / 持续交付他们是? 区别是?](#持续集成--持续交付他们是-区别是)
   4. [蓝绿发布是? 他的优缺点?](#蓝绿发布是-他的优缺点)
   5. [pipeline 是什么, 他有什么优势?](#pipeline-是什么-他有什么优势)
   6. [shift-left 你是怎么理解的?](#shift-left-你是怎么理解的)
   7. [Ansible 相关](#ansible-相关)
      1. [Ansible 是什么](#ansible-是什么)
      2. [Ansible 常用模块](#ansible-常用模块)
      3. [什么是 playbook](#什么是-playbook)
      4. [Ansible 是怎么工作的](#ansible-是怎么工作的)
   8. [Jenkins 相关](#jenkins-相关)
      1. [什么是持续集成?](#什么是持续集成)
      2. [为什么研发团队需要开发与测试的持续集成?](#为什么研发团队需要开发与测试的持续集成)
      3. [持续集成的成功因素有哪些?](#持续集成的成功因素有哪些)
      4. [如何在 Jenkins 中创建备份和复制文件?](#如何在-jenkins-中创建备份和复制文件)
      5. [如何将 Jenkins 从一台服务器迁移或者复制到另一台服务器?](#如何将-jenkins-从一台服务器迁移或者复制到另一台服务器)
      6. [配置 Jenkins 的 job](#配置-jenkins-的-job)
      7. [列举 Jenkins 中一些有用的插件](#列举-jenkins-中一些有用的插件)
      8. [如何保证 Jenkins 的安全?](#如何保证-jenkins-的安全)

## Infrastructure as code (LaC) 思想, 你是怎么理解的?

- 用来解决运行环境问题的一套幂等工具集, 一个 LaC 模型每次使用都会生成同样的环境, 用于持续交付.

## 资产管理 / 配置管理他们分别是? 区别是?

- 资产管理是软件, 系统和服务的组合, 用于维护和控制运营资产及设备. 其目的是优化资产在整个生命周期的质量和利用率, 提高生产正常运行时间并降低运营成本. 资产管理涉及工作管理, 资产维护, 规划和调度, 供应链管理以及环境, 健康和安全 (EHS) 举措.
- 配置管理是一种确保公司所有软件和硬件资产在任何时候都是已知并被跟踪的原则, 也就是说这些资产的任何变更都是已知且被跟踪的. 可以将配置管理看作是技术资产的一个随时更新的库存清单, 一个单一的事实来源.

## 持续集成 / 持续交付他们是? 区别是?

- 持续集成是代码完成并提交到系统时发生的自动生成和测试的过程. 代码提交之后, 它就执行提供验证的自动化流程, 然后仅将已测试和已验证的代码提交到通常称为主分支, 干线或主干的主源代码中. 持续集成将此过程自动化, 显著提高了效率. 在将任何代码与主分支合并之前, 及早确认出所有 bug.
- 持续交付是 DevOps 中的基本实践, 可确保快速, 可靠地交付软件. 尽管该过程与 DevOps 的总体概念类似, 但持续交付是一个框架, 在这里, 代码的每个组件在完成时都经过测试, 验证和提交, 从而能够随时交付软件. 持续集成是一个过程, 是持续交付的组成部分.

## 蓝绿发布是? 他的优缺点?

- 蓝绿部署是一种应用发布模式, 类似灰度更新, 将用户流量从先前版本的应用或微服务逐渐转移到几乎相同的新版本中 (两者均保持在生产环境中运行). 旧版本可以称为蓝色环境, 而新版本则可称为绿色环境. 一旦生产流量从蓝色完全转移到绿色, 蓝色就可以在回滚或退出生产的情况下保持待机, 也可以更新成为下次更新的模板.
- 并非所有环境都具有相同的正常运行时间要求或正确执行 CI/CD 流程所需的资源.

## pipeline 是什么, 他有什么优势?

- CI/CD 流程的自动化和监控的实现.

## shift-left 你是怎么理解的?

- 一种测试手段, 即在项目生命周期的早期阶段就进行测试工作, 在开发流程的早期发现并修复错误, 而不是在发布后的测试期间再发现错误.

## Ansible 相关

### Ansible 是什么

一个 Python 开发基于 ssh 的自动化运维工具, 可以实现批量系统配置, 程序部署, 命令运行等功能.

### Ansible 常用模块

模块被认为是 Ansible 的工作单元, 有幂等性.

- command: 不支持 pipeline 的命令执行模块.
- ping: ping.
- shell: 调用 shell 解析器的模块, 支持 pipeline.
- copy: 复制本机文件到远程主机, 支持设定内容和修改权限.
    - `ansible NodeName -m copy -a 'src=/dir/file dest=/dir'`
- file: 文件操作模块, 能够新建删除文件以及创建软硬连接.
    - `ansible NodeName -m file -a 'path=/dir/file owner=ownerName group=groupName mode=0777’`
- fetch: 从远程服务器拉取文件.
- yum: yum.
    - `ansible NodeName -m yum -a 'name=packageName state=present’`
- service: systemctl 或者 service.
- user: 管理用户账号.
    - `ansible NodeName -m user -a 'name=username system=yes group=root uid=2000’`
- group: 管理用户组.
- script: 在远程服务器上运行本机的脚本.

- cron: 计划任务
    - `ansible NodeName -m cron -a 'name=“crontab test” weekday=5 hour=14 minute=30 job="/usr/bin/tar -czf /opt/var.tar.gz /var"'`

### 什么是 playbook

Ansible 的配置部署于编排用的东西, yaml编写.

### Ansible 是怎么工作的

在本地机器上安装 Ansible, 以 ssh 的方式连接到远程机器.

playbook 则拆分为单条 play, 再组织成 task, 在 task 里面调用模块和插件, 根据 inventory 中定义的主机在上面以临时脚本或命令的形式运行并返回结果.

你就当是个能解码 yaml 配置的 ssh 脚本执行器就完了.

## Jenkins 相关

### 什么是持续集成?

以持续集成的最小定义即是一种研发实践, 开发人员提交代码后, 通过 Jenkins 自动审查变动并构建, 自动化测试环境进行测试验证, 没问题的更新直接发布到线上环境.

### 为什么研发团队需要开发与测试的持续集成?

自动化效率更高, 机器审查精度也高, 极大的减少了研发到上线的周期.

### 持续集成的成功因素有哪些?

- 自动维护代码仓库.
- 自动化构建 & 快速构建.
- 构建自我审查.
- 确保修改全部提交至基线
- 生产环境镜像环境中及时测试.
- 快速访问成果.
- 自动部署.

### 如何在 Jenkins 中创建备份和复制文件?

直接备份或复制 JENKINS_HOME 目录.

### 如何将 Jenkins 从一台服务器迁移或者复制到另一台服务器?

直接从旧服务器复制 jobs 目录到新服务器/

### 配置 Jenkins 的 job

- 在 Jenkins 主页创建 job: 选择 `New Job, Build a free-style software project`, 并设置配置:
- 可选的 SCM (例如源代码所在的 CVS 或 Subversion).
- 用于控制 Jenkins 何时执行构建的触发器.
- 构建用于执行实际工作的构建的脚本.
- 构建信息收集方式, 例如归档制品, 记录 java doc 和测试结果.
- 配置构建结果的通知配置 (电邮, IMS, 更新问题跟踪器等).

### 列举 Jenkins 中一些有用的插件

- Maven 2 project
- Amazon EC2
- HTML publisher
- Copy artifact
- Join
- Green Balls

### 如何保证 Jenkins 的安全?

- 确保 `global security` 配置项已经打开.
- 确保用适当的插件将 Jenkins 与企业员工目录进行集成.
- 确保启用项目矩阵的权限访问设置.
- 通过自定义版本控制的脚本来自动化 Jenkins 中设置权限 / 特权的过程.
- 限制对 Jenkins 数据 / 文件夹的物理访问.
- 定期对其进行安全审核.
