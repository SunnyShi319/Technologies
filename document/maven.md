# Maven
#### 通过一小段描述信息管理项目的构建，报告和文档的软件项目管理工具
#### Based on the concept of a project object model(POM), Maven can manage a project's build, reporting and documentation from a central piece of information.

## 参考

[@Maven1](http://www.oracle.com/technetwork/cn/community/java/apache-maven-getting-started-1-406235-zhs.html)
[@Maven2](http://www.oracle.com/technetwork/cn/community/java/apache-maven-getting-started-2-405568-zhs.html)
## 用处

| 目录      |    目的 |
| :-------- | :-------|
| ${basedir}   | 存放 pom.xml和所有的子目录 |
| ${basedir}/src/main/java     |   项目的 java源代码 |
| ${basedir}/src/main/resources      |    项目的资源，比如说 property文件 |
| ${basedir}/src/test/java      |  项目的测试类，比如说 JUnit代码  |
| ${basedir}/src/test/resources |  测试使用的资源                 |

## 示例
如链接地址上的示例测试

## POM(Project Object Model)
一个项目所有的配置都放置在POM文件中:定义项目的类型、名字，管理依赖关系，定制插件的行为等等。
在 POM 中，groupId, artifactId, packaging, version 叫作 maven 坐标，它能唯一的确定一个项目。
有了 maven 坐标，我们就可以用它来指定我们的项目所依赖的其他项目，插件，或者父项目。
一般 maven 坐标写成如下的格式：
```
groupId:artifactId:packaging:version
```

## Maven库
当第一次运行 maven 命令的时候，你需要 Internet 连接，因为它要从网上下载一些文件。
那么它是从 maven 默认的远程库(http://repo1.maven.org/maven2) 下载的。
这个远程库有 maven 的核心插件和可供下载的 jar 文件。
当maven查找需要的jar文件时，它会在本地库中寻找，只有在找不到的情况下，才会去远程库中寻找。

## 应用
具体在Eclipse中的使用，可以通过google来搜索。
