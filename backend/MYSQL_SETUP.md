# MySQL Local Setup Guide

## ✅ Step 1: MySQL Installation (Completed)
MySQL 8.4.6 has been installed on your system.

## 📝 Step 2: Configure MySQL Server

1. **Open MySQL Command Line Client** or **MySQL Workbench**
   - Search for "MySQL 8.4 Command Line Client" in Windows Start Menu
   - Or download MySQL Workbench from: https://dev.mysql.com/downloads/workbench/

2. **Login as root**
   ```
   Enter password: (leave blank if not set during installation, or use the password you set)
   ```

## 🗄️ Step 3: Create Database and User

Run these commands in MySQL:

```sql
-- Create database
CREATE DATABASE algorythm_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'algorythm_user'@'localhost' IDENTIFIED BY 'algorythm_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON algorythm_db.* TO 'algorythm_user'@'localhost';
FLUSH PRIVILEGES;

-- Switch to the database
USE algorythm_db;
```

## 📊 Step 4: Create Tables

Run the schema file located at:
```
backend/Algorythm/src/main/resources/schema.sql
```

You can either:
- Copy and paste the SQL from that file into MySQL Command Line
- Or use MySQL Workbench: File → Run SQL Script → Select schema.sql

## 🧪 Step 5: Test Connection

The application will connect using:
- **Host:** localhost
- **Port:** 3306
- **Database:** algorythm_db
- **Username:** algorythm_user
- **Password:** algorythm_password

## 🔧 Step 6: Start MySQL Service (if not running)

```powershell
# Check if MySQL is running
Get-Service -Name MySQL* | Select-Object Name, Status

# Start MySQL service if stopped
Start-Service -Name MySQL84
```

## 📝 Default Credentials
- **Database:** algorythm_db
- **Username:** algorythm_user
- **Password:** algorythm_password

You can change these in `backend/Algorythm/src/main/resources/db.properties`

## ⚠️ Troubleshooting

### If you can't login as root:
1. Stop MySQL service: `Stop-Service -Name MySQL84`
2. Reset root password following MySQL documentation
3. Start service: `Start-Service -Name MySQL84`

### If MySQL service won't start:
1. Check error logs in: `C:\ProgramData\MySQL\MySQL Server 8.4\Data\`
2. Verify port 3306 is not in use: `Test-NetConnection -ComputerName localhost -Port 3306`
