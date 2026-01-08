#!/bin/bash

# Todo App 一键启动脚本
# 用于在 Mac 上启动后端和前端服务

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/front"

# 日志文件
BACKEND_LOG="$PROJECT_ROOT/backend.log"
FRONTEND_LOG="$PROJECT_ROOT/frontend.log"
PID_FILE="$PROJECT_ROOT/.pids"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Todo App 一键启动脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查必要的命令是否存在
check_command() {
    local cmd=$1
    local install_hint=$2
    
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}✗ $cmd 未安装或不在 PATH 中${NC}"
        if [ ! -z "$install_hint" ]; then
            echo -e "${CYAN}  安装提示: $install_hint${NC}"
        fi
        return 1
    else
        echo -e "${GREEN}✓ $cmd 已安装${NC}"
        return 0
    fi
}

# 尝试安装 Maven（如果使用 Homebrew）
try_install_maven() {
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}检测到 Homebrew，尝试安装 Maven...${NC}"
        read -p "是否自动安装 Maven? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}正在安装 Maven...${NC}"
            if brew install maven; then
                echo -e "${GREEN}✓ Maven 安装成功${NC}"
                return 0
            else
                echo -e "${RED}✗ Maven 安装失败${NC}"
                return 1
            fi
        fi
    fi
    return 1
}

echo -e "${YELLOW}检查环境依赖...${NC}"
echo ""

MISSING_DEPS=0

# 检查 Java
if ! check_command java "使用 Homebrew: brew install openjdk@17"; then
    MISSING_DEPS=1
fi

# 检查 Maven
if ! check_command mvn "使用 Homebrew: brew install maven"; then
    MISSING_DEPS=1
    if try_install_maven; then
        MISSING_DEPS=0
    fi
fi

# 检查 Node.js
if ! check_command node "使用 Homebrew: brew install node"; then
    MISSING_DEPS=1
fi

# 检查 npm
if ! check_command npm "通常随 Node.js 一起安装"; then
    MISSING_DEPS=1
fi

# 检查 MySQL
if ! check_command mysql "使用 Homebrew: brew install mysql"; then
    MISSING_DEPS=1
fi

echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  缺少必要的依赖工具${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo -e "${YELLOW}安装指南（Mac 系统）:${NC}"
    echo ""
    echo -e "${CYAN}1. 安装 Homebrew (如果未安装):${NC}"
    echo -e "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo ""
    echo -e "${CYAN}2. 安装必要的工具:${NC}"
    echo -e "   brew install openjdk@17 maven node mysql"
    echo ""
    echo -e "${CYAN}3. 配置 Java 环境变量 (添加到 ~/.zshrc 或 ~/.bash_profile):${NC}"
    echo -e "   export JAVA_HOME=\$(/usr/libexec/java_home -v 17)"
    echo -e "   export PATH=\$JAVA_HOME/bin:\$PATH"
    echo ""
    echo -e "${CYAN}4. 启动 MySQL 服务:${NC}"
    echo -e "   brew services start mysql"
    echo ""
    echo -e "${YELLOW}安装完成后，请重新运行此脚本。${NC}"
    exit 1
fi

# 检查 Java 版本
echo -e "${YELLOW}检查 Java 版本...${NC}"
JAVA_VERSION_OUTPUT=$(java -version 2>&1)
JAVA_VERSION=$(echo "$JAVA_VERSION_OUTPUT" | head -n 1 | grep -oE 'version "([0-9]+)' | grep -oE '[0-9]+' | head -n 1)

if [ -z "$JAVA_VERSION" ]; then
    # 尝试另一种方式获取版本
    JAVA_VERSION=$(echo "$JAVA_VERSION_OUTPUT" | head -n 1 | sed 's/.*version "\([0-9]*\)\..*/\1/')
fi

if [ ! -z "$JAVA_VERSION" ] && [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}✗ Java 版本过低，需要 Java 17 或更高版本，当前版本: $JAVA_VERSION${NC}"
    echo -e "${CYAN}  安装 Java 17: brew install openjdk@17${NC}"
    exit 1
elif [ ! -z "$JAVA_VERSION" ]; then
    echo -e "${GREEN}✓ Java 版本: $JAVA_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ 无法确定 Java 版本，继续执行...${NC}"
fi

echo ""

# 检查 MySQL 服务是否运行
echo -e "${YELLOW}检查 MySQL 服务...${NC}"
if ! mysqladmin ping -h localhost -u root --silent 2>/dev/null; then
    echo -e "${YELLOW}警告: MySQL 服务可能未运行，尝试启动...${NC}"
    # 尝试启动 MySQL（macOS 使用 brew services）
    if command -v brew &> /dev/null; then
        brew services start mysql 2>/dev/null || true
        echo -e "${YELLOW}等待 MySQL 服务启动...${NC}"
        # 等待最多 15 秒，每 1 秒检查一次
        for i in {1..15}; do
            if mysqladmin ping -h localhost -u root --silent 2>/dev/null; then
                echo -e "${GREEN}✓ MySQL 服务已启动${NC}"
                break
            fi
            if [ $i -eq 15 ]; then
                echo -e "${RED}错误: MySQL 服务启动超时${NC}"
                echo -e "${YELLOW}请手动检查 MySQL 服务状态:${NC}"
                echo -e "${CYAN}  brew services list | grep mysql${NC}"
                echo -e "${CYAN}  mysqladmin ping -h localhost -u root${NC}"
                exit 1
            fi
            sleep 1
        done
    else
        echo -e "${RED}错误: 无法启动 MySQL 服务（未找到 brew 命令）${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ MySQL 服务正常${NC}"
fi
echo ""

# 检查并创建数据库
echo -e "${YELLOW}检查数据库...${NC}"
if ! mysql -u root -e "USE todoapp;" 2>/dev/null; then
    echo -e "${YELLOW}数据库不存在，正在创建...${NC}"
    mysql -u root < "$BACKEND_DIR/db/todoapp.sql" 2>/dev/null || {
        echo -e "${YELLOW}尝试直接创建数据库...${NC}"
        mysql -u root -e "CREATE DATABASE IF NOT EXISTS todoapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || {
            echo -e "${RED}错误: 无法创建数据库${NC}"
            exit 1
        }
    }
    echo -e "${GREEN}✓ 数据库创建成功${NC}"
else
    echo -e "${GREEN}✓ 数据库已存在${NC}"
fi
echo ""

# 清理函数
cleanup() {
    echo ""
    echo -e "${YELLOW}正在停止服务...${NC}"
    if [ -f "$PID_FILE" ]; then
        while read pid; do
            if ps -p $pid > /dev/null 2>&1; then
                kill $pid 2>/dev/null || true
            fi
        done < "$PID_FILE"
        rm -f "$PID_FILE"
    fi
    echo -e "${GREEN}服务已停止${NC}"
    exit 0
}

# 捕获退出信号
trap cleanup SIGINT SIGTERM

# 检查端口是否被占用
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        return 0
    else
        return 1
    fi
}

# 启动后端服务
start_backend() {
    echo -e "${YELLOW}启动后端服务...${NC}"
    
    if check_port 8000; then
        echo -e "${YELLOW}端口 8000 已被占用，跳过后端启动${NC}"
        return
    fi
    
    cd "$BACKEND_DIR"
    
    # 检查是否需要安装依赖
    if [ ! -d "target" ] || [ ! -f "target/todoapp-backend-1.0.0.jar" ]; then
        echo -e "${YELLOW}编译后端项目...${NC}"
        mvn clean install -DskipTests > "$BACKEND_LOG" 2>&1
    fi
    
    # 启动 Spring Boot 应用
    echo -e "${YELLOW}启动 Spring Boot 应用...${NC}"
    nohup mvn spring-boot:run > "$BACKEND_LOG" 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID >> "$PID_FILE"
    
    # 等待后端启动
    echo -e "${YELLOW}等待后端服务启动...${NC}"
    for i in {1..30}; do
        if curl -s http://localhost:8000/api/v1/todos > /dev/null 2>&1; then
            echo -e "${GREEN}✓ 后端服务已启动 (PID: $BACKEND_PID)${NC}"
            echo -e "${GREEN}  访问地址: http://localhost:8000${NC}"
            echo -e "${GREEN}  API 文档: http://localhost:8000/swagger-ui.html${NC}"
            return 0
        fi
        sleep 1
    done
    
    echo -e "${RED}错误: 后端服务启动超时${NC}"
    echo -e "${YELLOW}请查看日志文件: $BACKEND_LOG${NC}"
    return 1
}

# 启动前端服务
start_frontend() {
    echo -e "${YELLOW}启动前端服务...${NC}"
    
    if check_port 3000; then
        echo -e "${YELLOW}端口 3000 已被占用，跳过前端启动${NC}"
        return
    fi
    
    cd "$FRONTEND_DIR"
    
    # 检查是否需要安装依赖
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}安装前端依赖...${NC}"
        npm install > "$FRONTEND_LOG" 2>&1
    fi
    
    # 启动 React 应用
    echo -e "${YELLOW}启动 React 应用...${NC}"
    nohup npm start > "$FRONTEND_LOG" 2>&1 &
    FRONTEND_PID=$!
    echo $FRONTEND_PID >> "$PID_FILE"
    
    # 等待前端启动
    echo -e "${YELLOW}等待前端服务启动...${NC}"
    for i in {1..60}; do
        if curl -s http://localhost:3000 > /dev/null 2>&1; then
            echo -e "${GREEN}✓ 前端服务已启动 (PID: $FRONTEND_PID)${NC}"
            echo -e "${GREEN}  访问地址: http://localhost:3000${NC}"
            return 0
        fi
        sleep 1
    done
    
    echo -e "${YELLOW}前端服务可能正在启动中...${NC}"
    echo -e "${YELLOW}请查看日志文件: $FRONTEND_LOG${NC}"
    return 0
}

# 启动服务
start_backend
echo ""
start_frontend
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  所有服务已启动！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}服务信息:${NC}"
echo -e "  后端: http://localhost:8000"
echo -e "  前端: http://localhost:3000"
echo -e "  API文档: http://localhost:8000/swagger-ui.html"
echo ""
echo -e "${YELLOW}日志文件:${NC}"
echo -e "  后端日志: $BACKEND_LOG"
echo -e "  前端日志: $FRONTEND_LOG"
echo ""
echo -e "${YELLOW}按 Ctrl+C 停止所有服务${NC}"
echo ""

# 保持脚本运行
wait

