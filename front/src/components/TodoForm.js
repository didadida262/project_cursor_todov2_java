import React, { useState } from 'react';
import './TodoForm.css';

function TodoForm({ onAdd, placeholder, addButtonText }) {
  const [input, setInput] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (input.trim()) {
      onAdd(input);
      setInput('');
    }
  };

  return (
    <form className="todo-form" onSubmit={handleSubmit}>
      <input
        type="text"
        className="todo-input"
        placeholder={placeholder}
        value={input}
        onChange={(e) => setInput(e.target.value)}
      />
      <button type="submit" className="add-button">
        {addButtonText}
      </button>
    </form>
  );
}

export default TodoForm;

