-- ============================================================================
-- Music Streaming Platform Database Schema
-- ============================================================================

-- Users and Authentication
-- ============================================================================

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say'),
    profile_picture_url VARCHAR(500),
    subscription_type ENUM('Free', 'Premium', 'Family', 'Student') DEFAULT 'Free',
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_subscription_type (subscription_type)
);

CREATE TABLE user_profiles (
    profile_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    bio TEXT,
    country VARCHAR(100),
    city VARCHAR(100),
    language VARCHAR(50) DEFAULT 'en',
    timezone VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE subscriptions (
    subscription_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    plan_type ENUM('Free', 'Premium', 'Family', 'Student') NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    auto_renew BOOLEAN DEFAULT TRUE,
    payment_method VARCHAR(50),
    amount DECIMAL(10, 2),
    status ENUM('Active', 'Expired', 'Cancelled', 'Paused') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_status (user_id, status)
);

-- Artists and Albums
-- ============================================================================

CREATE TABLE artists (
    artist_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    artist_name VARCHAR(200) NOT NULL,
    bio TEXT,
    profile_image_url VARCHAR(500),
    banner_image_url VARCHAR(500),
    country VARCHAR(100),
    genres VARCHAR(200), -- Comma-separated genre list
    verified BOOLEAN DEFAULT FALSE,
    monthly_listeners BIGINT DEFAULT 0,
    total_followers BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_artist_name (artist_name),
    INDEX idx_monthly_listeners (monthly_listeners DESC)
);

CREATE TABLE albums (
    album_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    album_title VARCHAR(200) NOT NULL,
    artist_id BIGINT NOT NULL,
    album_type ENUM('Single', 'EP', 'Album', 'Compilation') DEFAULT 'Album',
    release_date DATE,
    cover_image_url VARCHAR(500),
    total_tracks INT DEFAULT 0,
    total_duration_seconds INT DEFAULT 0,
    label VARCHAR(200),
    genre VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    INDEX idx_artist_id (artist_id),
    INDEX idx_release_date (release_date DESC),
    INDEX idx_album_type (album_type)
);

-- Songs and Audio
-- ============================================================================

CREATE TABLE songs (
    song_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    song_title VARCHAR(200) NOT NULL,
    album_id BIGINT,
    artist_id BIGINT NOT NULL,
    duration_seconds INT NOT NULL,
    audio_file_url VARCHAR(500) NOT NULL,
    audio_quality ENUM('Low', 'Medium', 'High', 'Lossless') DEFAULT 'High',
    track_number INT,
    disc_number INT DEFAULT 1,
    release_date DATE,
    lyrics TEXT,
    language VARCHAR(50),
    explicit_content BOOLEAN DEFAULT FALSE,
    is_premium_only BOOLEAN DEFAULT FALSE,
    play_count BIGINT DEFAULT 0,
    like_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE SET NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    INDEX idx_song_title (song_title),
    INDEX idx_artist_id (artist_id),
    INDEX idx_album_id (album_id),
    INDEX idx_play_count (play_count DESC),
    INDEX idx_release_date (release_date DESC)
);

CREATE TABLE song_artists (
    song_artist_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    song_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    artist_role ENUM('Primary', 'Featured', 'Composer', 'Producer') DEFAULT 'Primary',
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    UNIQUE KEY unique_song_artist_role (song_id, artist_id, artist_role),
    INDEX idx_song_id (song_id),
    INDEX idx_artist_id (artist_id)
);

CREATE TABLE genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(100) UNIQUE NOT NULL,
    parent_genre_id INT,
    description TEXT,
    FOREIGN KEY (parent_genre_id) REFERENCES genres(genre_id) ON DELETE SET NULL,
    INDEX idx_genre_name (genre_name)
);

CREATE TABLE song_genres (
    song_genre_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    song_id BIGINT NOT NULL,
    genre_id INT NOT NULL,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE,
    UNIQUE KEY unique_song_genre (song_id, genre_id),
    INDEX idx_song_id (song_id),
    INDEX idx_genre_id (genre_id)
);

-- Playlists
-- ============================================================================

CREATE TABLE playlists (
    playlist_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    playlist_name VARCHAR(200) NOT NULL,
    description TEXT,
    cover_image_url VARCHAR(500),
    is_public BOOLEAN DEFAULT TRUE,
    is_collaborative BOOLEAN DEFAULT FALSE,
    total_songs INT DEFAULT 0,
    total_duration_seconds INT DEFAULT 0,
    play_count BIGINT DEFAULT 0,
    follower_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_public (is_public),
    INDEX idx_created_at (created_at DESC)
);

CREATE TABLE playlist_songs (
    playlist_song_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    playlist_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    added_by_user_id BIGINT NOT NULL,
    position INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (added_by_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_playlist_song (playlist_id, song_id),
    INDEX idx_playlist_id (playlist_id),
    INDEX idx_song_id (song_id),
    INDEX idx_position (playlist_id, position)
);

-- User Activity and Engagement
-- ============================================================================

CREATE TABLE listening_history (
    history_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_played_seconds INT NOT NULL,
    completion_percentage DECIMAL(5, 2),
    device_type VARCHAR(50),
    platform VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    INDEX idx_user_played_at (user_id, played_at DESC),
    INDEX idx_song_id (song_id),
    INDEX idx_played_at (played_at DESC)
);

CREATE TABLE user_likes (
    like_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    entity_type ENUM('Song', 'Album', 'Playlist', 'Artist') NOT NULL,
    entity_id BIGINT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_like (user_id, entity_type, entity_id),
    INDEX idx_user_id (user_id),
    INDEX idx_entity (entity_type, entity_id)
);

CREATE TABLE user_follows (
    follow_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    follower_user_id BIGINT NOT NULL,
    entity_type ENUM('Artist', 'Playlist', 'User') NOT NULL,
    entity_id BIGINT NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_follow (follower_user_id, entity_type, entity_id),
    INDEX idx_follower (follower_user_id),
    INDEX idx_entity (entity_type, entity_id)
);

CREATE TABLE user_downloads (
    download_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quality ENUM('Low', 'Medium', 'High', 'Lossless') DEFAULT 'High',
    device_id VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_song_id (song_id),
    INDEX idx_downloaded_at (downloaded_at DESC)
);

-- Search and Discovery
-- ============================================================================

CREATE TABLE search_history (
    search_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    search_query VARCHAR(500) NOT NULL,
    result_type ENUM('Song', 'Album', 'Artist', 'Playlist', 'User'),
    result_id BIGINT,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_searched_at (user_id, searched_at DESC),
    INDEX idx_search_query (search_query)
);

CREATE TABLE recommendations (
    recommendation_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    recommendation_source ENUM('Collaborative', 'Content-Based', 'Trending', 'Editorial') NOT NULL,
    relevance_score DECIMAL(5, 2),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    was_played BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    INDEX idx_user_generated (user_id, generated_at DESC),
    INDEX idx_song_id (song_id)
);

-- Social Features
-- ============================================================================

CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    entity_type ENUM('Song', 'Album', 'Playlist') NOT NULL,
    entity_id BIGINT NOT NULL,
    comment_text TEXT NOT NULL,
    parent_comment_id BIGINT,
    like_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at DESC)
);

CREATE TABLE user_notifications (
    notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    notification_type ENUM('New Release', 'Playlist Update', 'Social', 'Subscription', 'System') NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_created (user_id, created_at DESC),
    INDEX idx_user_read (user_id, is_read)
);

-- Analytics and Reporting
-- ============================================================================

CREATE TABLE daily_song_stats (
    stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    song_id BIGINT NOT NULL,
    stat_date DATE NOT NULL,
    play_count INT DEFAULT 0,
    unique_listeners INT DEFAULT 0,
    skip_count INT DEFAULT 0,
    completion_rate DECIMAL(5, 2),
    avg_completion_percentage DECIMAL(5, 2),
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    UNIQUE KEY unique_song_date (song_id, stat_date),
    INDEX idx_song_date (song_id, stat_date DESC),
    INDEX idx_stat_date (stat_date DESC)
);

CREATE TABLE daily_artist_stats (
    stat_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    artist_id BIGINT NOT NULL,
    stat_date DATE NOT NULL,
    total_plays INT DEFAULT 0,
    unique_listeners INT DEFAULT 0,
    new_followers INT DEFAULT 0,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    UNIQUE KEY unique_artist_date (artist_id, stat_date),
    INDEX idx_artist_date (artist_id, stat_date DESC),
    INDEX idx_stat_date (stat_date DESC)
);

-- Queue Management
-- ============================================================================

CREATE TABLE user_queue (
    queue_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    position INT NOT NULL,
    is_current BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    INDEX idx_user_position (user_id, position),
    INDEX idx_user_current (user_id, is_current)
);

-- Payment and Transactions
-- ============================================================================

CREATE TABLE payment_transactions (
    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    subscription_id BIGINT,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(50) NOT NULL,
    transaction_type ENUM('Subscription', 'Upgrade', 'Refund') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_transaction_date (transaction_date DESC),
    INDEX idx_status (status)
);

-- ============================================================================
-- Sample Indexes for Performance Optimization
-- ============================================================================

-- Additional composite indexes for common queries
CREATE INDEX idx_songs_artist_album ON songs(artist_id, album_id);
CREATE INDEX idx_listening_history_user_song ON listening_history(user_id, song_id);
CREATE INDEX idx_playlists_user_public ON playlists(user_id, is_public);

-- Full-text search indexes (if supported by the database)
-- ALTER TABLE songs ADD FULLTEXT INDEX ft_song_title (song_title);
-- ALTER TABLE artists ADD FULLTEXT INDEX ft_artist_name (artist_name);
-- ALTER TABLE albums ADD FULLTEXT INDEX ft_album_title (album_title);
