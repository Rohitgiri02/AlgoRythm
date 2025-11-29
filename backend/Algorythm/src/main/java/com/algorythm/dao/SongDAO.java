package com.algorythm.dao;

import com.algorythm.model.Song;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Song operations
 */
public class SongDAO extends BaseDAO {

    /**
     * Create a new song
     */
    public Long createSong(Song song) throws SQLException {
        String sql = "INSERT INTO songs (song_title, album_id, artist_id, duration_seconds, " +
                    "audio_file_url, audio_quality, track_number, disc_number, release_date, " +
                    "lyrics, language, explicit_content, is_premium_only) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        return executeInsert(sql,
            song.getSongTitle(),
            song.getAlbumId(),
            song.getArtistId(),
            song.getDurationSeconds(),
            song.getAudioFileUrl(),
            song.getAudioQuality() != null ? song.getAudioQuality() : "High",
            song.getTrackNumber(),
            song.getDiscNumber() != null ? song.getDiscNumber() : 1,
            song.getReleaseDate(),
            song.getLyrics(),
            song.getLanguage(),
            song.isExplicitContent(),
            song.isPremiumOnly()
        );
    }

    /**
     * Find song by ID
     */
    public Song findById(Long songId) throws SQLException {
        String sql = "SELECT * FROM songs WHERE song_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, songId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSong(rs);
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Find songs by artist ID
     */
    public List<Song> findByArtist(Long artistId) throws SQLException {
        String sql = "SELECT * FROM songs WHERE artist_id = ? ORDER BY release_date DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Song> songs = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, artistId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                songs.add(mapResultSetToSong(rs));
            }
            return songs;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Find songs by album ID
     */
    public List<Song> findByAlbum(Long albumId) throws SQLException {
        String sql = "SELECT * FROM songs WHERE album_id = ? ORDER BY track_number";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Song> songs = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, albumId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                songs.add(mapResultSetToSong(rs));
            }
            return songs;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Search songs by title
     */
    public List<Song> searchByTitle(String searchQuery, int limit) throws SQLException {
        String sql = "SELECT * FROM songs WHERE song_title LIKE ? ORDER BY play_count DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Song> songs = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchQuery + "%");
            stmt.setInt(2, limit);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                songs.add(mapResultSetToSong(rs));
            }
            return songs;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Get top songs by play count
     */
    public List<Song> getTopSongs(int limit) throws SQLException {
        String sql = "SELECT * FROM songs ORDER BY play_count DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Song> songs = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                songs.add(mapResultSetToSong(rs));
            }
            return songs;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Get recent releases
     */
    public List<Song> getRecentReleases(int limit) throws SQLException {
        String sql = "SELECT * FROM songs ORDER BY release_date DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Song> songs = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                songs.add(mapResultSetToSong(rs));
            }
            return songs;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Update song information
     */
    public boolean updateSong(Song song) throws SQLException {
        String sql = "UPDATE songs SET song_title = ?, album_id = ?, duration_seconds = ?, " +
                    "audio_file_url = ?, audio_quality = ?, track_number = ?, disc_number = ?, " +
                    "release_date = ?, lyrics = ?, language = ?, explicit_content = ?, " +
                    "is_premium_only = ? WHERE song_id = ?";
        
        int rowsAffected = executeUpdate(sql,
            song.getSongTitle(),
            song.getAlbumId(),
            song.getDurationSeconds(),
            song.getAudioFileUrl(),
            song.getAudioQuality(),
            song.getTrackNumber(),
            song.getDiscNumber(),
            song.getReleaseDate(),
            song.getLyrics(),
            song.getLanguage(),
            song.isExplicitContent(),
            song.isPremiumOnly(),
            song.getSongId()
        );
        
        return rowsAffected > 0;
    }

    /**
     * Increment play count
     */
    public boolean incrementPlayCount(Long songId) throws SQLException {
        String sql = "UPDATE songs SET play_count = play_count + 1 WHERE song_id = ?";
        return executeUpdate(sql, songId) > 0;
    }

    /**
     * Increment like count
     */
    public boolean incrementLikeCount(Long songId) throws SQLException {
        String sql = "UPDATE songs SET like_count = like_count + 1 WHERE song_id = ?";
        return executeUpdate(sql, songId) > 0;
    }

    /**
     * Decrement like count
     */
    public boolean decrementLikeCount(Long songId) throws SQLException {
        String sql = "UPDATE songs SET like_count = like_count - 1 WHERE song_id = ? AND like_count > 0";
        return executeUpdate(sql, songId) > 0;
    }

    /**
     * Delete song
     */
    public boolean deleteSong(Long songId) throws SQLException {
        String sql = "DELETE FROM songs WHERE song_id = ?";
        return executeUpdate(sql, songId) > 0;
    }

    /**
     * Map ResultSet to Song object
     */
    private Song mapResultSetToSong(ResultSet rs) throws SQLException {
        Song song = new Song();
        song.setSongId(rs.getLong("song_id"));
        song.setSongTitle(rs.getString("song_title"));
        song.setAlbumId(rs.getLong("album_id"));
        song.setArtistId(rs.getLong("artist_id"));
        song.setDurationSeconds(rs.getInt("duration_seconds"));
        song.setAudioFileUrl(rs.getString("audio_file_url"));
        song.setAudioQuality(rs.getString("audio_quality"));
        song.setTrackNumber(rs.getInt("track_number"));
        song.setDiscNumber(rs.getInt("disc_number"));
        
        Date releaseDate = rs.getDate("release_date");
        if (releaseDate != null) {
            song.setReleaseDate(releaseDate.toLocalDate());
        }
        
        song.setLyrics(rs.getString("lyrics"));
        song.setLanguage(rs.getString("language"));
        song.setExplicitContent(rs.getBoolean("explicit_content"));
        song.setPremiumOnly(rs.getBoolean("is_premium_only"));
        song.setPlayCount(rs.getLong("play_count"));
        song.setLikeCount(rs.getLong("like_count"));
        song.setCreatedAt(rs.getTimestamp("created_at"));
        song.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return song;
    }
}
