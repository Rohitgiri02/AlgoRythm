import axios from 'axios';

// Base URL for your backend API
const API_BASE_URL = 'http://localhost:8080/Algorythm';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Important for session-based auth
});

// Request interceptor for adding auth token if needed
api.interceptors.request.use(
  (config) => {
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    if (user.token) {
      config.headers.Authorization = `Bearer ${user.token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for handling errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - clear user data and redirect to login
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API calls
export const authAPI = {
  register: async (username, email, password) => {
    const formData = new URLSearchParams();
    formData.append('username', username);
    formData.append('email', email);
    formData.append('password', password);
    
    const response = await api.post('/user/register', formData, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    });
    return response.data;
  },

  login: async (email, password) => {
    const formData = new URLSearchParams();
    formData.append('email', email);
    formData.append('password', password);
    
    const response = await api.post('/user/login', formData, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    });
    return response.data;
  },

  logout: async () => {
    const response = await api.get('/user/logout');
    return response.data;
  },

  getProfile: async () => {
    const response = await api.get('/user/profile');
    return response.data;
  },
};

// Songs API calls
export const songsAPI = {
  getAllSongs: async () => {
    const response = await api.get('/songs');
    return response.data;
  },

  getSongById: async (id) => {
    const response = await api.get(`/songs/${id}`);
    return response.data;
  },

  searchSongs: async (query) => {
    const response = await api.get(`/songs/search?q=${encodeURIComponent(query)}`);
    return response.data;
  },

  getSongsByArtist: async (artistId) => {
    const response = await api.get(`/songs/artist/${artistId}`);
    return response.data;
  },

  getSongsByAlbum: async (albumId) => {
    const response = await api.get(`/songs/album/${albumId}`);
    return response.data;
  },
};

// User activity API calls
export const activityAPI = {
  addToListeningHistory: async (songId, durationPlayed, completionPercentage) => {
    const response = await api.post('/activity/listen', {
      songId,
      durationPlayed,
      completionPercentage,
    });
    return response.data;
  },

  likeSong: async (songId) => {
    const response = await api.post('/activity/like', { entityType: 'Song', entityId: songId });
    return response.data;
  },

  unlikeSong: async (songId) => {
    const response = await api.delete(`/activity/like/Song/${songId}`);
    return response.data;
  },

  getLikedSongs: async () => {
    const response = await api.get('/activity/likes');
    return response.data;
  },

  getListeningHistory: async (limit = 50) => {
    const response = await api.get(`/activity/history?limit=${limit}`);
    return response.data;
  },
};

// Playlists API calls
export const playlistsAPI = {
  getUserPlaylists: async () => {
    const response = await api.get('/playlists');
    return response.data;
  },

  createPlaylist: async (name, description, isPublic = true) => {
    const response = await api.post('/playlists', { name, description, isPublic });
    return response.data;
  },

  addSongToPlaylist: async (playlistId, songId) => {
    const response = await api.post(`/playlists/${playlistId}/songs`, { songId });
    return response.data;
  },

  removeSongFromPlaylist: async (playlistId, songId) => {
    const response = await api.delete(`/playlists/${playlistId}/songs/${songId}`);
    return response.data;
  },

  deletePlaylist: async (playlistId) => {
    const response = await api.delete(`/playlists/${playlistId}`);
    return response.data;
  },
};

// Artists API calls
export const artistsAPI = {
  getAllArtists: async () => {
    const response = await api.get('/artists');
    return response.data;
  },

  getArtistById: async (id) => {
    const response = await api.get(`/artists/${id}`);
    return response.data;
  },

  followArtist: async (artistId) => {
    const response = await api.post('/activity/follow', { entityType: 'Artist', entityId: artistId });
    return response.data;
  },

  unfollowArtist: async (artistId) => {
    const response = await api.delete(`/activity/follow/Artist/${artistId}`);
    return response.data;
  },
};

// Albums API calls
export const albumsAPI = {
  getAllAlbums: async () => {
    const response = await api.get('/albums');
    return response.data;
  },

  getAlbumById: async (id) => {
    const response = await api.get(`/albums/${id}`);
    return response.data;
  },

  getAlbumsByArtist: async (artistId) => {
    const response = await api.get(`/albums/artist/${artistId}`);
    return response.data;
  },
};

export default api;
