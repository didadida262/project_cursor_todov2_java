# Homebrew 安装后配置指南

本文档提供使用 Homebrew 安装工具后的配置说明。

## 📦 安装后的配置步骤

### 1. Java 17 (openjdk@17)

#### 安装命令
```bash
brew install openjdk@17
```

#### 配置 PATH（必须）

Homebrew 安装后会提示需要配置 PATH。根据你的 Mac 类型选择：

**Apple Silicon Mac (M1/M2/M3):**
```bash
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Intel Mac:**
```bash
echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### 验证安装
```bash
java -version
# 应该显示 openjdk version "17.x.x"
```

#### 编译器配置（可选）

如果需要编译 C/C++ 程序并链接到 openjdk@17：

```bash
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
```

---

### 2. MySQL

#### 安装命令
```bash
brew install mysql
```

#### 重要提示

**⚠️ MySQL 升级注意事项**

如果从 MySQL <8.4 升级到 MySQL >9.0，需要先运行 MySQL 8.4：

```bash
# 1. 停止当前 MySQL
brew services stop mysql

# 2. 安装 MySQL 8.4
brew install mysql@8.4

# 3. 启动 MySQL 8.4
brew services start mysql@8.4

# 4. 停止 MySQL 8.4
brew services stop mysql@8.4

# 5. 启动新版本 MySQL
brew services start mysql
```

#### 启动 MySQL 服务

**方式一：后台服务（推荐）**
```bash
brew services start mysql
```

**方式二：手动启动**
```bash
/opt/homebrew/opt/mysql/bin/mysqld_safe --datadir=/opt/homebrew/var/mysql
```

#### MySQL 安全配置

Homebrew 安装的 MySQL **默认没有 root 密码**，建议运行安全配置：

```bash
mysql_secure_installation
```

配置选项：
- ✅ 设置 root 密码（推荐）
- ✅ 移除匿名用户
- ✅ 禁止远程 root 登录
- ✅ 移除测试数据库

**注意**：如果设置了 root 密码，需要更新项目的数据库配置文件。

#### 连接 MySQL

**无密码连接（默认）：**
```bash
mysql -u root
```

**有密码连接：**
```bash
mysql -u root -p
```

#### MySQL 连接说明

- ✅ 默认只允许从 **localhost** 连接（安全设置）
- ✅ 默认用户：`root`
- ✅ 默认密码：**无**（空密码）
- ✅ 端口：`3306`

#### 验证 MySQL
```bash
# 检查服务状态
brew services list | grep mysql

# 测试连接
mysql -u root -e "SELECT VERSION();"
```

---

## 🔧 快速配置脚本

### 一键配置 Java 17（Apple Silicon Mac）

```bash
# 检测 Shell 类型并配置
if [ -f ~/.zshrc ]; then
    echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    echo "✓ Java PATH 已添加到 ~/.zshrc"
elif [ -f ~/.bash_profile ]; then
    echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
    echo "✓ Java PATH 已添加到 ~/.bash_profile"
fi

# 验证
java -version
```

### 一键配置 Java 17（Intel Mac）

```bash
# 检测 Shell 类型并配置
if [ -f ~/.zshrc ]; then
    echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    echo "✓ Java PATH 已添加到 ~/.zshrc"
elif [ -f ~/.bash_profile ]; then
    echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
    echo "✓ Java PATH 已添加到 ~/.bash_profile"
fi

# 验证
java -version
```

---

## 📋 完整安装检查清单

安装完成后，运行以下命令检查：

```bash
# 1. 检查 Java
java -version
echo $JAVA_HOME

# 2. 检查 Maven
mvn -version

# 3. 检查 Node.js
node -v
npm -v

# 4. 检查 MySQL
mysql --version
brew services list | grep mysql

# 5. 测试 MySQL 连接
mysql -u root -e "SELECT 1;"
```

---

## 🐛 常见问题

### 问题 1：Java 命令未找到

**原因**：PATH 未配置或未重新加载

**解决方案**：
```bash
# 检查 PATH
echo $PATH | grep openjdk

# 如果为空，重新配置
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 问题 2：MySQL 服务无法启动

**原因**：可能是权限问题或数据目录问题

**解决方案**：
```bash
# 检查服务状态
brew services list

# 查看错误日志
tail -f /opt/homebrew/var/mysql/*.err

# 重新安装（如果需要）
brew services stop mysql
brew uninstall mysql
brew install mysql
brew services start mysql
```

### 问题 3：MySQL 连接被拒绝

**原因**：服务未启动或配置问题

**解决方案**：
```bash
# 确保服务已启动
brew services start mysql

# 检查端口
lsof -i :3306

# 测试连接
mysql -u root
```

---

## 📚 相关文档

- [JAVA_SETUP.md](JAVA_SETUP.md) - Java 环境变量详细配置指南
- [INSTALL.md](INSTALL.md) - 完整安装指南
- [README.md](README.md) - 项目主文档

