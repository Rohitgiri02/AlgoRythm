# AlgoRythm - Music Streaming Platform

A comprehensive music streaming platform backend built with Java, JDBC, and MySQL.

## Features

- User authentication and authorization
- User profile management
- Song and album management
- Artist profiles
- Playlist creation and management
- Listening history tracking
- Search functionality
- Social features (likes, follows, comments)
- Subscription management
- Analytics and recommendations

## Technology Stack

- **Java 11**
- **JDBC** for database connectivity
- **MySQL** as the database
- **HikariCP** for connection pooling
- **Maven** for dependency management
- **SLF4J & Logback** for logging
- **Servlet API** for web layer

## Database Setup

1. Create a MySQL database:
```sql
CREATE DATABASE music_streaming;
```

2. Execute the schema:
```bash
mysql -u root -p music_streaming < src/main/resources/schema.sql
```

3. Update database credentials in `src/main/resources/db.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/music_streaming
db.username=your_username
db.password=your_password
```

## Project Structure

```
src/main/
├── java/com/algorythm/
│   ├── config/          # Database configuration
│   │   └── DatabaseConfig.java
│   ├── dao/             # Data Access Objects
│   │   ├── BaseDAO.java
│   │   ├── UserDAO.java
│   │   └── SongDAO.java
│   ├── model/           # Entity models
│   │   ├── User.java
│   │   └── Song.java
│   ├── service/         # Business logic
│   │   └── UserService.java
│   └── servlet/         # Web servlets
│       └── UserServlet.java
├── resources/
│   ├── schema.sql       # Database schema
│   ├── db.properties    # Database configuration
│   └── logback.xml      # Logging configuration
└── webapp/
    ├── index.jsp
    └── WEB-INF/
        └── web.xml
```

## Building and Running

1. **Build the project:**
```bash
mvn clean package
```

2. **Deploy to Tomcat:**
   - Copy the generated WAR file from `target/Algorythm.war` to your Tomcat `webapps` directory
   - Start Tomcat server

3. **Access the application:**
   - http://localhost:8080/Algorythm/

## API Endpoints

### User Management

- **POST** `/user/register` - Register a new user
  - Parameters: `username`, `email`, `password`
  
- **POST** `/user/login` - User login
  - Parameters: `email`, `password`
  
- **GET** `/user/profile` - Get user profile (requires authentication)

- **GET** `/user/logout` - Logout user

## Database Schema Overview

### Core Tables:
- `users` - User accounts and profiles
- `artists` - Artist information
- `albums` - Album metadata
- `songs` - Song details and audio files
- `playlists` - User playlists
- `listening_history` - User listening activity
- `user_likes` - User likes/favorites
- `user_follows` - User follows artists/playlists
- `subscriptions` - Subscription management
- `payment_transactions` - Payment history

## Connection Pool Configuration

The application uses HikariCP for efficient database connection pooling:
- Maximum pool size: 10
- Minimum idle connections: 5
- Connection timeout: 30 seconds
- Prepared statement caching enabled

## Development

### Adding New DAOs

1. Create a new model class in `com.algorythm.model`
2. Create a DAO class extending `BaseDAO` in `com.algorythm.dao`
3. Implement CRUD operations using the base methods

### Example:
```java
public class ArtistDAO extends BaseDAO {
    public Long createArtist(Artist artist) throws SQLException {
        String sql = "INSERT INTO artists (artist_name, bio) VALUES (?, ?)";
        return executeInsert(sql, artist.getName(), artist.getBio());
    }
}
```

## Logging

Logs are written to:
- Console (INFO level)
- File: `logs/algorythm.log` (DEBUG level for application code)
- Rolling policy: Daily rotation, 30 days retention

## Security Considerations

- Passwords are hashed using SHA-256
- SQL injection prevention through PreparedStatements
- Session-based authentication
- Connection pooling for resource management

## Future Enhancements

- JWT token-based authentication
- RESTful API with JSON responses
- Redis caching layer
- Elasticsearch for advanced search
- AWS S3 integration for audio storage
- WebSocket for real-time features
- Admin dashboard

## License

MIT License
