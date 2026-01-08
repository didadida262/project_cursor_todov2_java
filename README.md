# Todo Application

A full-featured todo management application built with React + Spring Boot + MySQL.

## Project Structure

```
project_cursor_todov2_java/
├── backend/          # Spring Boot backend project
│   ├── src/
│   ├── db/           # Database initialization scripts
│   └── pom.xml
├── front/            # React frontend project
│   ├── src/
│   ├── public/
│   └── package.json
├── start.sh          # One-click startup script (Mac)
├── stop.sh           # Stop script (Mac)
└── README.md
```

## Tech Stack

### Backend
- Java 17+
- Spring Boot 3.2.0
- Spring Data JPA
- MySQL 5.7+
- Lombok
- Swagger (springdoc-openapi)

### Frontend
- React 18.2.0
- Axios
- CSS3

## Requirements

- Java 17 or higher
- Maven 3.6+
- Node.js 16+ and npm
- MySQL 5.7+ or higher

> 📖 **For detailed installation guide, please refer to [INSTALL.md](INSTALL.md)**  
> ☕ **For detailed Java environment variable configuration, please refer to [JAVA_SETUP.md](JAVA_SETUP.md)**  
> 🍺 **For Homebrew post-installation configuration, please refer to [HOMEBREW_SETUP.md](HOMEBREW_SETUP.md)**

## Database Configuration

1. Ensure MySQL service is running
2. Create database (optional, application will create automatically):
   ```sql
   CREATE DATABASE todoapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Or run the initialization script:
   ```bash
   mysql -u root < backend/db/todoapp.sql
   ```

Database configuration:
- Address: localhost:3306
- Username: root
- Password: empty (no password)
- Database name: todoapp

## Quick Start

### 🚀 One-Click Startup (Recommended for Mac)

The project provides a convenient one-click startup script that automatically checks the environment, creates the database, and starts all services:

```bash
# Start all services
./start.sh

# Stop all services
./stop.sh
```

The startup script will automatically:
- ✅ Check Java, Maven, Node.js, MySQL environment
- ✅ Provide friendly error messages and installation guidance
- ✅ Attempt to automatically install missing tools (if using Homebrew)
- ✅ Check and start MySQL service
- ✅ Automatically create database (if it doesn't exist)
- ✅ Compile and start backend service (port 8000)
- ✅ Install dependencies and start frontend service (port 3000)
- ✅ Display service access addresses and log file locations

**Note**:
- First run may take a few minutes to install dependencies and compile the project
- If required tools are missing, the script will display detailed installation instructions
- Press `Ctrl+C` to stop all services, or use `./stop.sh` script

**If you encounter environment issues, please refer to [INSTALL.md](INSTALL.md) for environment configuration.**

---

### Manual Startup

If you need to start services manually, follow these steps:

#### 1. Start Backend Service

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend service will start at `http://localhost:8000`

API documentation: `http://localhost:8000/swagger-ui.html`

#### 2. Start Frontend Service

```bash
cd front
npm install
npm start
```

Frontend application will start at `http://localhost:3000`

## Features

- ✅ Add todos
- ✅ Mark complete/incomplete
- ✅ Delete individual tasks
- ✅ Filter display (All/Active/Completed)
- ✅ Batch delete completed tasks
- ✅ Clear all tasks
- ✅ Chinese/English language switching
- ✅ Responsive design
- ✅ Modern UI interface

## API Endpoints

All API endpoints prefix: `/api/v1`

### Main Endpoints

- `GET /api/v1/todos` - Get todo list
- `POST /api/v1/todos` - Create todo
- `PUT /api/v1/todos/{id}` - Update todo
- `DELETE /api/v1/todos/{id}` - Delete todo
- `PATCH /api/v1/todos/{id}/toggle` - Toggle completion status
- `DELETE /api/v1/todos/completed` - Batch delete completed items
- `DELETE /api/v1/todos/all` - Clear all todos

For detailed API documentation, please refer to `spec-req.md` or visit Swagger UI.

## Testing

### Backend Testing

```bash
cd backend
mvn test
```

### Frontend Testing

```bash
cd front
npm test
```

## Build & Deployment

### Backend Build

```bash
cd backend
mvn clean package
java -jar target/todoapp-backend-1.0.0.jar
```

### Frontend Build

```bash
cd front
npm run build
```

Built static files are in the `front/build` directory.

## Development Guide

### Backend Development

- Main application class: `com.todoapp.TodoApplication`
- Entity class: `com.todoapp.entity.Todo`
- Controller: `com.todoapp.controller.TodoController`
- Service layer: `com.todoapp.service.TodoService`
- Data access layer: `com.todoapp.repository.TodoRepository`

### Frontend Development

- Main component: `src/App.js`
- Components directory: `src/components/`
- API service: `src/services/api.js`
- Internationalization: `src/utils/i18n.js`

## Notes

1. Ensure MySQL service is started
2. Ensure database `todoapp` is created
3. Both backend and frontend need to be running simultaneously for normal use
4. Default language is English
5. Database password is empty, for development environment only

## License

ISC
