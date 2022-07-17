# Java 语言相关

1. [Java 语言相关](#java-语言相关)
   1. [Java](#java)
      1. [volatile 关键字的意义](#volatile-关键字的意义)
      2. [Java 线程池有几个类型, 各自的作用](#java-线程池有几个类型-各自的作用)
      3. [Java 线程池的拒绝策略](#java-线程池的拒绝策略)
      4. [Java 锁机制](#java-锁机制)
      5. [JVM 了解多少](#jvm-了解多少)
      6. [JVM 内存模型](#jvm-内存模型)
      7. [JVM 垃圾回收](#jvm-垃圾回收)
         1. [G1 垃圾回收器](#g1-垃圾回收器)
      8. [main 方法 new 了一个类, 并调用他的 run 方法, JVM 中都发生了什么](#main-方法-new-了一个类-并调用他的-run-方法-jvm-中都发生了什么)

## Java

1. `StringBuffer` 和 `StringBuilder` 的区别.

    - 两者底层都是 `char[], StringBuilder` 不是线程安全的类, `StringBuffer` 是线程安全的类, 其实现线程安全的方法是给每个方法加上了 `synchronized`.

2. `ThreadLocal` 是什么.

    - `ThreadLocal` 是无并发的线程安全容器, 其内部自己实现了一个 Map 数据结构, key 是线程的 id, value 是线程的值.

3. java 程序产生内存溢出的排查过程.
    - 设置 Xmx 小一点, 这样最终产生的 dump 文件方便分析, 使用 jhat 或者 jvisualvm 分析 dump 文件, 注重观察占用最多 bytes 的类是什么并分析这些类为什么没有被 jvm 回收从而导致 oom.

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
