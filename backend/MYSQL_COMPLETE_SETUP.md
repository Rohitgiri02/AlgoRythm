# 🚀 Complete MySQL Setup Instructions

## Step 1: Add MySQL to System PATH

1. **Open System Environment Variables:**
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"

2. **Edit PATH:**
   - Under "System variables", find and select "Path"
   - Click "Edit"
   - Click "New"
   - Add: `C:\Program Files\MySQL\MySQL Server 8.4\bin`
   - Click "OK" on all dialogs

3. **Restart PowerShell** to apply changes

## Step 2: Initialize MySQL (First Time Setup)

Run these commands in a **NEW PowerShell window** (as Administrator):

```powershell
# Navigate to MySQL bin directory
cd "C:\Program Files\MySQL\MySQL Server 8.4\bin"

# Initialize MySQL data directory (only needed once)
.\mysqld --initialize-insecure --console
```

This creates the default database and root user with no password.

## Step 3: Start MySQL Server

```powershell
# Option 1: Start as Windows Service
net start MySQL84

# Option 2: If service doesn't exist, install it first
.\mysqld --install MySQL84
net start MySQL84

# Check if running
Test-NetConnection -ComputerName localhost -Port 3306
```

## Step 4: Connect to MySQL and Setup Database

```powershell
# Connect to MySQL (in new PowerShell after adding to PATH)
mysql -u root

# Or if you set a password during installation:
mysql -u root -p
```

Then run these SQL commands:

```sql
-- Create database
CREATE DATABASE algorythm_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'algorythm_user'@'localhost' IDENTIFIED BY 'algorythm_password';

-- Grant all privileges
GRANT ALL PRIVILEGES ON algorythm_db.* TO 'algorythm_user'@'localhost';
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;
SELECT user, host FROM mysql.user WHERE user='algorythm_user';

-- Exit
EXIT;
```

## Step 5: Test Connection

```powershell
# Test connection with new user
mysql -u algorythm_user -palgorythm_password algorythm_db

# If successful, you'll see:
# mysql>
```

## Step 6: Load Schema

Copy the MySQL schema from `backend/Algorythm/src/main/resources/schema.sql` and run:

```powershell
# Load schema
mysql -u algorythm_user -palgorythm_password algorythm_db < "C:\Users\Rohit\Desktop\projects\AlgoRythm\backend\Algorythm\src\main\resources\schema.sql"
```

## ✅ Quick Verification

```sql
-- Connect
mysql -u algorythm_user -palgorythm_password algorythm_db

-- Check tables
SHOW TABLES;

-- Should see: users, songs, artists, albums, playlists, etc.
EXIT;
```

## 🔧 Troubleshooting

### MySQL Command Not Found
- Make sure you added `C:\Program Files\MySQL\MySQL Server 8.4\bin` to PATH
- Restart PowerShell/Terminal

### Port 3306 Already in Use
```powershell
# Find what's using port 3306
netstat -ano | findstr :3306

# Kill the process (replace PID with actual number)
taskkill /PID <PID> /F
```

### Can't Start Service
```powershell
# Check logs
Get-Content "C:\ProgramData\MySQL\MySQL Server 8.4\Data\*.err" -Tail 50
```

### Access Denied
- Make sure you created the user correctly
- Double-check the password (no spaces)
- Verify grants: `SHOW GRANTS FOR 'algorythm_user'@'localhost';`

## 📋 Default Configuration

- **Host:** localhost
- **Port:** 3306
- **Database:** algorythm_db  
- **Username:** algorythm_user
- **Password:** algorythm_password

These are already configured in `backend/Algorythm/src/main/resources/db.properties`
