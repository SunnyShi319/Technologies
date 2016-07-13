#Log4J
[Log4J Apache 2.x官网](http://logging.apache.org/log4j/2.x)

# Log Module

## Document History
### 1. Introduction
***
The log module provides the function that system can log messages when it was wrong.
The log  is divided into several levels, there are debug, info, warn, error, etc.
In the system, we use log4j to implement this function.
When we want to solve the bug, we can search the log files.
The report will show how to use log4j to record the messages.

### 2. Architecture & Key Document
#### 2.1 Key Document
**log4j.jar:**
If we want to use API of log4j to log messages, you should import the log4j.jar, because this document encapsulates all of the function of log4j.
In Liferay Project, the log4j.jar is built-in, so we shouldn’t import the log4j.jar by ourselves.

**log4j.xml:**
In this document, it stores the log configurations, you can configure this document to implement different functions.
For example, you can change the log level of a library.

**log4j.properties:**
The use of this document is the same as log4j.xml, so it is also used to configure the format of the log.
You can customize the log4j.propertities to append the log to a file where you want to store.
But there are two differences between log4j.xml and log4j.propertities.
The one is that PropertyConfiguretor can not handle the advanced configuration features supported by DOMConfigurator such as support for Filters, custom ErrorHandler, etc.
The another one is that when log4j.xml insert into database, it's sql will be put into a parameter called ConversionPattern, however, log4j.properties has it's individual parameter called sql.
So, we always use log4j.xml to configure the format of the log.

#### 2.2 level of log
| Status Code   | Description                                                                                       |
| ------------- | ------------------------------------------------------------------------------------------------- |
| DEBUG         | The debug level is most useful in debugging the application.                                      |
| INFO          | The info level will roughly display the progress of the application.                              |
| WARN          | The warn level designates potentially harmful situations.                                         |
| ERROR         | The error level designates the error event that the application can still run.                    |

### 3. Detail Design
***
#### 3.1 Using the Enterprise Admin Portlet
We can click the Controller Panel in the Admin Portlet and then choose the server tag. You can change the log level for many of packages of Liferay and main libraries.
You can select a different log level for each of the paragraphs, from debug to fatal.
Once you click the save button to submit your changes, you can do this operation as many time as desired.
The changes are stored in memory, so if you reboot the server, the data will not be exist.
If you want to keep your configuration exist, you should configure the portal-log4j.xml in webapps/ROOT/WEB-INF/lib/portal-impl.jar/META-INF.

#### 3.2 Creating a custom configuration file:
##### 3.2.1 log4j.propertities
It is another way to configure the log.
The common core Objects in log4j are Logger, Layout and Appender.
Other common Objects like Level and Filter are the support objects.
The following is the syntax of a appender X in log4j.properties:
> \# Define the root logger with appender X
> log4j.rootLogger = DEBUG, X

> \# Set the appender named X to be a File appender
> log4j.appender.X=org.apache.log4j.FileAppender

> \# Define the layout for X appender
> log4j.appender.X.layout=org.apache.log4j.PatternLayout
> log4j.appender.X.layout.conversionPattern=%m%n

For example:
```
# Define the root logger with appender file
log4j.rootLogger = DEBUG, FILE

# Define the file appender
log4j.appender.FILE=org.apache.log4j.FileAppender
log4j.appender.FILE.File=${log}/log.out

# Define the layout for file appender
log4j.appender.FILE.layout=org.apache.log4j.PatternLayout
log4j.appender.FILE.layout.conversionPattern=%m%n

```
* Define the level of the root logger as DEBUG and connect to the appender FILE.
* Define the FILE appebder and designate where the log file will output.
* Define the layout of the FILE appender as %m%n, it means when printing the log it will add Line Feed automatically.

Customize the log4j.properties file to append the logs: `log4j.appender.CONSOLE = org.apache.log4j.FileAppender`.
We also can specify where the log file is: `log4j.appender.CONSOLE.File = /home/user/logs/test.log`.
If you follow these steps you will find the logs file in /home/user/logs/.

##### 3.2.2 log4j.xml
We configure the log in a file called log4j.xml. We can override all of it or several parts of it and deploy it to the appropriate place.
Firstly, we should get a copy of configuration file named log4j.xml from the path like “portal-impl/classes/META-INF/”.
We also can look for the portal-impl.jar, inside of this document, the log4j.xml file will be found.
You only should modified entries, delete the other entries. One of the configuration is that we can change the log in this file. For example,
before:

```
<category name=”org.Spring”>
    <priority value=”ERROR”>
</category>
```

after:
```
<category name=”org.Spring”>
	<priority value=”INFO”>
</category>
```
We also can change other attributes and add other tags like appender, logger, root, etc.
Here are three exmaples about configuring format of log in different files as follows:
**Example 1:**
log4j.properties:
```
# Set root logger level to DEBUG and its only appender to A1.
log4j.rootLogger=DEBUG, A1

# A1 is set to be a ConsoleAppender.
log4j.appender.A1=org.apache.log4j.ConsoleAppender

# A1 uses PatternLayout.
log4j.appender.A1.layout=org.apache.log4j.PatternLayout
log4j.appender.A1.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n

```
log4j.xml
```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
  <!-- A1 is set to be a ConsoleAppender -->
  <appender name="A1" class="org.apache.log4j.ConsoleAppender">
    <!-- A1 uses PatternLayout -->
    <layout class="org.apache.log4j.PatternLayout">
      <param name="ConversionPattern" value="%-4r [%t] %-5p %c %x - %m%n"/>
    </layout>
  </appender>
  <root>
    <!-- Set root logger level to DEBUG and its only appender to A1 -->
    <priority value ="debug" />
    <appender-ref ref="A1" />
  </root>
</log4j:configuration>

```

**Example 2:**
log4j.properties:
```
log4j.rootLogger=DEBUG, A1
log4j.appender.A1=org.apache.log4j.ConsoleAppender
log4j.appender.A1.layout=org.apache.log4j.PatternLayout

# Print the date in ISO 8601 format
log4j.appender.A1.layout.ConversionPattern=%d [%t] %-5p %c - %m%n

# Print only messages of level WARN or above in the package com.foo.
log4j.logger.com.foo=WARN

```
log4j.xml:
```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
  <appender name="A1" class="org.apache.log4j.ConsoleAppender">
    <layout class="org.apache.log4j.PatternLayout">
      <!-- Print the date in ISO 8601 format -->
      <param name="ConversionPattern" value="%d [%t] %-5p %c - %m%n"/>
    </layout>
  </appender>
  <logger name="com.foo">
    <!-- Print only messages of level warn or above in the package com.foo -->
    <level value="warn"/>
  </logger>
  <root>
    <priority value ="debug" />
    <appender-ref ref="A1" />
  </root>
</log4j:configuration>

```

**Example 3:**
log4j.properties:
```
log4j.rootLogger=debug, stdout, R

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout

# Pattern to output the caller's file name and line number.
log4j.appender.stdout.layout.ConversionPattern=%5p [%t] (%F:%L) - %m%n

log4j.appender.R=org.apache.log4j.RollingFileAppender
log4j.appender.R.File=example.log

log4j.appender.R.MaxFileSize=100KB
# Keep one backup file
log4j.appender.R.MaxBackupIndex=1

log4j.appender.R.layout=org.apache.log4j.PatternLayout
log4j.appender.R.layout.ConversionPattern=%p %t %c - %m%n

```
log4j.xml
```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
  <appender name="stdout" class="org.apache.log4j.ConsoleAppender">
    <layout class="org.apache.log4j.PatternLayout">
      <!-- Pattern to output the caller's file name and line number -->
      <param name="ConversionPattern" value="%5p [%t] (%F:%L) - %m%n"/>
    </layout>
  </appender>
  <appender name="R" class="org.apache.log4j.RollingFileAppender">
    <param name="file" value="example.log"/>
    <param name="MaxFileSize" value="100KB"/>
    <!-- Keep one backup file -->
    <param name="MaxBackupIndex" value="1"/>
    <layout class="org.apache.log4j.PatternLayout">
      <param name="ConversionPattern" value="%p %t %c - %m%n"/>
    </layout>
  </appender>
  <root>
    <priority value ="debug" />
    <appender-ref ref="stdout" />
    <appender-ref ref="R" />
  </root>
</log4j:configuration>

```

If you have done this, the file will be deployed to a directory called project-name/WEB-INF/classes.



#### 3.4 Loading configuration file of log
If you put the configuration file into the directory src/main/resources, the project will load the configuration file automatically.
If you want to load the configuration file manually, you can follow these two ways

##### 3.4.1 Configuring web.xml
One of the ways is that you can add a tag `<context-param>` to web.xml.
Once the server runs, web.xml will be load.
The detail configuration is as follows:
```
<context-param>
     <param-name>log4jConfigLocation</param-name>
     <param-value>classpath:log4j.properties</param-value>
</context-param>

```
If you choose this way, you should put the configuration file into /src/main/resources/.
Once you finish these steps and deploy the project, the log4j.properties file will be loaded to /webapps/project-name/WEB-INF/classes/.

##### 3.4.2 Loading the configuration file
Firstly, you should create a Util package in the project.
Then, create a class called Log4jUtil and write a function to returning a Logger Object.

```
public class Log4jUtil {
	public static Logger getLog() {
		//DOMConfigurator.configure("/src/main/resources/conf/log4j.xml");
		PropertyConfigurator.configure("./log4j.properties");
		Logger log = Logger.getLogger(Log4jTestPortlet.class);
		return log;
	}
}

```
Now, you can use `Logger log = Log4jUtil.getLog();` to get a Logger Object and call the different levels' function like `info()`, `debug()`, etc.
