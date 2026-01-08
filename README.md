# Todo Application

一个功能完整的待办事项管理应用，基于 React + Spring Boot + MySQL 开发。

## 项目结构

```
project_cursor_todov2_java/
├── backend/          # Spring Boot 后端项目
│   ├── src/
│   ├── db/           # 数据库初始化脚本
│   └── pom.xml
├── front/            # React 前端项目
│   ├── src/
│   ├── public/
│   └── package.json
├── start.sh          # 一键启动脚本（Mac）
├── stop.sh           # 停止脚本（Mac）
└── README.md
```

## 技术栈

### 后端
- Java 17+
- Spring Boot 3.2.0
- Spring Data JPA
- MySQL 5.7+
- Lombok
- Swagger (springdoc-openapi)

### 前端
- React 18.2.0
- Axios
- CSS3

## 环境要求

- Java 17 或更高版本
- Maven 3.6+
- Node.js 16+ 和 npm
- MySQL 5.7+ 或更高版本

> 📖 **详细安装指南请参考 [INSTALL.md](INSTALL.md)**  
> ☕ **Java 环境变量配置详细步骤请参考 [JAVA_SETUP.md](JAVA_SETUP.md)**  
> 🍺 **Homebrew 安装后配置请参考 [HOMEBREW_SETUP.md](HOMEBREW_SETUP.md)**

## 数据库配置

1. 确保 MySQL 服务正在运行
2. 创建数据库（可选，应用会自动创建）：
   ```sql
   CREATE DATABASE todoapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. 或者运行初始化脚本：
   ```bash
   mysql -u root < backend/db/todoapp.sql
   ```

数据库配置信息：
- 地址：localhost:3306
- 用户名：root
- 密码：空（无密码）
- 数据库名：todoapp

## 快速开始

### 🚀 一键启动（推荐，Mac 系统）

项目提供了便捷的一键启动脚本，自动检查环境、创建数据库并启动所有服务：

```bash
# 启动所有服务
./start.sh

# 停止所有服务
./stop.sh
```

启动脚本会自动：
- ✅ 检查 Java、Maven、Node.js、MySQL 环境
- ✅ 提供友好的错误提示和安装指导
- ✅ 尝试自动安装缺失的工具（如果使用 Homebrew）
- ✅ 检查并启动 MySQL 服务
- ✅ 自动创建数据库（如果不存在）
- ✅ 编译并启动后端服务（端口 8000）
- ✅ 安装依赖并启动前端服务（端口 3000）
- ✅ 显示服务访问地址和日志文件位置

**注意**：
- 首次运行可能需要几分钟时间来安装依赖和编译项目
- 如果缺少必要的工具，脚本会显示详细的安装指导
- 按 `Ctrl+C` 可以停止所有服务，或使用 `./stop.sh` 脚本

**如果遇到环境问题，请参考 [INSTALL.md](INSTALL.md) 进行环境配置。**

---

### 手动启动

如果需要手动启动服务，可以按照以下步骤：

#### 1. 启动后端服务

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

后端服务将在 `http://localhost:8000` 启动

API 文档访问地址：`http://localhost:8000/swagger-ui.html`

### 2. 启动前端服务

```bash
cd front
npm install
npm start
```

前端应用将在 `http://localhost:3000` 启动

## 功能特性

- ✅ 添加待办事项
- ✅ 标记完成/未完成
- ✅ 删除单个任务
- ✅ 过滤显示（全部/未完成/已完成）
- ✅ 批量删除已完成任务
- ✅ 清空所有任务
- ✅ 中英文语言切换
- ✅ 响应式设计
- ✅ 现代化UI界面

## API 接口

所有 API 接口前缀：`/api/v1`

### 主要接口

- `GET /api/v1/todos` - 获取待办事项列表
- `POST /api/v1/todos` - 创建待办事项
- `PUT /api/v1/todos/{id}` - 更新待办事项
- `DELETE /api/v1/todos/{id}` - 删除待办事项
- `PATCH /api/v1/todos/{id}/toggle` - 切换完成状态
- `DELETE /api/v1/todos/completed` - 批量删除已完成项
- `DELETE /api/v1/todos/all` - 清空所有待办事项

详细 API 文档请参考 `spec-req.md` 或访问 Swagger UI。

## 测试

### 后端测试

```bash
cd backend
mvn test
```

### 前端测试

```bash
cd front
npm test
```

## 构建部署

### 后端构建

```bash
cd backend
mvn clean package
java -jar target/todoapp-backend-1.0.0.jar
```

### 前端构建

```bash
cd front
npm run build
```

构建后的静态文件在 `front/build` 目录中。

## 开发说明

### 后端开发

- 主应用类：`com.todoapp.TodoApplication`
- 实体类：`com.todoapp.entity.Todo`
- 控制器：`com.todoapp.controller.TodoController`
- 服务层：`com.todoapp.service.TodoService`
- 数据访问层：`com.todoapp.repository.TodoRepository`

### 前端开发

- 主组件：`src/App.js`
- 组件目录：`src/components/`
- API 服务：`src/services/api.js`
- 国际化：`src/utils/i18n.js`

## 注意事项

1. 确保 MySQL 服务已启动
2. 确保数据库 `todoapp` 已创建
3. 后端和前端需要同时运行才能正常使用
4. 默认语言为英文
5. 数据库密码为空，仅用于开发环境

## 许可证

ISC
