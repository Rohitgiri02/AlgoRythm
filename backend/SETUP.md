# AlgoRythm Backend Setup & Configuration

## ✅ Issues Fixed

### 1. **Database Configuration**
- ✅ Updated `db.properties` with Supabase PostgreSQL connection
- ✅ Changed driver from MySQL to PostgreSQL
- ✅ Added PostgreSQL dependency to `pom.xml`

### 2. **CORS Configuration**
- ✅ Created `CorsFilter.java` to allow frontend (port 3000) to communicate with backend
- ✅ Updated `web.xml` to modern Servlet 4.0 specification
- ✅ Configured CORS headers for cross-origin requests

### 3. **API Endpoints**
- ✅ Created `SongServlet.java` for song operations
- ✅ Added JSON support with Gson library
- ✅ Updated `SongDAO` with findAll() and searchByTitle() methods

### 4. **Dependencies**
- ✅ PostgreSQL JDBC Driver (42.7.1)
- ✅ HikariCP for connection pooling
- ✅ Gson for JSON processing
- ✅ SLF4J + Logback for logging

## 📋 Prerequisites

1. **Java Development Kit (JDK) 11 or higher**
2. **Apache Maven 3.6+**
3. **Apache Tomcat 9.0+** (or any Servlet 4.0 compatible server)
4. **Supabase PostgreSQL Database** (already configured)

## 🚀 How to Build and Run

### Step 1: Verify Database Connection

Make sure your `db.properties` has correct Supabase credentials:
```properties
db.url=jdbc:postgresql://db.xbvvbkjkrragpxbypvax.supabase.co:5432/postgres
db.username=postgres
db.password=Rohitgiri123@
db.driver=org.postgresql.Driver
```

### Step 2: Build the Project

```bash
cd backend/Algorythm
mvn clean package
```

This will create `Algorythm.war` in the `target/` directory.

### Step 3: Deploy to Tomcat

**Option A: Copy WAR file**
```bash
cp target/Algorythm.war $TOMCAT_HOME/webapps/
```

**Option B: Using Maven Tomcat Plugin**
Add to `pom.xml`:
```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <port>8080</port>
        <path>/Algorythm</path>
    </configuration>
</plugin>
```

Then run:
```bash
mvn tomcat7:run
```

### Step 4: Start Tomcat

```bash
$TOMCAT_HOME/bin/startup.sh   # Linux/Mac
$TOMCAT_HOME/bin/startup.bat  # Windows
```

### Step 5: Verify Backend is Running

Open your browser or use curl:
```bash
# Test health
curl http://localhost:8080/Algorythm/

# Test songs endpoint
curl http://localhost:8080/Algorythm/songs
```

## 🔌 Available API Endpoints

### User Endpoints
- `POST /Algorythm/user/register` - Register new user
- `POST /Algorythm/user/login` - User login
- `GET /Algorythm/user/profile` - Get user profile (requires session)
- `GET /Algorythm/user/logout` - Logout user

### Song Endpoints
- `GET /Algorythm/songs` - Get all songs
- `GET /Algorythm/songs/{id}` - Get song by ID
- `GET /Algorythm/songs?q={query}` - Search songs
- `GET /Algorythm/songs/artist/{artistId}` - Get songs by artist
- `GET /Algorythm/songs/album/{albumId}` - Get songs by album

## 📝 Database Schema

Make sure you've run the PostgreSQL schema in Supabase:
1. Go to Supabase SQL Editor
2. Run the complete schema from `src/main/resources/schema.sql`

## 🐛 Troubleshooting

### Issue: Connection Refused
- Make sure Tomcat is running on port 8080
- Check if another application is using port 8080

### Issue: Database Connection Error
- Verify Supabase credentials in `db.properties`
- Check if your IP is allowed in Supabase settings
- Test connection: `psql -h db.xbvvbkjkrragpxbypvax.supabase.co -U postgres -d postgres`

### Issue: CORS Error
- Verify frontend is running on `http://localhost:3000`
- Check `CorsFilter` is properly configured in `web.xml`

### Issue: ClassNotFoundException
- Run `mvn clean install` to download all dependencies
- Check Maven repository: `~/.m2/repository/`

## 📦 Project Structure

```
backend/Algorythm/
├── pom.xml                          # Maven dependencies
├── src/
│   ├── main/
│   │   ├── java/com/algorythm/
│   │   │   ├── config/
│   │   │   │   └── DatabaseConfig.java
│   │   │   ├── dao/
│   │   │   │   ├── BaseDAO.java
│   │   │   │   ├── UserDAO.java
│   │   │   │   └── SongDAO.java
│   │   │   ├── filter/
│   │   │   │   └── CorsFilter.java        # NEW
│   │   │   ├── model/
│   │   │   │   ├── User.java
│   │   │   │   └── Song.java
│   │   │   ├── service/
│   │   │   │   └── UserService.java
│   │   │   └── servlet/
│   │   │       ├── UserServlet.java
│   │   │       └── SongServlet.java       # NEW
│   │   ├── resources/
│   │   │   ├── db.properties              # UPDATED
│   │   │   ├── logback.xml
│   │   │   └── schema.sql
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                # UPDATED
│   │       └── index.jsp
│   └── test/
└── target/
    └── Algorythm.war
```

## 🔐 Security Notes

1. **Never commit** `db.properties` with real passwords
2. Use environment variables in production
3. Implement proper authentication/authorization
4. Add input validation and sanitization
5. Use HTTPS in production

## 📚 Next Steps

1. Add more servlets for playlists, artists, albums
2. Implement JWT-based authentication
3. Add pagination for large result sets
4. Implement caching with Redis
5. Add rate limiting
6. Write unit tests

## 💡 Testing with Sample Data

Insert some test songs in Supabase:

```sql
-- Insert a test artist
INSERT INTO artists (artist_name, bio, verified) 
VALUES ('Test Artist', 'Sample artist for testing', true);

-- Insert test songs (use the artist_id from above)
INSERT INTO songs (song_title, artist_id, duration_seconds, audio_file_url)
VALUES 
  ('Test Song 1', 1, 180, 'https://example.com/song1.mp3'),
  ('Test Song 2', 1, 240, 'https://example.com/song2.mp3'),
  ('Test Song 3', 1, 200, 'https://example.com/song3.mp3');
```

## ✅ Checklist

- [x] PostgreSQL driver configured
- [x] Database connection tested
- [x] CORS filter added
- [x] User authentication working
- [x] Song endpoints created
- [ ] Insert sample data
- [ ] Test all endpoints
- [ ] Deploy to production

---

**Ready to start!** Build the project and run the frontend to see everything working together! 🎵
