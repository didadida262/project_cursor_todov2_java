package com.todoapp.service;

import com.todoapp.dto.TodoRequest;
import com.todoapp.entity.Todo;
import com.todoapp.repository.TodoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TodoService {
    private final TodoRepository todoRepository;

    public List<Todo> getAllTodos(Boolean completed, Integer limit, Integer offset) {
        List<Todo> todos;
        if (completed != null) {
            todos = todoRepository.findByCompleted(completed);
        } else {
            todos = todoRepository.findAll();
        }

        // Apply pagination
        int start = offset != null ? offset : 0;
        int end = limit != null ? Math.min(start + limit, todos.size()) : todos.size();
        return todos.subList(Math.min(start, todos.size()), end);
    }

    public Long getTotalCount(Boolean completed) {
        if (completed != null) {
            return todoRepository.findByCompleted(completed).stream().count();
        }
        return todoRepository.count();
    }

    @Transactional
    public Todo createTodo(TodoRequest request) {
        Todo todo = new Todo();
        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());
        todo.setPriority(request.getPriority() != null ? request.getPriority() : 0);
        todo.setDueDate(request.getDueDate());
        todo.setCompleted(false);
        return todoRepository.save(todo);
    }

    @Transactional
    public Todo updateTodo(Long id, TodoRequest request) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));

        if (request.getTitle() != null) {
            todo.setTitle(request.getTitle());
        }
        if (request.getDescription() != null) {
            todo.setDescription(request.getDescription());
        }
        if (request.getCompleted() != null) {
            todo.setCompleted(request.getCompleted());
        }
        if (request.getPriority() != null) {
            todo.setPriority(request.getPriority());
        }
        if (request.getDueDate() != null) {
            todo.setDueDate(request.getDueDate());
        }

        return todoRepository.save(todo);
    }

    @Transactional
    public Todo toggleTodo(Long id) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));
        todo.setCompleted(!todo.getCompleted());
        return todoRepository.save(todo);
    }

    @Transactional
    public void deleteTodo(Long id) {
        if (!todoRepository.existsById(id)) {
            throw new RuntimeException("Todo not found with id: " + id);
        }
        todoRepository.deleteById(id);
    }

    @Transactional
    public Long deleteCompletedTodos() {
        List<Todo> completedTodos = todoRepository.findByCompleted(true);
        long count = completedTodos.size();
        todoRepository.deleteAll(completedTodos);
        return count;
    }

    @Transactional
    public Long deleteAllTodos() {
        long count = todoRepository.count();
        todoRepository.deleteAll();
        return count;
    }

    public Todo getTodoById(Long id) {
        return todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));
    }
}

