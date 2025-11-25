# 🎵 AlgoRythm - AI-Powered Music Streaming Platform

<div align="center">

![AlgoRythm Logo](https://img.shields.io/badge/AlgoRythm-AI%20Music%20Platform-blueviolet?style=for-the-badge)
[![Made with React](https://img.shields.io/badge/React-19.2.0-61DAFB?style=flat-square&logo=react)](https://reactjs.org/)
[![Java Servlet](https://img.shields.io/badge/Servlet-Backend-orange?style=flat-square&logo=java)](https://docs.oracle.com/javaee/7/api/javax/servlet/package-summary.html)
[![JDBC](https://img.shields.io/badge/JDBC-Database-blue?style=flat-square&logo=postgresql)](https://docs.oracle.com/javase/8/docs/technotes/guides/jdbc/)

**An intelligent music streaming platform powered by advanced AI algorithms**

</div>

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Team](#team)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
  - [Frontend Setup](#frontend-setup)
  - [Backend Setup](#backend-setup)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 About the Project

**AlgoRythm** is an innovative AI-powered music streaming platform that revolutionizes how users discover and enjoy music. Using advanced artificial intelligence algorithms, AlgoRythm creates personalized playlists, recommends tracks based on listening habits, and provides an immersive music experience with a sleek, responsive user interface.

### Core Concept

The platform leverages AI to:
- **Analyze user preferences** and listening patterns
- **Generate personalized playlists** tailored to individual tastes
- **Recommend new music** based on mood, genre, and listening history
- **Create smart radio stations** that adapt to user feedback
- **Provide seamless streaming** with an intuitive, modern interface

---

## 👥 Team

<div align="center">

### **Team Zcoder**

| Role | Name |
|------|------|
| **Team Leader** | Rohit Giri |
| **Team Member** | Palak Kumari |
| **Team Member** | Ujjwal Kumar |

</div>

---

## ✨ Features

- 🤖 **AI-Powered Recommendations** - Smart music suggestions based on your taste
- 🎼 **Personalized Playlists** - Auto-generated playlists that match your mood
- 🔍 **Advanced Search** - Find songs, artists, and albums instantly
- 📱 **Responsive Design** - Seamless experience across all devices
- 🎵 **Music Player** - Full-featured player with queue management
- 📊 **Listening History** - Track your recently played songs
- 🎨 **Modern UI/UX** - Beautiful glassmorphism design with smooth animations
- 🔊 **Volume Control** - Precise audio level management
- ⏯️ **Playback Controls** - Play, pause, skip, shuffle, and repeat

---

## 🛠️ Tech Stack

### Frontend
- **React 19.2.0** - Modern UI library for building interactive interfaces
- **Vite 7.2.4** - Next-generation frontend build tool
- **CSS3** - Advanced styling with glassmorphism and gradients
- **ESLint** - Code quality and consistency

### Backend
- **Java Servlets** - Server-side request handling and business logic
- **JDBC (Java Database Connectivity)** - Database integration and data persistence
- **Apache Tomcat** - Servlet container for deployment
- **JSP (JavaServer Pages)** - Dynamic web page generation

### Database
- **MySQL/PostgreSQL** - Relational database for storing user data, songs, and playlists

---

## 📦 Prerequisites

Before setting up the project, ensure you have the following installed:

### For Frontend:
- **Node.js** (v18.0.0 or higher) - [Download](https://nodejs.org/)
- **npm** (v9.0.0 or higher) or **yarn**

### For Backend:
- **Java Development Kit (JDK)** (v11 or higher) - [Download](https://www.oracle.com/java/technologies/downloads/)
- **Apache Maven** (v3.6 or higher) - [Download](https://maven.apache.org/download.cgi)
- **Apache Tomcat** (v9.0 or higher) - [Download](https://tomcat.apache.org/download-90.cgi)
- **MySQL** or **PostgreSQL** database

---

## 🚀 Installation & Setup

### Frontend Setup

1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```
   or if you use yarn:
   ```bash
   yarn install
   ```

3. **Configure environment variables:**
   
   Create a `.env` file in the `frontend` directory:
   ```env
   VITE_API_URL=http://localhost:8080/Algorythm
   VITE_APP_NAME=AlgoRythm
   ```

4. **Start the development server:**
   ```bash
   npm run dev
   ```
   or
   ```bash
   yarn dev
   ```

5. **Access the application:**
   
   Open your browser and navigate to: `http://localhost:5173`

### Frontend Build for Production:
```bash
npm run build
```
The build files will be generated in the `dist` folder.

---

### Backend Setup

1. **Navigate to the backend directory:**
   ```bash
   cd backend/Algorythm
   ```

2. **Configure Database:**

   Create a database for the project:
   ```sql
   CREATE DATABASE algorythm_db;
   USE algorythm_db;
   ```

   Update the JDBC connection properties in your servlet configuration or create a `db.properties` file:
   ```properties
   db.url=jdbc:mysql://localhost:3306/algorythm_db
   db.username=your_username
   db.password=your_password
   db.driver=com.mysql.cj.jdbc.Driver
   ```

3. **Create Database Tables:**

   Run the SQL schema (create these tables in your database):
   ```sql
   -- Users Table
   CREATE TABLE users (
       user_id INT PRIMARY KEY AUTO_INCREMENT,
       username VARCHAR(50) UNIQUE NOT NULL,
       email VARCHAR(100) UNIQUE NOT NULL,
       password VARCHAR(255) NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

   -- Songs Table
   CREATE TABLE songs (
       song_id INT PRIMARY KEY AUTO_INCREMENT,
       title VARCHAR(200) NOT NULL,
       artist VARCHAR(100) NOT NULL,
       album VARCHAR(100),
       duration INT,
       file_path VARCHAR(500),
       cover_image VARCHAR(500),
       genre VARCHAR(50),
       release_date DATE,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

   -- Playlists Table
   CREATE TABLE playlists (
       playlist_id INT PRIMARY KEY AUTO_INCREMENT,
       user_id INT,
       name VARCHAR(100) NOT NULL,
       description TEXT,
       is_ai_generated BOOLEAN DEFAULT FALSE,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES users(user_id)
   );

   -- Playlist Songs Table
   CREATE TABLE playlist_songs (
       id INT PRIMARY KEY AUTO_INCREMENT,
       playlist_id INT,
       song_id INT,
       position INT,
       added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id),
       FOREIGN KEY (song_id) REFERENCES songs(song_id)
   );

   -- Listening History Table
   CREATE TABLE listening_history (
       id INT PRIMARY KEY AUTO_INCREMENT,
       user_id INT,
       song_id INT,
       played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES users(user_id),
       FOREIGN KEY (song_id) REFERENCES songs(song_id)
   );
   ```

4. **Update `pom.xml` dependencies:**

   Ensure your `pom.xml` includes the necessary dependencies:
   ```xml
   <dependencies>
       <!-- Servlet API -->
       <dependency>
           <groupId>javax.servlet</groupId>
           <artifactId>javax.servlet-api</artifactId>
           <version>4.0.1</version>
           <scope>provided</scope>
       </dependency>

       <!-- JDBC MySQL Driver -->
       <dependency>
           <groupId>mysql</groupId>
           <artifactId>mysql-connector-java</artifactId>
           <version>8.0.33</version>
       </dependency>

       <!-- JSON Processing -->
       <dependency>
           <groupId>com.google.code.gson</groupId>
           <artifactId>gson</artifactId>
           <version>2.10.1</version>
       </dependency>
   </dependencies>
   ```

5. **Build the project using Maven:**
   ```bash
   mvn clean install
   ```

6. **Deploy to Tomcat:**

   **Option A - Manual Deployment:**
   - Copy the generated WAR file from `target/Algorythm.war` to Tomcat's `webapps` directory
   - Start Tomcat server:
     ```bash
     # Windows
     TOMCAT_HOME\bin\startup.bat
     
     # Linux/Mac
     TOMCAT_HOME/bin/startup.sh
     ```

   **Option B - IDE Deployment:**
   - If using Eclipse/IntelliJ IDEA, configure Tomcat server in your IDE
   - Right-click project → Run on Server → Select Tomcat

7. **Verify Backend is Running:**
   
   Access: `http://localhost:8080/Algorythm`

---

## 📁 Project Structure

```
AlgoRythm/
│
├── frontend/                    # React Frontend Application
│   ├── public/                 # Static assets
│   ├── src/
│   │   ├── assets/            # Images, icons, etc.
│   │   ├── App.jsx            # Main application component
│   │   ├── App.css            # Application styles
│   │   ├── main.jsx           # Entry point
│   │   └── index.css          # Global styles
│   ├── package.json           # Frontend dependencies
│   ├── vite.config.js         # Vite configuration
│   └── README.md              # Frontend documentation
│
├── backend/                    # Java Backend Application
│   └── Algorythm/
│       ├── src/
│       │   └── main/
│       │       ├── java/      # Java Servlets & Business Logic
│       │       └── webapp/
│       │           ├── WEB-INF/
│       │           │   └── web.xml    # Servlet configuration
│       │           └── index.jsp
│       └── pom.xml            # Maven configuration
│
└── README.md                   # This file
```

---

## 💻 Usage

### Running the Complete Application

1. **Start the Backend Server:**
   - Ensure Tomcat is running with the deployed backend
   - Backend will be available at: `http://localhost:8080/Algorythm`

2. **Start the Frontend Development Server:**
   ```bash
   cd frontend
   npm run dev
   ```
   - Frontend will be available at: `http://localhost:5173`

3. **Access the Application:**
   - Open your browser and go to `http://localhost:5173`
   - The frontend will communicate with the backend API automatically

### Key Endpoints (Backend API)

- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/songs` - Get all songs
- `GET /api/songs/{id}` - Get specific song
- `GET /api/playlists` - Get user playlists
- `POST /api/playlists` - Create new playlist
- `GET /api/recommendations` - Get AI-powered recommendations
- `GET /api/history` - Get listening history

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is developed by **Team Zcoder** for educational purposes.

---

## 📞 Contact

**Team Zcoder**

- **Team Leader:** Rohit Giri
- **Email:** [contact@algorythm.com](mailto:contact@algorythm.com)
- **Project Link:** [https://github.com/teamzcoder/algorythm](https://github.com/teamzcoder/algorythm)

---

## 🙏 Acknowledgments

- React Team for the amazing framework
- Apache Software Foundation for Tomcat and Maven
- All open-source contributors who made this project possible

---

<div align="center">

**Made with ❤️ by Team Zcoder**

⭐ Star this repository if you find it helpful!

</div>
