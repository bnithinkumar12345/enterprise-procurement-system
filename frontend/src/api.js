import axios from 'axios';

// 1. Create a base Axios instance
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api', // Replace with your actual Spring Boot backend URL
  headers: {
    'Content-Type': 'application/json',
  },
});

// 2. Add a Request Interceptor to handle Security (JWT Injection)
apiClient.interceptors.request.use(
  (config) => {
    // Retrieve the token from secure storage
    const token = localStorage.getItem('token');
    
    // If the token exists, attach it to the Authorization header
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 3. Add a Response Interceptor to handle expired tokens
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      // If the backend rejects the token (e.g., it expired), force a logout
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login'; // Redirect to the new login page
    }
    return Promise.reject(error);
  }
);

// 4. Lightweight fetch-based helper used by feature components.
// Contract: apiFetch(path, fetchOptions, token) -> parsed JSON body.
// `path` is expected to already include the leading "/api/..." segment,
// so the base here intentionally omits "/api" (unlike apiClient above).
const API_BASE_URL = 'http://localhost:8080';

export async function apiFetch(path, options = {}, token) {
  const { headers, ...restOptions } = options;

  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...restOptions,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
  });

  if (response.status === 401) {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/login';
  }

  // Handle empty/no-content responses (e.g. 204 from DELETE)
  const rawBody = await response.text();
  const data = rawBody ? JSON.parse(rawBody) : null;

  if (!response.ok) {
    let message = (data && (data.message || data.error)) || `Request failed with status ${response.status}`;
    
    // Append field-specific validation errors if provided by the backend
    if (data && data.errors && typeof data.errors === 'object') {
      const fieldErrors = Object.entries(data.errors)
        .map(([field, err]) => `${field}: ${err}`)
        .join(', ');
      if (fieldErrors) {
        message = `${message} — ${fieldErrors}`;
      }
    }
    
    throw new Error(message);
  }

  return data;
}

export default apiClient;