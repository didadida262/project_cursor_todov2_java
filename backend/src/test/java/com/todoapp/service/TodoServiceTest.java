package com.todoapp.service;

import com.todoapp.dto.TodoRequest;
import com.todoapp.entity.Todo;
import com.todoapp.repository.TodoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TodoServiceTest {
    @Mock
    private TodoRepository todoRepository;

    @InjectMocks
    private TodoService todoService;

    private Todo todo1;
    private Todo todo2;

    @BeforeEach
    void setUp() {
        todo1 = new Todo();
        todo1.setId(1L);
        todo1.setTitle("Test Todo 1");
        todo1.setCompleted(false);

        todo2 = new Todo();
        todo2.setId(2L);
        todo2.setTitle("Test Todo 2");
        todo2.setCompleted(true);
    }

    @Test
    void testGetAllTodos() {
        when(todoRepository.findAll()).thenReturn(Arrays.asList(todo1, todo2));
        List<Todo> todos = todoService.getAllTodos(null, null, null);
        assertEquals(2, todos.size());
        verify(todoRepository).findAll();
    }

    @Test
    void testGetAllTodosWithCompletedFilter() {
        when(todoRepository.findByCompleted(false)).thenReturn(Arrays.asList(todo1));
        List<Todo> todos = todoService.getAllTodos(false, null, null);
        assertEquals(1, todos.size());
        assertFalse(todos.get(0).getCompleted());
        verify(todoRepository).findByCompleted(false);
    }

    @Test
    void testCreateTodo() {
        TodoRequest request = new TodoRequest();
        request.setTitle("New Todo");
        request.setDescription("Description");
        request.setPriority(1);

        Todo savedTodo = new Todo();
        savedTodo.setId(1L);
        savedTodo.setTitle("New Todo");
        savedTodo.setDescription("Description");
        savedTodo.setPriority(1);
        savedTodo.setCompleted(false);

        when(todoRepository.save(any(Todo.class))).thenReturn(savedTodo);
        Todo result = todoService.createTodo(request);

        assertNotNull(result);
        assertEquals("New Todo", result.getTitle());
        assertFalse(result.getCompleted());
        verify(todoRepository).save(any(Todo.class));
    }

    @Test
    void testUpdateTodo() {
        TodoRequest request = new TodoRequest();
        request.setTitle("Updated Title");
        request.setCompleted(true);

        when(todoRepository.findById(1L)).thenReturn(Optional.of(todo1));
        when(todoRepository.save(any(Todo.class))).thenReturn(todo1);

        Todo result = todoService.updateTodo(1L, request);

        assertNotNull(result);
        verify(todoRepository).findById(1L);
        verify(todoRepository).save(any(Todo.class));
    }

    @Test
    void testUpdateTodoNotFound() {
        TodoRequest request = new TodoRequest();
        when(todoRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> todoService.updateTodo(999L, request));
    }

    @Test
    void testToggleTodo() {
        when(todoRepository.findById(1L)).thenReturn(Optional.of(todo1));
        when(todoRepository.save(any(Todo.class))).thenReturn(todo1);

        Todo result = todoService.toggleTodo(1L);

        assertNotNull(result);
        verify(todoRepository).findById(1L);
        verify(todoRepository).save(any(Todo.class));
    }

    @Test
    void testDeleteTodo() {
        when(todoRepository.existsById(1L)).thenReturn(true);
        doNothing().when(todoRepository).deleteById(1L);

        todoService.deleteTodo(1L);

        verify(todoRepository).existsById(1L);
        verify(todoRepository).deleteById(1L);
    }

    @Test
    void testDeleteCompletedTodos() {
        when(todoRepository.findByCompleted(true)).thenReturn(Arrays.asList(todo2));
        doNothing().when(todoRepository).deleteAll(anyList());

        Long count = todoService.deleteCompletedTodos();

        assertEquals(1L, count);
        verify(todoRepository).findByCompleted(true);
        verify(todoRepository).deleteAll(anyList());
    }

    @Test
    void testDeleteAllTodos() {
        when(todoRepository.count()).thenReturn(2L);
        doNothing().when(todoRepository).deleteAll();

        Long count = todoService.deleteAllTodos();

        assertEquals(2L, count);
        verify(todoRepository).count();
        verify(todoRepository).deleteAll();
    }
}

