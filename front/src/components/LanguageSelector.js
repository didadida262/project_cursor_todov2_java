import React from 'react';
import './LanguageSelector.css';

function LanguageSelector({ language, setLanguage, t }) {
  return (
    <div className="language-selector">
      <label htmlFor="language-select">{t.language}:</label>
      <select
        id="language-select"
        className="language-select"
        value={language}
        onChange={(e) => setLanguage(e.target.value)}
      >
        <option value="en">English</option>
        <option value="zh">中文</option>
      </select>
    </div>
  );
}

export default LanguageSelector;

