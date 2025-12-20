package com.algorythm.servlet;

import com.algorythm.dao.SongDAO;
import com.algorythm.model.Song;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet for handling song-related requests
 */
@WebServlet(urlPatterns = {"/songs", "/songs/*"})
public class SongServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(SongServlet.class);
    private SongDAO songDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        songDAO = new SongDAO();
        gson = new Gson();
        logger.info("SongServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all songs or search
                String searchQuery = request.getParameter("q");
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    searchSongs(searchQuery, response);
                } else {
                    getAllSongs(response);
                }
            } else if (pathInfo.matches("/\\d+")) {
                // Get song by ID
                Long songId = Long.parseLong(pathInfo.substring(1));
                getSongById(songId, response);
            } else if (pathInfo.startsWith("/artist/")) {
                // Get songs by artist
                Long artistId = Long.parseLong(pathInfo.substring(8));
                getSongsByArtist(artistId, response);
            } else if (pathInfo.startsWith("/album/")) {
                // Get songs by album
                Long albumId = Long.parseLong(pathInfo.substring(7));
                getSongsByAlbum(albumId, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid ID format\"}");
        } catch (SQLException e) {
            logger.error("Database error", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error occurred\"}");
        }
    }

    private void getAllSongs(HttpServletResponse response) throws SQLException, IOException {
        List<Song> songs = songDAO.findAll();
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(songs));
    }

    private void getSongById(Long songId, HttpServletResponse response) throws SQLException, IOException {
        Song song = songDAO.findById(songId);
        if (song != null) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(song));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Song not found\"}");
        }
    }

    private void getSongsByArtist(Long artistId, HttpServletResponse response) throws SQLException, IOException {
        List<Song> songs = songDAO.findByArtist(artistId);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(songs));
    }

    private void getSongsByAlbum(Long albumId, HttpServletResponse response) throws SQLException, IOException {
        List<Song> songs = songDAO.findByAlbum(albumId);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(songs));
    }

    private void searchSongs(String query, HttpServletResponse response) throws SQLException, IOException {
        List<Song> songs = songDAO.searchByTitle(query);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(gson.toJson(songs));
    }
}
