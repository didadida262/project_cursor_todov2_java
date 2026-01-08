# Java 环境变量配置详细指南

## 📋 目录
1. [检查当前 Java 版本](#1-检查当前-java-版本)
2. [确定使用的 Shell](#2-确定使用的-shell)
3. [查找 Java 17 安装路径](#3-查找-java-17-安装路径)
4. [编辑配置文件](#4-编辑配置文件)
5. [应用配置](#5-应用配置)
6. [验证配置](#6-验证配置)
7. [常见问题](#7-常见问题)

---

## 1. 检查当前 Java 版本

首先检查系统当前使用的 Java 版本：

```bash
java -version
```

如果显示的是 Java 17 或更高版本，可能不需要配置。如果显示的是较低版本（如 Java 8、11 等），需要配置环境变量。

---

## 2. 确定使用的 Shell

Mac 系统默认使用 zsh（macOS Catalina 10.15+）或 bash（较老版本）。

### 方法一：查看当前 Shell

```bash
echo $SHELL
```

输出示例：
- `/bin/zsh` → 使用 zsh
- `/bin/bash` → 使用 bash

### 方法二：查看 Shell 历史

```bash
ps -p $$
```

---

## 3. 查找 Java 17 安装路径

### 步骤 3.1：检查是否已安装 Java 17

```bash
/usr/libexec/java_home -V
```

这会列出所有已安装的 Java 版本，例如：
```
Matching Java Virtual Machines (2):
    17.0.9 (arm64) "Eclipse Adoptium" - "OpenJDK 17.0.9" /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
    11.0.20 (arm64) "Eclipse Adoptium" - "OpenJDK 11.0.20" /Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
```

### 步骤 3.2：获取 Java 17 的路径

```bash
/usr/libexec/java_home -v 17
```

输出示例：
```
/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
```

**如果命令失败，说明 Java 17 未安装，需要先安装：**

```bash
brew install openjdk@17
```

安装后再次运行上面的命令获取路径。

---

## 4. 编辑配置文件

根据你使用的 Shell，编辑对应的配置文件：

### 4.1 如果使用 zsh（推荐，macOS 10.15+）

#### 步骤 1：打开配置文件

```bash
nano ~/.zshrc
```

或者使用其他编辑器：
```bash
# 使用 VS Code
code ~/.zshrc

# 使用 vim
vim ~/.zshrc

# 使用 TextEdit
open -e ~/.zshrc
```

#### 步骤 2：添加 Java 环境变量

**方法一：使用 Homebrew 安装的 openjdk@17（推荐）**

如果使用 `brew install openjdk@17` 安装，Homebrew 会提示添加 PATH。在文件末尾添加：

```bash
# Java 17 环境变量配置（Homebrew 安装）
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
```

**或者使用自动检测方式（兼容性更好）：**

```bash
# Java 17 环境变量配置
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

**如果 Homebrew 安装在 Intel Mac（/usr/local）上：**

```bash
# Java 17 环境变量配置（Intel Mac）
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@17"
```

**完整示例**（如果文件已存在其他内容）：
```bash
# 其他配置...

# Java 17 环境变量配置
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

#### 步骤 3：保存文件

- **nano**: 按 `Ctrl + X`，然后按 `Y`，最后按 `Enter`
- **vim**: 按 `Esc`，输入 `:wq`，按 `Enter`
- **VS Code/TextEdit**: 直接保存（`Cmd + S`）

### 4.2 如果使用 bash（较老版本 macOS）

#### 步骤 1：打开配置文件

```bash
nano ~/.bash_profile
```

或者：
```bash
code ~/.bash_profile
```

#### 步骤 2：添加 Java 环境变量

**如果使用 Homebrew 安装（Apple Silicon Mac）：**

```bash
# Java 17 环境变量配置（Homebrew 安装）
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
```

**如果使用 Homebrew 安装（Intel Mac）：**

```bash
# Java 17 环境变量配置（Intel Mac）
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@17"
```

**或者使用自动检测方式：**

```bash
# Java 17 环境变量配置
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

#### 步骤 3：保存文件

同 zsh 的保存方法。

---

## 5. 应用配置

配置完成后，需要重新加载配置文件才能生效：

### 如果使用 zsh：

```bash
source ~/.zshrc
```

### 如果使用 bash：

```bash
source ~/.bash_profile
```

**或者**：关闭并重新打开终端窗口（Terminal.app）。

---

## 6. 验证配置

### 步骤 6.1：检查 JAVA_HOME

```bash
echo $JAVA_HOME
```

应该显示类似：
```
/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
```

### 步骤 6.2：检查 Java 版本

```bash
java -version
```

应该显示：
```
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment Temurin-17.0.9+11 (build 17.0.9+11)
OpenJDK 64-Bit Server VM Temurin-17.0.9+11 (build 17.0.9+11, mixed mode, sharing)
```

### 步骤 6.3：检查 Maven 是否能找到 Java

```bash
mvn -version
```

应该显示：
```
Apache Maven 3.9.x
Maven home: /usr/local/Cellar/maven/3.9.x/libexec
Java version: 17.0.9, vendor: Eclipse Adoptium
Java home: /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
...
```

---

## 7. 常见问题

### 问题 1：`/usr/libexec/java_home -v 17` 返回错误

**原因**：Java 17 未安装

**解决方案**：
```bash
# 使用 Homebrew 安装
brew install openjdk@17

# 或者手动下载安装
# 访问：https://adoptium.net/
```

### 问题 2：配置后仍然显示旧版本

**原因**：配置文件未生效

**解决方案**：
1. 确认编辑了正确的配置文件（zsh 用 `.zshrc`，bash 用 `.bash_profile`）
2. 运行 `source ~/.zshrc` 或 `source ~/.bash_profile`
3. 关闭并重新打开终端
4. 检查是否有多个 Java 版本，PATH 中旧版本在前

### 问题 3：找不到配置文件

**原因**：配置文件可能不存在

**解决方案**：
```bash
# 创建配置文件（如果不存在）
touch ~/.zshrc    # zsh
# 或
touch ~/.bash_profile    # bash

# 然后按照步骤 4 添加配置
```

### 问题 4：多个 Java 版本切换

如果需要在不同 Java 版本间切换，可以使用别名：

```bash
# 添加到 ~/.zshrc 或 ~/.bash_profile
alias java17='export JAVA_HOME=$(/usr/libexec/java_home -v 17)'
alias java11='export JAVA_HOME=$(/usr/libexec/java_home -v 11)'
alias java8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
```

使用：
```bash
java17  # 切换到 Java 17
java -version  # 验证
```

### 问题 5：PATH 配置冲突

如果 PATH 中有多个 Java 路径，确保 Java 17 的路径在最前面：

```bash
# 检查当前 PATH
echo $PATH

# 如果发现冲突，可以在配置文件中明确指定顺序
export PATH=$JAVA_HOME/bin:$PATH
```

---

## 📝 完整配置示例

### zsh 配置示例（~/.zshrc）- Apple Silicon Mac

```bash
# ============================================
# Java 17 环境变量配置（Homebrew 安装）
# ============================================
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# 可选：添加 Maven 路径（如果 Maven 不在默认路径）
# export PATH="/opt/homebrew/opt/maven/bin:$PATH"
```

### zsh 配置示例（~/.zshrc）- Intel Mac

```bash
# ============================================
# Java 17 环境变量配置（Homebrew 安装）
# ============================================
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@17"
```

### zsh 配置示例（~/.zshrc）- 通用方式（自动检测）

```bash
# ============================================
# Java 17 环境变量配置（自动检测）
# ============================================
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

### bash 配置示例（~/.bash_profile）

```bash
# ============================================
# Java 17 环境变量配置
# ============================================
# Apple Silicon Mac
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# Intel Mac 使用：
# export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
# export JAVA_HOME="/usr/local/opt/openjdk@17"

# 或使用自动检测方式：
# export JAVA_HOME=$(/usr/libexec/java_home -v 17)
# export PATH=$JAVA_HOME/bin:$PATH
```

---

## ✅ 快速验证清单

完成配置后，运行以下命令确认一切正常：

```bash
# 1. 检查 Shell
echo $SHELL

# 2. 检查 JAVA_HOME
echo $JAVA_HOME

# 3. 检查 Java 版本
java -version

# 4. 检查 Maven（如果已安装）
mvn -version

# 5. 检查 Java 编译器
javac -version
```

所有命令都应该显示 Java 17 相关信息。

---

## 🎯 总结

配置 Java 环境变量的核心步骤：

1. ✅ 安装 Java 17：`brew install openjdk@17`
2. ✅ 确定 Shell 类型：`echo $SHELL`
3. ✅ 编辑配置文件：`nano ~/.zshrc` 或 `nano ~/.bash_profile`
4. ✅ 添加配置：
   ```bash
   export JAVA_HOME=$(/usr/libexec/java_home -v 17)
   export PATH=$JAVA_HOME/bin:$PATH
   ```
5. ✅ 应用配置：`source ~/.zshrc` 或 `source ~/.bash_profile`
6. ✅ 验证：`java -version`

完成这些步骤后，Java 17 环境变量就配置好了！🎉

