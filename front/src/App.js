import React, { useState, useEffect } from 'react';
import './App.css';
import TodoForm from './components/TodoForm';
import TodoList from './components/TodoList';
import FilterButtons from './components/FilterButtons';
import ActionButtons from './components/ActionButtons';
import LanguageSelector from './components/LanguageSelector';
import { todoService } from './services/api';
import translations from './utils/i18n';

function App() {
  const [todos, setTodos] = useState([]);
  const [filter, setFilter] = useState('all'); // 'all', 'active', 'completed'
  const [language, setLanguage] = useState('en');
  const [loading, setLoading] = useState(false);

  const t = translations[language];

  useEffect(() => {
    loadTodos();
  }, []);

  const loadTodos = async () => {
    try {
      setLoading(true);
      const response = await todoService.getAllTodos();
      if (response.data && response.data.data) {
        setTodos(response.data.data);
      }
    } catch (error) {
      console.error('Error loading todos:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleAddTodo = async (title) => {
    if (!title.trim()) return;

    try {
      const response = await todoService.createTodo({ title });
      if (response.data && response.data.data) {
        setTodos([...todos, response.data.data]);
      }
    } catch (error) {
      console.error('Error adding todo:', error);
      alert('Failed to add todo');
    }
  };

  const handleToggleTodo = async (id) => {
    try {
      const response = await todoService.toggleTodo(id);
      if (response.data && response.data.data) {
        setTodos(todos.map(todo =>
          todo.id === id
            ? { ...todo, completed: response.data.data.completed }
            : todo
        ));
      }
    } catch (error) {
      console.error('Error toggling todo:', error);
      alert('Failed to toggle todo');
    }
  };

  const handleDeleteTodo = async (id) => {
    try {
      await todoService.deleteTodo(id);
      setTodos(todos.filter(todo => todo.id !== id));
    } catch (error) {
      console.error('Error deleting todo:', error);
      alert('Failed to delete todo');
    }
  };

  const handleClearCompleted = async () => {
    try {
      await todoService.deleteCompletedTodos();
      setTodos(todos.filter(todo => !todo.completed));
    } catch (error) {
      console.error('Error clearing completed todos:', error);
      alert('Failed to clear completed todos');
    }
  };

  const handleClearAll = async () => {
    if (!window.confirm(language === 'en' 
      ? 'Are you sure you want to delete all todos?' 
      : '确定要删除所有任务吗？')) {
      return;
    }
    try {
      await todoService.deleteAllTodos();
      setTodos([]);
    } catch (error) {
      console.error('Error clearing all todos:', error);
      alert('Failed to clear all todos');
    }
  };

  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return !todo.completed;
    if (filter === 'completed') return todo.completed;
    return true;
  });

  return (
    <div className="App">
      <div className="container">
        <div className="header">
          <h1>{t.title}</h1>
          <LanguageSelector language={language} setLanguage={setLanguage} t={t} />
        </div>

        <TodoForm onAdd={handleAddTodo} placeholder={t.taskPlaceholder} addButtonText={t.addTask} />

        <FilterButtons filter={filter} setFilter={setFilter} t={t} />

        <div className="todo-list-container">
          {loading ? (
            <div className="loading">Loading...</div>
          ) : (
            <TodoList
              todos={filteredTodos}
              onToggle={handleToggleTodo}
              onDelete={handleDeleteTodo}
              t={t}
            />
          )}
        </div>

        <ActionButtons
          onClearCompleted={handleClearCompleted}
          onClearAll={handleClearAll}
          hasCompleted={todos.some(todo => todo.completed)}
          hasTodos={todos.length > 0}
          t={t}
        />
      </div>
    </div>
  );
}

export default App;

