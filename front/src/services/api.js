import axios from 'axios';

const API_BASE_URL = 'http://localhost:8000/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const todoService = {
  getAllTodos: (completed = null, limit = 100, offset = 0) => {
    const params = { limit, offset };
    if (completed !== null) {
      params.completed = completed;
    }
    return api.get('/todos', { params });
  },

  createTodo: (todo) => {
    return api.post('/todos', todo);
  },

  updateTodo: (id, todo) => {
    return api.put(`/todos/${id}`, todo);
  },

  deleteTodo: (id) => {
    return api.delete(`/todos/${id}`);
  },

  toggleTodo: (id) => {
    return api.patch(`/todos/${id}/toggle`);
  },

  deleteCompletedTodos: () => {
    return api.delete('/todos/completed');
  },

  deleteAllTodos: () => {
    return api.delete('/todos/all');
  },
};

export default api;

