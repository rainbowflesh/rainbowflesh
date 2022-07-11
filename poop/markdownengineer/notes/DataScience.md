# 数据科学

1. [数据科学](#数据科学)
   1. [测试环境配置](#测试环境配置)

## 测试环境配置

以 Rocky Linux 作为操作系统:

1. 下载本地部署的镜像, 11 个 g 大的那个.

2. 安装, 软件包选择 server, 进入系统后先 ```yum update```.

3. 改大字体 ```setfont lat4-19```, 运行 ```nmtui```, 把网连上, 固定 IP, 配置 DNS balabala.

4. ```yum install -y git zsh```

5. 配置 git 的代理, ```git config --global http.proxy http://ip:port```

6. ```sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```

7. ```git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions```
8. ```git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting```

9. zshrc 里 配置一下 plugins 和 themes.

10. 创建普通用户一个.

11. 下载各种环境和工具 ```wget everything```

12. 添加一堆环境变量在 /etc/profile 里:

    ```shell
    export JAVA_HOME=/usr/local/jdk-version
    export HADOOP_HOME=/usr/local/hadoop-version
    export HIVE_HOME=/usr/local/hive-version
    export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin
    # etc ...
    ```

13. 配置 hadoop 注意 root 用户要在 sbin/start-dfs 添加用户指定:

    ```shell
    HDFS_DATANODE_USER=root
    HADOOP_SECURE_DN_USER=hdfs
    HDFS_NAMENODE_USER=root
    HDFS_SECONDARYNAMENODE_USER=root
    ```
