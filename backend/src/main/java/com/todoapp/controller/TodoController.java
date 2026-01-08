package com.todoapp.controller;

import com.todoapp.dto.ApiResponse;
import com.todoapp.dto.TodoRequest;
import com.todoapp.entity.Todo;
import com.todoapp.service.TodoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/todos")
@RequiredArgsConstructor
@Tag(name = "Todo API", description = "待办事项管理API")
@CrossOrigin(origins = "http://localhost:3000")
public class TodoController {
    private final TodoService todoService;

    @GetMapping
    @Operation(summary = "获取所有待办事项", description = "支持按完成状态过滤和分页")
    public ResponseEntity<ApiResponse<List<Todo>>> getAllTodos(
            @RequestParam(required = false) Boolean completed,
            @RequestParam(required = false) Integer limit,
            @RequestParam(required = false) Integer offset) {
        List<Todo> todos = todoService.getAllTodos(completed, limit, offset);
        Long total = todoService.getTotalCount(completed);
        return ResponseEntity.ok(ApiResponse.success(todos, total));
    }

    @PostMapping
    @Operation(summary = "创建待办事项")
    public ResponseEntity<ApiResponse<Todo>> createTodo(@RequestBody TodoRequest request) {
        if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(400, "Title is required"));
        }
        Todo todo = todoService.createTodo(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created(todo));
    }

    @PutMapping("/{todo_id}")
    @Operation(summary = "更新待办事项")
    public ResponseEntity<ApiResponse<Todo>> updateTodo(
            @PathVariable("todo_id") Long id,
            @RequestBody TodoRequest request) {
        try {
            Todo todo = todoService.updateTodo(id, request);
            return ResponseEntity.ok(ApiResponse.success(todo));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(404, "Todo not found"));
        }
    }

    @DeleteMapping("/{todo_id}")
    @Operation(summary = "删除待办事项")
    public ResponseEntity<ApiResponse<Void>> deleteTodo(@PathVariable("todo_id") Long id) {
        try {
            todoService.deleteTodo(id);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(404, "Todo not found"));
        }
    }

    @PatchMapping("/{todo_id}/toggle")
    @Operation(summary = "切换完成状态")
    public ResponseEntity<ApiResponse<Map<String, Object>>> toggleTodo(@PathVariable("todo_id") Long id) {
        try {
            Todo todo = todoService.toggleTodo(id);
            Map<String, Object> data = new HashMap<>();
            data.put("id", todo.getId());
            data.put("completed", todo.getCompleted());
            data.put("updated_at", todo.getUpdatedAt());
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(404, "Todo not found"));
        }
    }

    @DeleteMapping("/completed")
    @Operation(summary = "批量删除已完成项")
    public ResponseEntity<ApiResponse<Map<String, Object>>> deleteCompletedTodos() {
        Long deletedCount = todoService.deleteCompletedTodos();
        Map<String, Object> data = new HashMap<>();
        data.put("deleted_count", deletedCount);
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    @DeleteMapping("/all")
    @Operation(summary = "清空所有待办事项")
    public ResponseEntity<ApiResponse<Map<String, Object>>> deleteAllTodos() {
        Long deletedCount = todoService.deleteAllTodos();
        Map<String, Object> data = new HashMap<>();
        data.put("deleted_count", deletedCount);
        return ResponseEntity.ok(ApiResponse.success(data));
    }
}

