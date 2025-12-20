import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { songsAPI, activityAPI } from '../services/api';
import './Dashboard.css';

export default function Dashboard() {
  const { user, logout } = useAuth();
  const [songs, setSongs] = useState([]);
  const [likedSongs, setLikedSongs] = useState(new Set());
  const [currentSong, setCurrentSong] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [activeTab, setActiveTab] = useState('discover');

  useEffect(() => {
    loadSongs();
    loadLikedSongs();
  }, []);

  const loadSongs = async () => {
    try {
      setLoading(true);
      const data = await songsAPI.getAllSongs();
      setSongs(data);
      setError('');
    } catch (err) {
      setError('Failed to load songs. Please try again.');
      console.error('Error loading songs:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadLikedSongs = async () => {
    try {
      const data = await activityAPI.getLikedSongs();
      const likedSet = new Set(data.map(item => item.entityId));
      setLikedSongs(likedSet);
    } catch (err) {
      console.error('Error loading liked songs:', err);
    }
  };

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchQuery.trim()) {
      loadSongs();
      return;
    }

    try {
      setLoading(true);
      const data = await songsAPI.searchSongs(searchQuery);
      setSongs(data);
    } catch (err) {
      setError('Search failed. Please try again.');
      console.error('Search error:', err);
    } finally {
      setLoading(false);
    }
  };

  const handlePlaySong = async (song) => {
    setCurrentSong(song);
    setIsPlaying(true);
    
    // Track listening history
    try {
      await activityAPI.addToListeningHistory(
        song.songId,
        song.durationSeconds,
        100
      );
    } catch (err) {
      console.error('Error tracking playback:', err);
    }
  };

  const handleLikeSong = async (songId) => {
    try {
      if (likedSongs.has(songId)) {
        await activityAPI.unlikeSong(songId);
        setLikedSongs(prev => {
          const newSet = new Set(prev);
          newSet.delete(songId);
          return newSet;
        });
      } else {
        await activityAPI.likeSong(songId);
        setLikedSongs(prev => new Set(prev).add(songId));
      }
    } catch (err) {
      console.error('Error toggling like:', err);
    }
  };

  const formatDuration = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="dashboard">
      {/* Backdrop for mobile */}
      {isSidebarOpen && (
        <div 
          className="backdrop" 
          onClick={() => setIsSidebarOpen(false)}
        ></div>
      )}
      
      {/* Sidebar */}
      <aside className={`sidebar ${isSidebarOpen ? 'open' : 'closed'}`}>
        <div className="logo">
          <h1>🎵 AlgoRythm</h1>
          <p className="ai-badge">AI Powered</p>
        </div>
        
        <nav className="nav-menu">
          <button 
            className={activeTab === 'discover' ? 'active' : ''} 
            onClick={() => setActiveTab('discover')}
          >
            <span className="icon">🔍</span> Discover
          </button>
          <button 
            className={activeTab === 'library' ? 'active' : ''} 
            onClick={() => setActiveTab('library')}
          >
            <span className="icon">📚</span> Library
          </button>
          <button 
            className={activeTab === 'liked' ? 'active' : ''} 
            onClick={() => setActiveTab('liked')}
          >
            <span className="icon">❤️</span> Liked Songs
          </button>
        </nav>

        <div className="sidebar-section">
          <h3>User Info</h3>
          <div className="user-info-card">
            <p><strong>{user?.username || 'User'}</strong></p>
            <p className="user-email">{user?.email}</p>
            <button className="logout-btn" onClick={logout}>
              Logout
            </button>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="main-content">
        <header className="top-bar">
          <button className="menu-toggle" onClick={() => setIsSidebarOpen(!isSidebarOpen)}>
            ☰
          </button>
          <form className="search-bar" onSubmit={handleSearch}>
            <span className="search-icon">🔍</span>
            <input 
              type="text" 
              placeholder="Search songs, artists, albums..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <button type="submit" className="search-btn">Search</button>
          </form>
        </header>

        <div className="content-area">
          {/* Hero Section */}
          <section className="hero-section">
            <div className="hero-content">
              <h2>Welcome back, {user?.username}!</h2>
              <p>Discover your next favorite track</p>
            </div>
          </section>

          {/* Error Message */}
          {error && (
            <div className="error-banner">
              <p>{error}</p>
              <button onClick={() => setError('')}>✕</button>
            </div>
          )}

          {/* Songs Section */}
          <section className="songs-section">
            <h2>
              {activeTab === 'liked' ? 'Liked Songs' : 
               activeTab === 'library' ? 'Your Library' : 
               'Discover Music'}
            </h2>
            
            {loading ? (
              <div className="loading">Loading songs...</div>
            ) : (
              <div className="songs-grid">
                {songs
                  .filter(song => activeTab !== 'liked' || likedSongs.has(song.songId))
                  .map((song) => (
                  <div key={song.songId} className="song-card">
                    <div className="song-cover">
                      <span className="cover-icon">🎵</span>
                      <button 
                        className="play-btn"
                        onClick={() => handlePlaySong(song)}
                      >
                        {currentSong?.songId === song.songId && isPlaying ? '⏸️' : '▶️'}
                      </button>
                    </div>
                    <div className="song-info">
                      <h3>{song.songTitle}</h3>
                      <p className="artist">Artist ID: {song.artistId}</p>
                      <p className="duration">{formatDuration(song.durationSeconds)}</p>
                      <button 
                        className={`like-btn ${likedSongs.has(song.songId) ? 'liked' : ''}`}
                        onClick={() => handleLikeSong(song.songId)}
                      >
                        {likedSongs.has(song.songId) ? '❤️' : '🤍'}
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {!loading && songs.length === 0 && (
              <div className="empty-state">
                <p>No songs found</p>
                <button onClick={loadSongs}>Refresh</button>
              </div>
            )}
          </section>
        </div>

        {/* Player Bar */}
        {currentSong && (
          <div className="player-bar">
            <div className="player-info">
              <span className="player-icon">🎵</span>
              <div>
                <p className="player-title">{currentSong.songTitle}</p>
                <p className="player-artist">Artist ID: {currentSong.artistId}</p>
              </div>
            </div>
            <div className="player-controls">
              <button>⏮️</button>
              <button 
                className="play-pause"
                onClick={() => setIsPlaying(!isPlaying)}
              >
                {isPlaying ? '⏸️' : '▶️'}
              </button>
              <button>⏭️</button>
            </div>
            <div className="player-volume">
              <span>🔊</span>
              <input type="range" min="0" max="100" defaultValue="70" />
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
