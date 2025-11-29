package com.algorythm.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database configuration and connection pool management using HikariCP
 */
public class DatabaseConfig {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);
    private static HikariDataSource dataSource;
    private static final String PROPERTIES_FILE = "db.properties";

    static {
        try {
            initializeDataSource();
        } catch (Exception e) {
            logger.error("Failed to initialize database connection pool", e);
            throw new RuntimeException("Database initialization failed", e);
        }
    }

    /**
     * Initialize the HikariCP connection pool
     */
    private static void initializeDataSource() throws IOException {
        Properties properties = loadProperties();
        
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(properties.getProperty("db.url"));
        config.setUsername(properties.getProperty("db.username"));
        config.setPassword(properties.getProperty("db.password"));
        config.setDriverClassName(properties.getProperty("db.driver"));
        
        // Connection pool settings
        config.setMaximumPoolSize(Integer.parseInt(properties.getProperty("hikari.maximumPoolSize", "10")));
        config.setMinimumIdle(Integer.parseInt(properties.getProperty("hikari.minimumIdle", "5")));
        config.setConnectionTimeout(Long.parseLong(properties.getProperty("hikari.connectionTimeout", "30000")));
        config.setIdleTimeout(Long.parseLong(properties.getProperty("hikari.idleTimeout", "600000")));
        config.setMaxLifetime(Long.parseLong(properties.getProperty("hikari.maxLifetime", "1800000")));
        
        // Performance optimization
        config.addDataSourceProperty("cachePrepStmts", properties.getProperty("hikari.cachePrepStmts", "true"));
        config.addDataSourceProperty("prepStmtCacheSize", properties.getProperty("hikari.prepStmtCacheSize", "250"));
        config.addDataSourceProperty("prepStmtCacheSqlLimit", properties.getProperty("hikari.prepStmtCacheSqlLimit", "2048"));
        
        config.setPoolName("MusicStreamingPool");
        config.setAutoCommit(true);
        config.setConnectionTestQuery("SELECT 1");
        
        dataSource = new HikariDataSource(config);
        logger.info("Database connection pool initialized successfully");
    }

    /**
     * Load database properties from db.properties file
     */
    private static Properties loadProperties() throws IOException {
        Properties properties = new Properties();
        try (InputStream input = DatabaseConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (input == null) {
                throw new IOException("Unable to find " + PROPERTIES_FILE);
            }
            properties.load(input);
        }
        return properties;
    }

    /**
     * Get a connection from the pool
     * 
     * @return Database connection
     * @throws SQLException if connection cannot be obtained
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource not initialized");
        }
        return dataSource.getConnection();
    }

    /**
     * Close the connection pool (call on application shutdown)
     */
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("Database connection pool closed");
        }
    }

    /**
     * Get the HikariDataSource instance
     */
    public static HikariDataSource getDataSource() {
        return dataSource;
    }
}
