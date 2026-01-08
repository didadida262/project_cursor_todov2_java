# 安装指南

## Mac 系统环境配置

### 1. 安装 Homebrew（如果未安装）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. 安装必要的工具

```bash
# 安装 Java 17
brew install openjdk@17

# 安装 Maven
brew install maven

# 安装 Node.js (包含 npm)
brew install node

# 安装 MySQL
brew install mysql
```

### 3. 配置 Java 环境变量

> 📖 **详细步骤请参考 [JAVA_SETUP.md](JAVA_SETUP.md)**

#### 快速配置步骤：

**步骤 1：确定使用的 Shell**
```bash
echo $SHELL
# 输出 /bin/zsh 或 /bin/bash
```

**步骤 2：编辑配置文件**

如果使用 zsh（macOS 10.15+）：
```bash
nano ~/.zshrc
```

如果使用 bash：
```bash
nano ~/.bash_profile
```

**步骤 3：添加以下内容到文件末尾**

**如果使用 Homebrew 安装（推荐，Apple Silicon Mac）：**
```bash
# Java 17 环境变量配置（Homebrew 安装）
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
```

**如果使用 Homebrew 安装（Intel Mac）：**
```bash
# Java 17 环境变量配置（Homebrew 安装）
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@17"
```

**或者使用自动检测方式（通用）：**
```bash
# Java 17 环境变量配置（自动检测）
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

> 💡 **提示**：Homebrew 安装完成后会显示配置命令，可以直接复制使用

**步骤 4：保存并退出**
- nano: 按 `Ctrl + X`，然后 `Y`，最后 `Enter`
- vim: 按 `Esc`，输入 `:wq`，按 `Enter`

**步骤 5：重新加载配置**
```bash
# zsh
source ~/.zshrc

# bash
source ~/.bash_profile
```

**步骤 6：验证配置**
```bash
java -version
# 应该显示 Java 17
```

### 4. 配置和启动 MySQL

#### 4.1 启动 MySQL 服务

```bash
brew services start mysql
```

#### 4.2 MySQL 安全配置（可选但推荐）

Homebrew 安装的 MySQL 默认没有 root 密码，建议运行安全配置：

```bash
mysql_secure_installation
```

这会引导你：
- 设置 root 密码
- 移除匿名用户
- 禁止远程 root 登录
- 移除测试数据库

**注意**：如果设置了 root 密码，需要更新项目的数据库配置。

#### 4.3 连接 MySQL

```bash
# 无密码连接（默认）
mysql -u root

# 如果有密码
mysql -u root -p
```

#### 4.4 MySQL 升级注意事项

如果从 MySQL <8.4 升级到 MySQL >9.0，需要先运行 MySQL 8.4：

```bash
# 停止当前 MySQL
brew services stop mysql

# 安装 MySQL 8.4
brew install mysql@8.4

# 启动 MySQL 8.4
brew services start mysql@8.4

# 停止 MySQL 8.4
brew services stop mysql@8.4

# 启动新版本 MySQL
brew services start mysql
```

#### 4.5 MySQL 连接说明

- MySQL 默认只允许从 localhost 连接（安全设置）
- 默认用户：`root`
- 默认密码：**无**（空密码）
- 连接命令：`mysql -u root`

### 5. 验证安装

```bash
# 检查 Java
java -version

# 检查 Maven
mvn -version

# 检查 Node.js
node -v
npm -v

# 检查 MySQL
mysql --version
```

### 6. 运行项目

```bash
# 一键启动
./start.sh

# 停止服务
./stop.sh
```

## 常见问题

### Maven 未找到

如果提示 `mvn 未安装或不在 PATH 中`：

1. **使用 Homebrew 安装**：
   ```bash
   brew install maven
   ```

2. **手动安装 Maven**：
   - 下载：https://maven.apache.org/download.cgi
   - 解压到 `/usr/local/`
   - 添加到 PATH：
     ```bash
     export PATH=/usr/local/apache-maven-3.x.x/bin:$PATH
     ```

### Java 版本问题

如果 Java 版本低于 17：

1. **安装 Java 17**：
   ```bash
   brew install openjdk@17
   ```

2. **配置 PATH（必须）**

   **Apple Silicon Mac:**
   ```bash
   echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

   **Intel Mac:**
   ```bash
   echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **验证安装**：
   ```bash
   java -version
   # 应该显示 openjdk version "17.x.x"
   ```

### MySQL 连接失败

1. **启动 MySQL 服务**：
   ```bash
   brew services start mysql
   ```

2. **检查 MySQL 状态**：
   ```bash
   brew services list
   ```

3. **测试连接**：
   ```bash
   mysql -u root -e "SELECT 1;"
   ```

### 端口被占用

如果端口 8000 或 3000 被占用：

1. **查找占用端口的进程**：
   ```bash
   lsof -i :8000
   lsof -i :3000
   ```

2. **停止进程**：
   ```bash
   kill -9 <PID>
   ```

3. **或使用停止脚本**：
   ```bash
   ./stop.sh
   ```

## 📚 相关文档

- [JAVA_SETUP.md](JAVA_SETUP.md) - Java 环境变量详细配置指南
- [HOMEBREW_SETUP.md](HOMEBREW_SETUP.md) - Homebrew 安装后配置指南

---

## 手动启动（如果脚本无法使用）

### 后端启动

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 前端启动

```bash
cd front
npm install
npm start
```

