package com.algorythm.model;

import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Song entity representing songs table
 */
public class Song {
    private Long songId;
    private String songTitle;
    private Long albumId;
    private Long artistId;
    private int durationSeconds;
    private String audioFileUrl;
    private String audioQuality;
    private Integer trackNumber;
    private Integer discNumber;
    private LocalDate releaseDate;
    private String lyrics;
    private String language;
    private boolean explicitContent;
    private boolean isPremiumOnly;
    private long playCount;
    private long likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Song() {}

    public Song(String songTitle, Long artistId, int durationSeconds, String audioFileUrl) {
        this.songTitle = songTitle;
        this.artistId = artistId;
        this.durationSeconds = durationSeconds;
        this.audioFileUrl = audioFileUrl;
    }

    // Getters and Setters
    public Long getSongId() {
        return songId;
    }

    public void setSongId(Long songId) {
        this.songId = songId;
    }

    public String getSongTitle() {
        return songTitle;
    }

    public void setSongTitle(String songTitle) {
        this.songTitle = songTitle;
    }

    public Long getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Long albumId) {
        this.albumId = albumId;
    }

    public Long getArtistId() {
        return artistId;
    }

    public void setArtistId(Long artistId) {
        this.artistId = artistId;
    }

    public int getDurationSeconds() {
        return durationSeconds;
    }

    public void setDurationSeconds(int durationSeconds) {
        this.durationSeconds = durationSeconds;
    }

    public String getAudioFileUrl() {
        return audioFileUrl;
    }

    public void setAudioFileUrl(String audioFileUrl) {
        this.audioFileUrl = audioFileUrl;
    }

    public String getAudioQuality() {
        return audioQuality;
    }

    public void setAudioQuality(String audioQuality) {
        this.audioQuality = audioQuality;
    }

    public Integer getTrackNumber() {
        return trackNumber;
    }

    public void setTrackNumber(Integer trackNumber) {
        this.trackNumber = trackNumber;
    }

    public Integer getDiscNumber() {
        return discNumber;
    }

    public void setDiscNumber(Integer discNumber) {
        this.discNumber = discNumber;
    }

    public LocalDate getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(LocalDate releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getLyrics() {
        return lyrics;
    }

    public void setLyrics(String lyrics) {
        this.lyrics = lyrics;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public boolean isExplicitContent() {
        return explicitContent;
    }

    public void setExplicitContent(boolean explicitContent) {
        this.explicitContent = explicitContent;
    }

    public boolean isPremiumOnly() {
        return isPremiumOnly;
    }

    public void setPremiumOnly(boolean premiumOnly) {
        isPremiumOnly = premiumOnly;
    }

    public long getPlayCount() {
        return playCount;
    }

    public void setPlayCount(long playCount) {
        this.playCount = playCount;
    }

    public long getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(long likeCount) {
        this.likeCount = likeCount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Song{" +
                "songId=" + songId +
                ", songTitle='" + songTitle + '\'' +
                ", artistId=" + artistId +
                ", durationSeconds=" + durationSeconds +
                ", playCount=" + playCount +
                ", explicitContent=" + explicitContent +
                '}';
    }
}
