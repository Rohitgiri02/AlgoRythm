import { useState } from 'react'
import './App.css'

function App() {
  const [isPlaying, setIsPlaying] = useState(false)
  const [currentSong, setCurrentSong] = useState(0)
  const [volume, setVolume] = useState(70)
  const [isSidebarOpen, setIsSidebarOpen] = useState(true)
  const [activeTab, setActiveTab] = useState('discover')

  // Mock data for songs
  const songs = [
    { id: 1, title: "Midnight Dreams", artist: "Luna Wave", album: "Echoes", duration: "3:45", cover: "🎵" },
    { id: 2, title: "Electric Pulse", artist: "Neon Knights", album: "Synth Wave", duration: "4:12", cover: "🎸" },
    { id: 3, title: "Ocean Breeze", artist: "Aqua Soul", album: "Tides", duration: "3:28", cover: "🌊" },
    { id: 4, title: "Urban Lights", artist: "City Dreams", album: "Metropolis", duration: "3:56", cover: "🌃" },
    { id: 5, title: "Cosmic Journey", artist: "Star Gazers", album: "Universe", duration: "5:23", cover: "✨" },
  ]

  const aiPlaylists = [
    { name: "Your Daily Mix", description: "AI-curated based on your taste", songs: 25 },
    { name: "Chill Vibes", description: "Relaxing tracks for focus", songs: 30 },
    { name: "Workout Energy", description: "High-energy beats", songs: 40 },
    { name: "Discover Weekly", description: "New music you'll love", songs: 50 },
  ]

  const recentlyPlayed = [
    { title: "Summer Nights", artist: "Sunset Band", cover: "🎹" },
    { title: "Jazz Café", artist: "Smooth Trio", cover: "🎷" },
    { title: "Rock Legends", artist: "Thunder Riff", cover: "🎸" },
    { title: "Classical Dawn", artist: "Symphony Orchestra", cover: "🎻" },
  ]

  return (
    <div className="app">
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
          <button className={activeTab === 'discover' ? 'active' : ''} onClick={() => setActiveTab('discover')}>
            <span className="icon">🔍</span> Discover
          </button>
          <button className={activeTab === 'library' ? 'active' : ''} onClick={() => setActiveTab('library')}>
            <span className="icon">📚</span> Library
          </button>
          <button className={activeTab === 'playlists' ? 'active' : ''} onClick={() => setActiveTab('playlists')}>
            <span className="icon">🎼</span> Playlists
          </button>
          <button className={activeTab === 'ai' ? 'active' : ''} onClick={() => setActiveTab('ai')}>
            <span className="icon">🤖</span> AI Radio
          </button>
        </nav>

        <div className="sidebar-section">
          <h3>AI Playlists</h3>
          {aiPlaylists.map((playlist, index) => (
            <div key={index} className="playlist-item">
              <span className="playlist-icon">🎵</span>
              <div className="playlist-info">
                <p className="playlist-name">{playlist.name}</p>
                <p className="playlist-desc">{playlist.description}</p>
              </div>
            </div>
          ))}
        </div>
      </aside>

      {/* Main Content */}
      <main className="main-content">
        <header className="top-bar">
          <button className="menu-toggle" onClick={() => setIsSidebarOpen(!isSidebarOpen)}>
            ☰
          </button>
          <div className="search-bar">
            <span className="search-icon">🔍</span>
            <input type="text" placeholder="Search songs, artists, albums..." />
          </div>
          <div className="user-section">
            <button className="notification-btn">🔔</button>
            <div className="user-avatar">👤</div>
          </div>
        </header>

        <div className="content-area">
          {/* Hero Section */}
          <section className="hero-section">
            <div className="hero-content">
              <h2>Your AI-Powered Music Experience</h2>
              <p>Discover new music tailored to your taste with advanced AI algorithms</p>
              <button className="cta-button">Generate AI Mix</button>
            </div>
          </section>

          {/* Recently Played */}
          <section className="section">
            <h2>Recently Played</h2>
            <div className="horizontal-scroll">
              {recentlyPlayed.map((item, index) => (
                <div key={index} className="card">
                  <div className="card-cover">{item.cover}</div>
                  <h4>{item.title}</h4>
                  <p>{item.artist}</p>
                </div>
              ))}
            </div>
          </section>

          {/* Queue / Current Playlist */}
          <section className="section">
            <h2>Now Playing Queue</h2>
            <div className="song-list">
              {songs.map((song, index) => (
                <div 
                  key={song.id} 
                  className={`song-item ${index === currentSong ? 'active' : ''}`}
                  onClick={() => setCurrentSong(index)}
                >
                  <div className="song-number">{index + 1}</div>
                  <div className="song-cover">{song.cover}</div>
                  <div className="song-info">
                    <p className="song-title">{song.title}</p>
                    <p className="song-artist">{song.artist}</p>
                  </div>
                  <div className="song-album">{song.album}</div>
                  <div className="song-duration">{song.duration}</div>
                  <button className="song-action">⋮</button>
                </div>
              ))}
            </div>
          </section>
        </div>
      </main>

      {/* Music Player */}
      <div className="music-player">
        <div className="player-left">
          <div className="current-song-cover">{songs[currentSong].cover}</div>
          <div className="current-song-info">
            <p className="current-title">{songs[currentSong].title}</p>
            <p className="current-artist">{songs[currentSong].artist}</p>
          </div>
          <button className="favorite-btn">♡</button>
        </div>

        <div className="player-center">
          <div className="player-controls">
            <button className="control-btn">🔀</button>
            <button className="control-btn">⏮</button>
            <button 
              className="play-btn"
              onClick={() => setIsPlaying(!isPlaying)}
            >
              {isPlaying ? '⏸' : '▶'}
            </button>
            <button className="control-btn">⏭</button>
            <button className="control-btn">🔁</button>
          </div>
          <div className="progress-bar">
            <span className="time">1:23</span>
            <div className="progress-track">
              <div className="progress-fill" style={{ width: '35%' }}></div>
              <div className="progress-handle"></div>
            </div>
            <span className="time">{songs[currentSong].duration}</span>
          </div>
        </div>

        <div className="player-right">
          <button className="control-btn">🎤</button>
          <button className="control-btn">📃</button>
          <button className="control-btn">🔊</button>
          <div className="volume-bar">
            <input 
              type="range" 
              min="0" 
              max="100" 
              value={volume}
              onChange={(e) => setVolume(e.target.value)}
              className="volume-slider"
            />
          </div>
        </div>
      </div>
    </div>
  )
}

export default App
