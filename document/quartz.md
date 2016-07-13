# Quartz
[Quartz官网](http://www.quartz-scheduler.org/)

[Quartz Source Code](https://github.com/quartz-scheduler/quartz)

Quartz是OpenSymphony开源组织在Job scheduling领域的一个开源项目，可以与J2EE与J2SE应用程序相结合也可以单独使用。

Quartz可以用来创建简单或为运行十个、百个、甚至是好几万个Jobs这样复杂的程序，Jobs可以做成标准的Java组件或EJBs。

## 调度器
Quartz框架的核心是调度器。调度器负责管理Quartz应用运行时环境。调度器不是靠自己做所有的工作，而是依赖框架内一些非常重要的部件。

Quartz不仅仅是线程和线程管理。为确保可伸缩性，Quartz采用了基于多线程的架构。
启动时，框架初始化一套Worker线程，这套线程被调度器用来执行预定的作业。
Quartz依赖一套松耦合的线程池管理部件来管理线程环境.