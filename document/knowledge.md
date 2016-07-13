# Little Knowlegde

## 1.使用链接命令下载文件：
wget是linux最常用的下载命令，一般使用:wget+空格+要下载的文件的url路径

## 2.解决自动热部署时java.lang.OutOfMemoryError: PermGen space问题
解决这个问题的方法即只需要增大PermGen区，设置方法为set MAVEN_OPTS=-XX:MaxPermSize=128M
如果遇到outofmemory错误，export MAVEN_OPTS="-XX:MaxPermSize=256M - Xms2048M -Xmx2048M"

[Maven常用基本指令](http://www.tuicool.com/articles/zQfAB3)

## 3.项目Git应用
1. 将所有东西拉取下来: git pull --all
2. 切换到自己在远程创建的分支: git checkout {branch name}
3. 添加并提交
4. 提交到远程服务器: git push origin {branch name}
5. 当完成自己的功能模块后，则需要修改历史记录: git rebase -i HEAD~{number of recent commits to rebase}
6. 在与远程主分支develop进行rebase之前，需要拉取最新的代码： git fetch --all
7. 与远程主分支develop进行rebase: git rebase origin/develop
8. 最后推送到远程分支: git push origin {branch name} -f