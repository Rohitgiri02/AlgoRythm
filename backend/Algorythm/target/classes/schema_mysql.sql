-- ============================================================================
-- Music Streaming Platform Database Schema - MySQL Version
-- ============================================================================

-- Users and Authentication
-- ============================================================================

CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(50) CHECK (gender IN ('Male', 'Female', 'Other', 'Prefer not to say')),
    profile_picture_url VARCHAR(500),
    subscription_type VARCHAR(20) DEFAULT 'Free' CHECK (subscription_type IN ('Free', 'Premium', 'Family', 'Student')),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_subscription_type ON users(subscription_type);

CREATE TABLE user_profiles (
    profile_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    bio TEXT,
    country VARCHAR(100),
    city VARCHAR(100),
    favorite_genres TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Artists
-- ============================================================================

CREATE TABLE artists (
    artist_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(200) NOT NULL,
    bio TEXT,
    profile_image_url VARCHAR(500),
    country VARCHAR(100),
    verified BOOLEAN DEFAULT FALSE,
    monthly_listeners BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_artist_name ON artists(artist_name);
CREATE INDEX idx_verified ON artists(verified);

-- Albums
-- ============================================================================

CREATE TABLE albums (
    album_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    album_title VARCHAR(200) NOT NULL,
    artist_id BIGINT NOT NULL,
    release_date DATE,
    album_type VARCHAR(50) CHECK (album_type IN ('Album', 'Single', 'EP', 'Compilation')),
    cover_image_url VARCHAR(500),
    total_tracks INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_album_title ON albums(album_title);
CREATE INDEX idx_artist_id ON albums(artist_id);

-- Songs
-- ============================================================================

CREATE TABLE songs (
    song_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    song_title VARCHAR(200) NOT NULL,
    artist_id BIGINT NOT NULL,
    album_id BIGINT,
    duration_seconds INT NOT NULL,
    release_date DATE,
    genre VARCHAR(100),
    audio_file_url VARCHAR(500) NOT NULL,
    cover_image_url VARCHAR(500),
    play_count BIGINT DEFAULT 0,
    like_count BIGINT DEFAULT 0,
    is_explicit BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_song_title ON songs(song_title);
CREATE INDEX idx_artist_id_songs ON songs(artist_id);
CREATE INDEX idx_album_id ON songs(album_id);
CREATE INDEX idx_genre ON songs(genre);
CREATE FULLTEXT INDEX idx_song_fulltext ON songs(song_title);

-- Playlists
-- ============================================================================

CREATE TABLE playlists (
    playlist_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    playlist_name VARCHAR(200) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    cover_image_url VARCHAR(500),
    follower_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_user_id_playlists ON playlists(user_id);
CREATE INDEX idx_is_public ON playlists(is_public);

CREATE TABLE playlist_songs (
    playlist_song_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    playlist_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    position INT,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    UNIQUE KEY unique_playlist_song (playlist_id, song_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_playlist_id ON playlist_songs(playlist_id);
CREATE INDEX idx_song_id_playlist ON playlist_songs(song_id);

-- User Activity
-- ============================================================================

CREATE TABLE listening_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_played INT,
    completion_percentage INT CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_user_id_history ON listening_history(user_id);
CREATE INDEX idx_song_id_history ON listening_history(song_id);
CREATE INDEX idx_played_at ON listening_history(played_at);

CREATE TABLE user_likes (
    like_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_song (user_id, song_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_user_id_likes ON user_likes(user_id);
CREATE INDEX idx_song_id_likes ON user_likes(song_id);

CREATE TABLE user_follows_artist (
    follow_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_artist (user_id, artist_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_follows_playlist (
    follow_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    playlist_id BIGINT NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_playlist (user_id, playlist_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
