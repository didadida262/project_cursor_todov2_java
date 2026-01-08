import React from 'react';
import './ActionButtons.css';

function ActionButtons({ onClearCompleted, onClearAll, hasCompleted, hasTodos, t }) {
  if (!hasTodos) {
    return null;
  }

  return (
    <div className="action-buttons">
      {hasCompleted && (
        <button
          className="action-button clear-completed"
          onClick={onClearCompleted}
        >
          {t.clearCompleted}
        </button>
      )}
      <button
        className="action-button clear-all"
        onClick={onClearAll}
      >
        {t.clearAll}
      </button>
    </div>
  );
}

export default ActionButtons;

