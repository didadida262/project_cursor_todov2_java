#!/bin/bash

# Todo App 停止脚本
# 用于停止所有运行中的服务

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$PROJECT_ROOT/.pids"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   停止 Todo App 服务${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 通过 PID 文件停止服务
if [ -f "$PID_FILE" ]; then
    echo -e "${YELLOW}正在停止服务...${NC}"
    STOPPED=0
    while read pid; do
        if ps -p $pid > /dev/null 2>&1; then
            echo -e "${YELLOW}停止进程 PID: $pid${NC}"
            kill $pid 2>/dev/null || true
            STOPPED=1
        fi
    done < "$PID_FILE"
    rm -f "$PID_FILE"
    
    if [ $STOPPED -eq 1 ]; then
        echo -e "${GREEN}✓ 服务已停止${NC}"
    else
        echo -e "${YELLOW}没有运行中的服务${NC}"
    fi
else
    echo -e "${YELLOW}PID 文件不存在，尝试通过端口停止服务...${NC}"
fi

# 通过端口停止服务（备用方案）
stop_by_port() {
    local port=$1
    local pids=$(lsof -ti :$port 2>/dev/null)
    if [ ! -z "$pids" ]; then
        echo -e "${YELLOW}停止占用端口 $port 的进程...${NC}"
        echo $pids | xargs kill 2>/dev/null || true
        return 0
    fi
    return 1
}

STOPPED_ANY=0

if stop_by_port 8000; then
    STOPPED_ANY=1
fi

if stop_by_port 3000; then
    STOPPED_ANY=1
fi

if [ $STOPPED_ANY -eq 1 ]; then
    echo -e "${GREEN}✓ 所有服务已停止${NC}"
else
    echo -e "${YELLOW}没有找到运行中的服务${NC}"
fi

echo ""

