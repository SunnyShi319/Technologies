# July 14, 2016
1. vim ～/.ssh/known_hosts  -- 可以将已连接冗余的server信息删除
2. 在eclipse->window->preference中输入jre，并编辑且输入信息:
    -XX:PermSize=128M -XX:MaxPermSize=256M:避免eclipse内存溢出
    -Dmaven.multiModuleProjectDirectory=$MAVEN_HOME:让eclipse使用自己安装的maven
3. Date对象可获得getMonth()  -- 0-11对应Jan-Dec
4. border-collapse: collapse; -- 该属性只在chrome中有效，在firefox和ie中均不兼容

# July 15, 2016
1. 在IE和Firefox中将password后面的小叉以及小眼睛去掉,通过CSS虚拟元素(::-ms-clear、::-ms-reveal)禁用:
    input::-ms-clear{display:none;} /*隐藏文本框叉子*/
    input::-ms-reveal{display:none;} /*隐藏密码框小眼睛*/

2. 页面响应式布局 **重点!**

3. 开发[custom sql queries](https://dev.liferay.com/develop/tutorials/-/knowledge_base/6-2/developing-custom-sql-queries)

#July 26, 2016
1. 设置当文本溢出包含元素时想要将剩余的显示为省略号，则设置如下:
```
display: block;
overflow: hidden;
text-overflow: ellipsis;
```