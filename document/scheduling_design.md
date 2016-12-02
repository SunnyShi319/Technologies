# HSF Scheduling Design
**Revision 0.1**  
**May 9, 2016**

---
# Document History
|Revision|Description             |Rev. Date |Originator  |
|--------|------------------------|----------|------------|
|0.1     |The initial version     |2016-05-09|Curtis Zhang|
|0.2     |Refined detail design   |2016-05-16|Curtis Zhang|
|0.3     |Rewrite add job part    |2016-05-20|Curtis Zhang|
---
# 1. Introduction
The scheduling module provides other modules with a way to plan scheduling.

## 1.1 Definitions, Acronyms, and Abbreviations
|Definitions, Acronyms, and Abbreviations|Description|
|----------------|----------------------------|
|CRUD            |Create, Read, Update, Delete|
|LR              |Liferay                     |
|DB              |Database                    |

# 2. Key Concept   
**Trigger:** Trigger is a timmer. It used to determine scheduler work on time.  
**HsfJob:** MessageListener is an interface for implement scheduling service logic.       
**HsfSchedulerUtil:** HsfSchedulerUtil is a dispatcher that management Triggers and HsfJob.  

# 3. Detail Design
Design is based on Liferay6.2.5 scheduling API, it should be encapsulated as a commonly utility class for easy develpment. 

## 3.1 HsfJobDetails 
Schedule job details has to packaged as a javabean named HsfJobDetails for transmit job information. 

### 3.1.1 Entity
|Field           |Type  |Description                           |
|----------------|------|--------------------------------------|
|startTime       |Date  |Time of when the job is created.      |
|jobClassName    |String|The qualified name of MessageListener.|
|jobStatus       |String|The status of job.                    |
|jobName         |String|The unique name of job.               |
|jobGroup        |String|Used to classify which module the job affiliation.|
|cronExpression  |String|Cron-Expression of Trigger.           |
|description     |String|Description of job.                   |
|previousFireTime|Date  |PreviousFireTime.                     |
|nextFireTime    |Date  |NextFireTime.                         |

### 3.1.2 Status of job
|Status Code|Description|
|-----------|-----------|
|COMPLETE   |Job has been finished.| 
|EXPIRED    |Job has been overdue.|
|NORMAL     |Job is on scheduled.|
|PAUSED     |Work is suspended.|
|UNSCHEDULED|Job has been unscheduled.|

## 3.2 HsfJob
HsfJob is a  is an interface, by implement its doJob method to implement the scheduling service logic.

## 3.3 Destination and MessageListener
HsfScheduling use a fixed Destination and MessageListener to handle HsfJob. Configure them in plugin’s `WEB-INF/src/META-INF/messaging-spring.xml` file. Create this file if it doesn’t yet exist. 

```xml
<?xml version="1.0"?>

<beans
    default-destroy-method="destroy"
    default-init-method="afterPropertiesSet"
    xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
>

    <!-- Listeners -->

    <bean id="hsfJobHandler" class="" />
    
    <!-- Destinations -->

    <bean id="hsfJobDestination" class="">
        <property name="name" value="hsf/hsfJobHandler" />
    </bean>

    <!-- Configurator -->

    <bean id="messagingConfigurator" class="com.liferay.portal.kernel.messaging.config.PluginMessagingConfigurator">
        <property name="messageListeners">
            <map key-type="java.lang.String" value-type="java.util.List">
                <entry key="insults/users">
                    <list value-type="com.liferay.portal.kernel.messaging.MessageListener">
                        <ref bean="hsfJobHandler" />
                    </list>
                </entry>
            </map>
        </property>
        <property name="destinations">
            <list>
                <ref bean="hsfJobDestination"/>
            </list>
        </property>
    </bean>
</beans>
```

`messaging-spring.xml` need to register  in `docroot/WEB-INF/web.xml`.
```xml
<listener>
    <listener-class>com.liferay.portal.kernel.spring.context.PortletContextLoaderListener</listener-class>
</listener>

<context-param>
    <param-name>portalContextConfigLocation</param-name>
    <param-value>/WEB-INF/classes/META-INF/messaging-spring.xml</param-value>
</context-param>
```

### 3.3.1 HsfJobHandler
HsfJobHandler get HsfJob json and portletId from message, use portletId to get portletClassloader to deserialize HsfJob and call its doJob method.
```java
public void receive(Message message) throws MessageListenerException {
    String jobJson = message.get("hsfJob");
    String portletId = message.get("portletId");
    ClassLoader classLoader = null;
    classLoader = PortletClassLoaderUtil.getClassLoader(portletId);
    Class hsfJobClass;
    try {
        hsfJobClass = classLoader.loadClass("com.test.HsfJob");
        HsfJob hsfJob=JSONFactoryUtil.looseDeserialize(jobJson, hsfJobClass);
        hsfJob.doJob();
    } catch (ClassNotFoundException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}    
```

## 3.4 HsfSchedulerUtil
HsfJob Management provides functions for admin to management commonly operations to job schedule.

### 3.4.1 addJob
Job could be scheduled by HsfSchedulerUtil with parameters PortletRequest, jobName, jobGroup, description, hsfJobClassName and cronExpression:
```java
HsfSchdulerUtil.addJob(PortletRequest request, String jobName, JobGroup jobGroup, String description, String hsfJobClassName, String cronExpression);
```
Method throws SchedulerException. 
#### 3.4.1.1 JobGroup, JobName and CronExpression
JobGroup is an enum type value used to distinguish which module the jobs belong to. Its property is determined by the modules needed scheduling.  
JobName is an unique key value to mapping a Job in a job group, couldn't be null.  
CronExpression is a kind of expression for Trigger to determine when the scheduled job work.

#### 3.4.1.2 Description
Description is a String used to describe the job.

#### 3.4.1.3 HsfJobClassName
HsfJob is an interface, by implement its receive method to implement the scheduling service logic. For instantiate, the qualified name is needed.

#### 3.4.1.4 PortletRequest
HsfJob need to load by portlet class loader, use PortletRequest to get the portlet id then use the portlet id to get portlet class loader.
```java
String portletId =  PortalUtil.getPortletId(request);
```

#### 3.4.1.5 Method implementation
Check the jobName is null:
```java
if(jobName == null){
    throw new SchedulerException("JobName couldn't be null.");
}
```
Use JobGroup, JobName and CronExpression to build a CronTrigger:
```java
Trigger trigger = TriggerFactoryUtil.buildTrigger(TriggerType.CRON, jobName, jobGroup.toString, null, null, cronExpression);
```
Add HsfJob to Message.
```java
Class hsfJobClass = Class.forName(hsfJobClassName);
Hs
if(hsfJobClass instanceof HsfJob){
    String jobJson;
    jobJson = JSONFactoryUtil.serialize(hsfJobClass.newInstance());
    Message message = new Message();
    message.put("hsfJob", jobJson);
    message.put("portletId", portletId);
}else{
    throw new SchedulerException(hsfJobClassName+" not subClass of HsfJob."); 
}
```

Use SchedulerEngineHelperUtil to schedule job:
```java
SchedulerEngineHelperUtil.schedule(trigger, StorageType.PERSISTED, description, "hsf/hsfJobHandler", message, 0);
```
Method throws SchedulerException. 
### 3.4.2 getCronExpression
CronExpression could be obtained from Calendar type. Use this method to generate a specified CronExpression:
```java
String cronExp = HsfSchdulerUtil.getCronExpression(Calendar calendar);
``` 
#### 3.4.2.1 Method implementation
Use the LR scheduler API, timeZoneSensitive choose fault as default.
```java
SchedulerEngineHelperUtil.getCronText(Calendar calendar, boolean timeZoneSensitive);
```

### 3.4.3 JobList
Scheduled job could be found by jobGroup and jobName, Scheduled jobs list could be found by jobGroup or list all:
```java
HsfJob hsfJob = HsfSchdulerUtil.getJob(String jobName, JobGroup jobGroup);
List<HsfJob> hsfJobList1 = HsfSchdulerUtil.getJobList();
List<HsfJob> hsfJobList2 = HsfSchdulerUtil.getJobList(JobGroup jobGroup);
```
#### 3.4.3.1 Method implementation
Use `SchedulerEngineHelperUtil` to get SchedulerResponse of the Job, then get parameters from SchedulerResponse and set into HsfJob instance.
```java
SchedulerResponse sr = SchedulerEngineHelperUtil.getScheduledJob("jobName", "jobGroup", StorageType.PERSISTED);
List<SchedulerResponse> srList1 = SchedulerEngineHelperUtil.getScheduledJobs(StorageType.PERSISTED);
List<SchedulerResponse> srList2 = SchedulerEngineHelperUtil.getScheduledJobs(jobGroup.toString(), StorageType.PERSISTED);
```
```java
HsfJob hsfJob = new HsfJob();
hsfJob.setJobName(sr.getJobName());
hsfJob.setJobGroup(sr.getGroupName());
...
```

### 3.4.4 Unschedule
Scheduled job could be unschedule by HsfSchedulerUtil. Unscheduled job will stop working and job status will be changed to `UNSCHEDULED`. Unschedule could be a job or group:
```java
HsfSchedulerUtil.unschedule(String jobName, JobGroup jobGroup);
HsfSchedulerUtil.unschedule(JobGroup jobGroup);
```
#### 3.4.4.1 Method implementation
Use Liferay scheduler API, set `PERSISTED` as default storage type.
```java
SchedulerEngineHelperUtil.unschedule(jobName, jobGroup.toString(), StorageType.PERSISTED);
SchedulerEngineHelperUtil.unschedule(jobGroup.toString(), StorageType.PERSISTED);
```

### 3.4.5 Update
The scheduled job trigger could be update, jobName, jobGroup and new Cron-Expression is needed.
```java
HsfSchedulerUtil.update(String jobName, JobGroup jobGroup, String cronExpression);
```
The job needed to be checked whether there has a job, a SchedulerException will be thrown if not.
#### 3.4.5.1 Method implementation
Use getJob method to check is job exist.
```java
HsfJob hsfJob = HsfSchedulerUtil.getJob(jobName, jobGroup.toString());
if(hsfJob == null){
     throw new SchedulerException("Job didn't exist.");
}
```
Use `TriggerFactoryUtil` to build a new trigger.
```java
Trigger trigger = TriggerFactoryUtil.buildTrigger(TriggerType.CRON, jobName, jobGroup, null, null, cronExpression);
```
Update the trigger by `SchedulerEngineHelperUtil`.
```java
SchedulerEngineHelperUtil.update(trigger, StorageType.PERSISTED);
```

### 3.4.6 Pause and Resume
Scheduled job could be pause or resume by `HsfSchedulerUtil`. After pause, job status will change to `PAUSED` and stop working, use resume to recover job status to `NORMAL` and go on working.Before pause or resume, the job should be checked is exist. Pause and resume could effect in group.
```java
HsfSchedulerUtil.pause(JobGroup jobGroup);
HsfSchedulerUtil.pause(String jobName, JobGroup jobGroup);
HsfSchedulerUtil.resume(JobGroup jobGroup);
HsfSchedulerUtil.resume(String jobName, JobGroup jobGroup);
```
#### 3.4.6.1 Method implementation
Use getJob method to check is job exist.
```java
HsfJob hsfJob = HsfSchedulerUtil.getJob(jobName, jobGroup);
if(hsfJob == null){
     throw new SchedulerException("Job didn't exist.");
}
```
Use LR scheduler API to pause/resume job, storage type use `PERSISTED` as default.
```java
SchedulerEngineHelperUtil.pause(jobGroup.toString(), StorageType.PERSISTED);
SchedulerEngineHelperUtil.pause(jobName, jobGroup.toString(), StorageType.PERSISTED);
SchedulerEngineHelperUtil.resume(jobGroup.toString(), StorageType.PERSISTED);
SchedulerEngineHelperUtil.resume(jobName, jobGroup.toString(), StorageType.PERSISTED);
```

## 3.5 JobGroup
JobGroup is an enum type value used to distinguish which module the jobs belong to. Its property is determined by the modules needed scheduling.  
```java
public enum JobGroup {
	EMAIL, SITE_MESSAGE, SMS
}
```

# 4 API
## 4.1 HsfSchedulerUtil
HsfSchedulerUtil provide commonly used methods.  
- HsfSchedulerUtil
    - Method Summary

|Modifier and Type         |Method|Description|
|--------------------------|------|-----------|
|public static void        |addJob(PortletRequest request, String jobName, JobGroup jobGroup, String description, Map<String, Object> values, String messageListenerClassName, String cronExpression)|Schedule the job.| 
|public static void        |getCronExpression(Calendar calendar)|Transform the Calendar type value to Cron-Expression.|
|public static HsfJob      |getJob(String jobName, JobGroup jobGroup)|Get the scheduled job by jobName and jobGroup.|
|public static List<HsfJob>|getJobList()|Get all of jobs storaged in DB.|
|public static List<HsfJob>|getJobList(JobGroup jobGroup)|Get jobs by jobGroup.|
|public static void        |unschedule(String jobName, JobGroup jobGroup)|Found the job by jobGroup and jobName, then unschedule it.|
|public static void        |unschedule(JobGroup jobGroup)|Unshcedule a group of job.|
|public static void        |update(String jobName, JobGroup jobGroup, String cronExpression)|Update trigger of the job.|
|public static void        |pause(JobGroup jobGroup)|Pause a group of jobs.|
|public static void        |pause(String jobName, JobGroup jobGroup)|Found the job by jobGroup and jobName, then pause it.|
|public static void        |resume(JobGroup jobGroup)|Resume a group of jobs.|
|public static void        |resume(String jobName, JobGroup jobGroup)|Found the job by jobGroup and jobName, then resume it.|

## 4.2 HsfJob
|Modifier and Type         |Method |Description|
|--------------------------|-------|-----------|
|public static void        |doJob()|Implement the scheduling service logic.|

# 5 ISSUE
1. Member variables is not supported in HsfJob.