# Maven 编译加速指南

## 问题：Maven 下载依赖太慢

如果 Maven 编译时下载依赖很慢，可以使用国内镜像加速。

## 解决方案：配置 Maven 镜像

### 方法一：创建 Maven 配置文件（推荐）

```bash
# 创建 Maven 配置目录（如果不存在）
mkdir -p ~/.m2

# 创建配置文件
cat > ~/.m2/settings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
          http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <!-- 阿里云镜像 -->
    <mirror>
      <id>aliyunmaven</id>
      <mirrorOf>central</mirrorOf>
      <name>阿里云公共仓库</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>
</settings>
EOF

echo "✓ Maven 镜像配置完成"
```

### 方法二：临时使用镜像（单次编译）

```bash
cd backend
mvn clean install -DskipTests -Dmaven.wagon.http.ssl.insecure=true \
  -Dmaven.wagon.http.ssl.allowall=true \
  -Dmaven.wagon.http.ssl.ignore.validity.dates=true \
  --settings ~/.m2/settings.xml
```

## 查看编译进度

在另一个终端窗口运行：

```bash
# 实时查看编译日志
tail -f backend.log

# 或者查看 Maven 进程
ps aux | grep mvn
```

## 如果编译失败

1. **清理并重新编译**：
   ```bash
   cd backend
   mvn clean
   mvn install -DskipTests
   ```

2. **检查网络连接**：
   ```bash
   ping repo.maven.apache.org
   ```

3. **使用离线模式**（如果依赖已下载）：
   ```bash
   mvn install -DskipTests -o
   ```

## 预计时间

- **首次编译**：5-15 分钟（取决于网络速度）
- **后续编译**：1-3 分钟（依赖已缓存）

## 耐心等待

Maven 首次编译需要下载大量依赖（约 100+ MB），这是正常现象。请耐心等待，不要中断进程。

