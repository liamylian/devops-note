# JAVA

## Maven镜像

修改`~/.m2/settings.xml`文件:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <mirrors>
        <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
</settings>
```

## Gradle代理

添加 `~/.gradle` 文件，或修改项目的 `gradle.proerties` 文件：

```
systemProp.socks.proxyHost=*.*.*.*
systemProp.socks.proxyPort=9080
systemProp.socks.proxyUser=
systemProp.socks.proxyPassword=
systemProp.socks.nonProxyHosts=*.nonproxyrepos.com|localhost
```
