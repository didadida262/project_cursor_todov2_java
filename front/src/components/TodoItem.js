import React from 'react';
import './TodoItem.css';

function TodoItem({ todo, onToggle, onDelete, t }) {
  return (
    <li className={`todo-item ${todo.completed ? 'completed' : ''}`}>
      <span className="todo-text">{todo.title}</span>
      <div className="todo-actions">
        <button
          className="complete-button"
          onClick={() => onToggle(todo.id)}
          title={t.complete}
        >
          {t.complete}
        </button>
        <button
          className="delete-button"
          onClick={() => onDelete(todo.id)}
          title={t.delete}
        >
          {t.delete}
        </button>
      </div>
    </li>
  );
}

export default TodoItem;

