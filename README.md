# 🎵 AlgoRythm - Music Streaming Platform

<div align="center">

![AlgoRythm Logo](https://img.shields.io/badge/AlgoRythm-Music%20Platform-blueviolet?style=for-the-badge)
[![Made with React](https://img.shields.io/badge/React-19.2.0-61DAFB?style=flat-square&logo=react)](https://reactjs.org/)
[![Java Servlet](https://img.shields.io/badge/Servlet-Backend-orange?style=flat-square&logo=java)](https://docs.oracle.com/javaee/7/api/javax/servlet/package-summary.html)
[![MySQL](https://img.shields.io/badge/MySQL-8.4-blue?style=flat-square&logo=mysql)](https://www.mysql.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=flat-square&logo=docker)](https://www.docker.com/)

**A full-stack music streaming platform with modern architecture**

[Quick Start](#-quick-start-with-docker) • [Manual Setup](#-manual-setup) • [Features](#-features) • [API Docs](#-api-endpoints)

</div>

---

## 📋 Table of Contents

- [About](#-about-the-project)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Quick Start (Docker)](#-quick-start-with-docker)
- [Manual Setup](#-manual-setup)
- [Usage Guide](#-usage-guide)
- [API Endpoints](#-api-endpoints)
- [Project Structure](#-project-structure)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 About the Project

**AlgoRythm** is a modern music streaming platform built with React and Java Servlets. Stream music, create playlists, and track your listening activity with a beautiful, responsive interface.

---

## ✨ Features

- 🔐 **User Authentication** - Secure registration and login
- 🎵 **Music Library** - Browse 20+ sample songs
- 🔍 **Search** - Find songs by title, artist, or album
- 📱 **Responsive** - Works on all devices
- 🎼 **Playlists** - Create and manage custom playlists
- ❤️ **Favorites** - Like and save tracks
- 📊 **History** - Track listening activity
- 👤 **Profiles** - Personalized user accounts

---

## 🛠️ Tech Stack

**Frontend:** React 19, Vite, React Router, Axios  
**Backend:** Java 11, Servlets, HikariCP, Gson  
**Database:** MySQL 8.4  
**Deployment:** Docker, Tomcat 9, Nginx  

---

## 🚀 Quick Start with Docker

**The fastest and safest way to run AlgoRythm:**

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed

### Steps

```bash
# 1. Clone repository
git clone <repository-url>
cd AlgoRythm

# 2. Start all services
docker-compose up -d

# 3. Wait 60 seconds for initialization

# 4. Access application
```

- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:8080/Algorythm  
- **Test Login:** john@example.com / password

```bash
# Stop services
docker-compose down

# Stop and remove data
docker-compose down -v
```

---

## 🔧 Manual Setup

### Prerequisites

- Java JDK 11+ 
- Maven 3.9+
- Tomcat 9.0+
- MySQL 8.4+
- Node.js 18+

### 1. Database Setup

```bash
# Install MySQL (Windows)
winget install Oracle.MySQL

# Start MySQL
net start MySQL84

# Create database
mysql -u root -p
```

```sql
CREATE DATABASE algorythm_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'algorythm_user'@'localhost' IDENTIFIED BY 'algorythm_password';
GRANT ALL PRIVILEGES ON algorythm_db.* TO 'algorythm_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Load schema
mysql -u algorythm_user -palgorythm_password algorythm_db < backend/Algorythm/src/main/resources/schema_mysql.sql

# Load sample data
mysql -u algorythm_user -palgorythm_password algorythm_db < backend/Algorythm/src/main/resources/sample_data.sql
```

### 2. Backend Setup

```bash
cd backend/Algorythm

# Build
mvn clean package

# Deploy to Tomcat
cp target/Algorythm.war /path/to/tomcat/webapps/

# Set JAVA_HOME (Windows)
set JAVA_HOME=C:\Program Files\Java\jdk-11

# Start Tomcat
cd /path/to/tomcat/bin
startup.bat
```

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build
```

**Access:** http://localhost:3000

---

## 📖 Usage Guide

### Register & Login

1. Open http://localhost:3000
2. Click **Register** → Fill form → Create Account
3. Or use test account: john@example.com / password

### Browse Music

- View all songs on dashboard
- Search by title in search bar
- Click song card to play
- Click ❤️ to like

### Create Playlists

1. Click **"Create Playlist"**
2. Enter name and description
3. Add songs with **+** icon

### Profile

- View listening stats
- See favorite songs
- Manage playlists
- Update settings

---

## 🔗 API Endpoints

### Authentication

```http
POST /Algorythm/users/register
{
  "username": "string",
  "email": "string",
  "password": "string",
  "fullName": "string"
}

POST /Algorythm/users/login
{
  "email": "string",
  "password": "string"
}

POST /Algorythm/users/logout
```

### Songs

```http
GET /Algorythm/songs
GET /Algorythm/songs/{id}
GET /Algorythm/songs/search?q=searchTerm
GET /Algorythm/songs/artist/{artistId}
GET /Algorythm/songs/album/{albumId}
```

### Activity

```http
POST /Algorythm/activity/like
{
  "songId": number
}

POST /Algorythm/activity/history
{
  "songId": number,
  "durationPlayed": number,
  "completionPercentage": number
}
```

---

## 📁 Project Structure

```
AlgoRythm/
├── backend/Algorythm/
│   ├── src/main/java/com/algorythm/
│   │   ├── config/DatabaseConfig.java
│   │   ├── dao/*.java
│   │   ├── filter/CorsFilter.java
│   │   ├── model/*.java
│   │   ├── service/*.java
│   │   └── servlet/*.java
│   ├── src/main/resources/
│   │   ├── db.properties
│   │   ├── schema_mysql.sql
│   │   └── sample_data.sql
│   └── pom.xml
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── context/
│   │   ├── services/
│   │   └── App.jsx
│   ├── package.json
│   └── vite.config.js
├── docker-compose.yml
└── README.md
```

---

## 🐛 Troubleshooting

### Port in Use
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :3000
kill -9 <PID>
```

### MySQL Won't Connect
```bash
# Check service
net start MySQL84  # Windows
sudo systemctl status mysql  # Linux

# Test connection
mysql -u algorythm_user -palgorythm_password algorythm_db
```

### Tomcat Issues
```bash
# Check JAVA_HOME
echo %JAVA_HOME%  # Windows
echo $JAVA_HOME   # Linux

# View logs
cat /path/to/tomcat/logs/catalina.out
```

### Docker Problems
```bash
# View logs
docker-compose logs

# Rebuild
docker-compose down -v
docker-compose up --build -d
```

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/Amazing`)
3. Commit changes (`git commit -m 'Add feature'`)
4. Push to branch (`git push origin feature/Amazing`)
5. Open Pull Request

---

## 👥 Team Zcoder

| Role | Name |
|------|------|
| **Team Leader** | Rohit Giri |
| **Member** | Palak Kumari |
| **Member** | Ujjwal Kumar |

---

<div align="center">

**Made with ❤️ by Team Zcoder**

⭐ Star us on GitHub!

[Report Bug](https://github.com/yourusername/AlgoRythm/issues) • [Request Feature](https://github.com/yourusername/AlgoRythm/issues)

</div>
