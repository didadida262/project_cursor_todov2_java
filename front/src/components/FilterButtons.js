import React from 'react';
import './FilterButtons.css';

function FilterButtons({ filter, setFilter, t }) {
  return (
    <div className="filter-buttons">
      <button
        className={`filter-button ${filter === 'all' ? 'active' : ''}`}
        onClick={() => setFilter('all')}
      >
        {t.all}
      </button>
      <button
        className={`filter-button ${filter === 'active' ? 'active' : ''}`}
        onClick={() => setFilter('active')}
      >
        {t.active}
      </button>
      <button
        className={`filter-button ${filter === 'completed' ? 'active' : ''}`}
        onClick={() => setFilter('completed')}
      >
        {t.completed}
      </button>
    </div>
  );
}

export default FilterButtons;

