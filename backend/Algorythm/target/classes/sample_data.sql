-- ============================================================================
-- Sample Data for AlgoRythm Music Streaming Platform
-- ============================================================================

-- Insert Artists
INSERT INTO artists (artist_name, bio, country, verified, monthly_listeners) VALUES 
('The Midnight Riders', 'Rock band known for electrifying performances', 'United States', true, 1500000),
('Luna Echo', 'Indie pop artist with dreamy melodies', 'United Kingdom', true, 2300000),
('DJ Pulse', 'Electronic music producer and DJ', 'Germany', true, 3500000),
('Acoustic Soul', 'Singer-songwriter with heartfelt lyrics', 'Canada', true, 890000),
('Rhythm Kings', 'Jazz fusion ensemble', 'France', true, 650000);

-- Insert Albums
INSERT INTO albums (album_title, artist_id, release_date, album_type, total_tracks) VALUES 
('Night Drive', 1, '2023-06-15', 'Album', 12),
('Echoes in the Dark', 2, '2024-01-20', 'Album', 10),
('Pulse Waves', 3, '2023-11-10', 'EP', 6),
('Unplugged Sessions', 4, '2024-03-05', 'Album', 14),
('Jazz Fusion Vol. 1', 5, '2023-09-25', 'Album', 11);

-- Insert Songs
INSERT INTO songs (song_title, artist_id, album_id, duration_seconds, release_date, genre, audio_file_url, play_count, like_count, is_explicit) VALUES 
-- The Midnight Riders songs
('Highway Dreams', 1, 1, 245, '2023-06-15', 'Rock', 'https://example.com/audio/highway-dreams.mp3', 125000, 8500, false),
('Thunder Road', 1, 1, 198, '2023-06-15', 'Rock', 'https://example.com/audio/thunder-road.mp3', 89000, 6200, false),
('Neon Lights', 1, 1, 223, '2023-06-15', 'Rock', 'https://example.com/audio/neon-lights.mp3', 156000, 12300, false),
('Rebel Heart', 1, 1, 267, '2023-06-15', 'Rock', 'https://example.com/audio/rebel-heart.mp3', 98000, 7100, true),

-- Luna Echo songs
('Starlight', 2, 2, 189, '2024-01-20', 'Indie Pop', 'https://example.com/audio/starlight.mp3', 234000, 18900, false),
('Midnight Whispers', 2, 2, 201, '2024-01-20', 'Indie Pop', 'https://example.com/audio/midnight-whispers.mp3', 178000, 14200, false),
('Crystal Dreams', 2, 2, 178, '2024-01-20', 'Dream Pop', 'https://example.com/audio/crystal-dreams.mp3', 156000, 11800, false),
('Ocean Eyes', 2, 2, 195, '2024-01-20', 'Indie Pop', 'https://example.com/audio/ocean-eyes.mp3', 289000, 23400, false),

-- DJ Pulse songs
('Electric Storm', 3, 3, 312, '2023-11-10', 'Electronic', 'https://example.com/audio/electric-storm.mp3', 456000, 34500, false),
('Bass Drop', 3, 3, 278, '2023-11-10', 'EDM', 'https://example.com/audio/bass-drop.mp3', 389000, 29800, false),
('Neon Pulse', 3, 3, 295, '2023-11-10', 'House', 'https://example.com/audio/neon-pulse.mp3', 412000, 31200, false),
('Rhythm Machine', 3, 3, 301, '2023-11-10', 'Techno', 'https://example.com/audio/rhythm-machine.mp3', 367000, 27400, false),

-- Acoustic Soul songs
('Quiet Moments', 4, 4, 234, '2024-03-05', 'Acoustic', 'https://example.com/audio/quiet-moments.mp3', 123000, 9800, false),
('Morning Coffee', 4, 4, 187, '2024-03-05', 'Folk', 'https://example.com/audio/morning-coffee.mp3', 167000, 13400, false),
('Sunset Boulevard', 4, 4, 256, '2024-03-05', 'Singer-Songwriter', 'https://example.com/audio/sunset-boulevard.mp3', 145000, 11200, false),
('Rainy Day', 4, 4, 198, '2024-03-05', 'Acoustic', 'https://example.com/audio/rainy-day.mp3', 189000, 15600, false),

-- Rhythm Kings songs
('Smooth Jazz', 5, 5, 267, '2023-09-25', 'Jazz', 'https://example.com/audio/smooth-jazz.mp3', 78000, 5400, false),
('Blue Notes', 5, 5, 289, '2023-09-25', 'Jazz Fusion', 'https://example.com/audio/blue-notes.mp3', 92000, 6700, false),
('Midnight Jam', 5, 5, 312, '2023-09-25', 'Jazz', 'https://example.com/audio/midnight-jam.mp3', 67000, 4800, false),
('Fusion Flow', 5, 5, 278, '2023-09-25', 'Jazz Fusion', 'https://example.com/audio/fusion-flow.mp3', 81000, 5900, false);

-- Insert sample users
INSERT INTO users (username, email, password_hash, full_name, date_of_birth, gender, subscription_type, is_verified) VALUES 
('john_doe', 'john@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'John Doe', '1995-05-15', 'Male', 'Premium', true),
('jane_smith', 'jane@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Jane Smith', '1998-08-22', 'Female', 'Free', true),
('music_lover', 'music@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Music Lover', '1992-11-30', 'Other', 'Family', true);

-- Insert sample playlists
INSERT INTO playlists (user_id, playlist_name, description, is_public, follower_count) VALUES 
(1, 'My Favorites', 'Songs I love to listen to', true, 45),
(1, 'Workout Mix', 'High energy songs for the gym', true, 123),
(2, 'Chill Vibes', 'Relaxing music for studying', true, 87),
(3, 'Road Trip', 'Perfect songs for long drives', true, 156);

-- Insert songs into playlists
INSERT INTO playlist_songs (playlist_id, song_id, position) VALUES 
-- My Favorites playlist
(1, 1, 1), (1, 5, 2), (1, 9, 3), (1, 13, 4),
-- Workout Mix playlist
(2, 9, 1), (2, 10, 2), (2, 11, 3), (2, 12, 4),
-- Chill Vibes playlist
(3, 5, 1), (3, 6, 2), (3, 7, 3), (3, 13, 4), (3, 14, 5),
-- Road Trip playlist
(4, 1, 1), (4, 2, 2), (4, 3, 3), (4, 8, 4);

-- Insert sample listening history
INSERT INTO listening_history (user_id, song_id, duration_played, completion_percentage) VALUES 
(1, 1, 245, 100), (1, 5, 180, 95), (1, 9, 312, 100),
(2, 5, 189, 100), (2, 6, 201, 100), (2, 13, 234, 100),
(3, 1, 230, 94), (3, 9, 300, 96);

-- Insert sample likes
INSERT INTO user_likes (user_id, song_id) VALUES 
(1, 1), (1, 5), (1, 9), (1, 13),
(2, 5), (2, 6), (2, 7), (2, 8),
(3, 1), (3, 2), (3, 9), (3, 10);

-- Insert sample artist follows
INSERT INTO user_follows_artist (user_id, artist_id) VALUES 
(1, 1), (1, 2), (1, 3),
(2, 2), (2, 4),
(3, 1), (3, 3), (3, 5);

-- Insert sample playlist follows
INSERT INTO user_follows_playlist (user_id, playlist_id) VALUES 
(2, 1), (2, 2),
(3, 1), (3, 3),
(1, 3);

-- Verify data insertion
SELECT 'Artists:' as 'Table', COUNT(*) as 'Row Count' FROM artists
UNION ALL
SELECT 'Albums:', COUNT(*) FROM albums
UNION ALL
SELECT 'Songs:', COUNT(*) FROM songs
UNION ALL
SELECT 'Users:', COUNT(*) FROM users
UNION ALL
SELECT 'Playlists:', COUNT(*) FROM playlists
UNION ALL
SELECT 'Playlist Songs:', COUNT(*) FROM playlist_songs
UNION ALL
SELECT 'Listening History:', COUNT(*) FROM listening_history
UNION ALL
SELECT 'User Likes:', COUNT(*) FROM user_likes;
