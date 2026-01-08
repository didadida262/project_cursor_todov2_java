import React from 'react';
import TodoItem from './TodoItem';
import './TodoList.css';

function TodoList({ todos, onToggle, onDelete, t }) {
  if (todos.length === 0) {
    return <div className="empty-message">{t.noTasks}</div>;
  }

  return (
    <ul className="todo-list">
      {todos.map(todo => (
        <TodoItem
          key={todo.id}
          todo={todo}
          onToggle={onToggle}
          onDelete={onDelete}
          t={t}
        />
      ))}
    </ul>
  );
}

export default TodoList;

