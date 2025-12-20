-- ============================================================================
-- Music Streaming Platform Database Schema - PostgreSQL Version
-- ============================================================================

-- Drop existing tables if any (for fresh setup)
-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;

-- Helper function for updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Users and Authentication
-- ============================================================================

CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_subscription_type ON users(subscription_type);

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE user_profiles (
    profile_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    bio TEXT,
    country VARCHAR(100),
    city VARCHAR(100),
    language VARCHAR(50) DEFAULT 'en',
    timezone VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE subscriptions (
    subscription_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('Free', 'Premium', 'Family', 'Student')),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    auto_renew BOOLEAN DEFAULT TRUE,
    payment_method VARCHAR(50),
    amount DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Expired', 'Cancelled', 'Paused')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_status ON subscriptions(user_id, status);

-- Artists and Albums
-- ============================================================================

CREATE TABLE artists (
    artist_id BIGSERIAL PRIMARY KEY,
    artist_name VARCHAR(200) NOT NULL,
    bio TEXT,
    profile_image_url VARCHAR(500),
    banner_image_url VARCHAR(500),
    country VARCHAR(100),
    genres VARCHAR(200),
    verified BOOLEAN DEFAULT FALSE,
    monthly_listeners BIGINT DEFAULT 0,
    total_followers BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_artist_name ON artists(artist_name);
CREATE INDEX idx_monthly_listeners ON artists(monthly_listeners DESC);

CREATE TRIGGER update_artists_updated_at BEFORE UPDATE ON artists
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE albums (
    album_id BIGSERIAL PRIMARY KEY,
    album_title VARCHAR(200) NOT NULL,
    artist_id BIGINT NOT NULL,
    album_type VARCHAR(20) DEFAULT 'Album' CHECK (album_type IN ('Single', 'EP', 'Album', 'Compilation')),
    release_date DATE,
    cover_image_url VARCHAR(500),
    total_tracks INT DEFAULT 0,
    total_duration_seconds INT DEFAULT 0,
    label VARCHAR(200),
    genre VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

CREATE INDEX idx_artist_id_albums ON albums(artist_id);
CREATE INDEX idx_release_date_albums ON albums(release_date DESC);
CREATE INDEX idx_album_type ON albums(album_type);

CREATE TRIGGER update_albums_updated_at BEFORE UPDATE ON albums
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Songs and Audio
-- ============================================================================

CREATE TABLE songs (
    song_id BIGSERIAL PRIMARY KEY,
    song_title VARCHAR(200) NOT NULL,
    album_id BIGINT,
    artist_id BIGINT NOT NULL,
    duration_seconds INT NOT NULL,
    audio_file_url VARCHAR(500) NOT NULL,
    audio_quality VARCHAR(20) DEFAULT 'High' CHECK (audio_quality IN ('Low', 'Medium', 'High', 'Lossless')),
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE SET NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

CREATE INDEX idx_song_title ON songs(song_title);
CREATE INDEX idx_artist_id_songs ON songs(artist_id);
CREATE INDEX idx_album_id_songs ON songs(album_id);
CREATE INDEX idx_play_count ON songs(play_count DESC);
CREATE INDEX idx_release_date_songs ON songs(release_date DESC);
CREATE INDEX idx_songs_artist_album ON songs(artist_id, album_id);

CREATE TRIGGER update_songs_updated_at BEFORE UPDATE ON songs
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE song_artists (
    song_artist_id BIGSERIAL PRIMARY KEY,
    song_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    artist_role VARCHAR(20) DEFAULT 'Primary' CHECK (artist_role IN ('Primary', 'Featured', 'Composer', 'Producer')),
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    UNIQUE (song_id, artist_id, artist_role)
);

CREATE INDEX idx_song_id_sa ON song_artists(song_id);
CREATE INDEX idx_artist_id_sa ON song_artists(artist_id);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL,
    parent_genre_id INT,
    description TEXT,
    FOREIGN KEY (parent_genre_id) REFERENCES genres(genre_id) ON DELETE SET NULL
);

CREATE INDEX idx_genre_name ON genres(genre_name);

CREATE TABLE song_genres (
    song_genre_id BIGSERIAL PRIMARY KEY,
    song_id BIGINT NOT NULL,
    genre_id INT NOT NULL,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE,
    UNIQUE (song_id, genre_id)
);

CREATE INDEX idx_song_id_sg ON song_genres(song_id);
CREATE INDEX idx_genre_id_sg ON song_genres(genre_id);

-- Playlists
-- ============================================================================

CREATE TABLE playlists (
    playlist_id BIGSERIAL PRIMARY KEY,
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_id_playlists ON playlists(user_id);
CREATE INDEX idx_is_public ON playlists(is_public);
CREATE INDEX idx_created_at_playlists ON playlists(created_at DESC);
CREATE INDEX idx_playlists_user_public ON playlists(user_id, is_public);

CREATE TRIGGER update_playlists_updated_at BEFORE UPDATE ON playlists
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE playlist_songs (
    playlist_song_id BIGSERIAL PRIMARY KEY,
    playlist_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    added_by_user_id BIGINT NOT NULL,
    position INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    FOREIGN KEY (added_by_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (playlist_id, song_id)
);

CREATE INDEX idx_playlist_id_ps ON playlist_songs(playlist_id);
CREATE INDEX idx_song_id_ps ON playlist_songs(song_id);
CREATE INDEX idx_position ON playlist_songs(playlist_id, position);

-- User Activity and Engagement
-- ============================================================================

CREATE TABLE listening_history (
    history_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_played_seconds INT NOT NULL,
    completion_percentage DECIMAL(5, 2),
    device_type VARCHAR(50),
    platform VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_played_at ON listening_history(user_id, played_at DESC);
CREATE INDEX idx_song_id_lh ON listening_history(song_id);
CREATE INDEX idx_played_at ON listening_history(played_at DESC);
CREATE INDEX idx_listening_history_user_song ON listening_history(user_id, song_id);

CREATE TABLE user_likes (
    like_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('Song', 'Album', 'Playlist', 'Artist')),
    entity_id BIGINT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (user_id, entity_type, entity_id)
);

CREATE INDEX idx_user_id_ul ON user_likes(user_id);
CREATE INDEX idx_entity ON user_likes(entity_type, entity_id);

CREATE TABLE user_follows (
    follow_id BIGSERIAL PRIMARY KEY,
    follower_user_id BIGINT NOT NULL,
    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('Artist', 'Playlist', 'User')),
    entity_id BIGINT NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE (follower_user_id, entity_type, entity_id)
);

CREATE INDEX idx_follower ON user_follows(follower_user_id);
CREATE INDEX idx_entity_uf ON user_follows(entity_type, entity_id);

CREATE TABLE user_downloads (
    download_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quality VARCHAR(20) DEFAULT 'High' CHECK (quality IN ('Low', 'Medium', 'High', 'Lossless')),
    device_id VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_id_ud ON user_downloads(user_id);
CREATE INDEX idx_song_id_ud ON user_downloads(song_id);
CREATE INDEX idx_downloaded_at ON user_downloads(downloaded_at DESC);

-- Search and Discovery
-- ============================================================================

CREATE TABLE search_history (
    search_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    search_query VARCHAR(500) NOT NULL,
    result_type VARCHAR(20) CHECK (result_type IN ('Song', 'Album', 'Artist', 'Playlist', 'User')),
    result_id BIGINT,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_searched_at ON search_history(user_id, searched_at DESC);
CREATE INDEX idx_search_query ON search_history(search_query);

CREATE TABLE recommendations (
    recommendation_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    recommendation_source VARCHAR(20) NOT NULL CHECK (recommendation_source IN ('Collaborative', 'Content-Based', 'Trending', 'Editorial')),
    relevance_score DECIMAL(5, 2),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    was_played BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_generated ON recommendations(user_id, generated_at DESC);
CREATE INDEX idx_song_id_rec ON recommendations(song_id);

-- Social Features
-- ============================================================================

CREATE TABLE comments (
    comment_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('Song', 'Album', 'Playlist')),
    entity_id BIGINT NOT NULL,
    comment_text TEXT NOT NULL,
    parent_comment_id BIGINT,
    like_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE
);

CREATE INDEX idx_entity_comments ON comments(entity_type, entity_id);
CREATE INDEX idx_user_id_comments ON comments(user_id);
CREATE INDEX idx_created_at_comments ON comments(created_at DESC);

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE user_notifications (
    notification_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    notification_type VARCHAR(20) NOT NULL CHECK (notification_type IN ('New Release', 'Playlist Update', 'Social', 'Subscription', 'System')),
    title VARCHAR(200) NOT NULL,
    message TEXT,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_created ON user_notifications(user_id, created_at DESC);
CREATE INDEX idx_user_read ON user_notifications(user_id, is_read);

-- Analytics and Reporting
-- ============================================================================

CREATE TABLE daily_song_stats (
    stat_id BIGSERIAL PRIMARY KEY,
    song_id BIGINT NOT NULL,
    stat_date DATE NOT NULL,
    play_count INT DEFAULT 0,
    unique_listeners INT DEFAULT 0,
    skip_count INT DEFAULT 0,
    completion_rate DECIMAL(5, 2),
    avg_completion_percentage DECIMAL(5, 2),
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
    UNIQUE (song_id, stat_date)
);

CREATE INDEX idx_song_date ON daily_song_stats(song_id, stat_date DESC);
CREATE INDEX idx_stat_date_dss ON daily_song_stats(stat_date DESC);

CREATE TABLE daily_artist_stats (
    stat_id BIGSERIAL PRIMARY KEY,
    artist_id BIGINT NOT NULL,
    stat_date DATE NOT NULL,
    total_plays INT DEFAULT 0,
    unique_listeners INT DEFAULT 0,
    new_followers INT DEFAULT 0,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    UNIQUE (artist_id, stat_date)
);

CREATE INDEX idx_artist_date ON daily_artist_stats(artist_id, stat_date DESC);
CREATE INDEX idx_stat_date_das ON daily_artist_stats(stat_date DESC);

-- Queue Management
-- ============================================================================

CREATE TABLE user_queue (
    queue_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    song_id BIGINT NOT NULL,
    position INT NOT NULL,
    is_current BOOLEAN DEFAULT FALSE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);

CREATE INDEX idx_user_position ON user_queue(user_id, position);
CREATE INDEX idx_user_current ON user_queue(user_id, is_current);

-- Payment and Transactions
-- ============================================================================

CREATE TABLE payment_transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    subscription_id BIGINT,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(50) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Subscription', 'Upgrade', 'Refund')),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE SET NULL
);

CREATE INDEX idx_user_id_pt ON payment_transactions(user_id);
CREATE INDEX idx_transaction_date ON payment_transactions(transaction_date DESC);
CREATE INDEX idx_status_pt ON payment_transactions(status);

-- Full-Text Search Setup
-- ============================================================================

-- Add tsvector columns for full-text search
ALTER TABLE songs ADD COLUMN search_vector tsvector;
ALTER TABLE artists ADD COLUMN search_vector tsvector;
ALTER TABLE albums ADD COLUMN search_vector tsvector;

-- Create indexes for full-text search
CREATE INDEX songs_search_idx ON songs USING GIN(search_vector);
CREATE INDEX artists_search_idx ON artists USING GIN(search_vector);
CREATE INDEX albums_search_idx ON albums USING GIN(search_vector);

-- Create triggers to automatically update search vectors
CREATE OR REPLACE FUNCTION songs_search_trigger() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.song_title, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER songs_search_update BEFORE INSERT OR UPDATE ON songs
FOR EACH ROW EXECUTE FUNCTION songs_search_trigger();

CREATE OR REPLACE FUNCTION artists_search_trigger() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.artist_name, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER artists_search_update BEFORE INSERT OR UPDATE ON artists
FOR EACH ROW EXECUTE FUNCTION artists_search_trigger();

CREATE OR REPLACE FUNCTION albums_search_trigger() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.album_title, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER albums_search_update BEFORE INSERT OR UPDATE ON albums
FOR EACH ROW EXECUTE FUNCTION albums_search_trigger();
