# JAVA

## 一、镜像加速

### 1.1 Maven镜像

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

### 1.2 Gradel 镜像

添加或修改 `~/.gradle/init.gradle` 文件：

```
allprojects {
    repositories {
        mavenLocal()
        maven {
            url "https://maven.aliyun.com/repository/public"
        }
    }
    buildscript {
        repositories {
            maven {
                 url "https://maven.aliyun.com/repository/public"
            }
        }
    }
}
```

## Gradle 7 代理

在用户目录 `~` 或项目目录下添加或修改 `gradle.proerties` 文件：

```
systemProp.socksProxyHost=
systemProp.socksProxyPort=
```

## 参考

- [Gradle 7 配置代理](https://docs.gradle.org/7.0/userguide/build_environment.html#sec:accessing_the_web_via_a_proxy)
