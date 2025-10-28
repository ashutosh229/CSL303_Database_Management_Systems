# Lab 8 — PostgreSQL + Python Application Setup Guide

## 🐍 Setting up Python Virtual Environment

```bash
# Create a virtual environment
python -m venv venv

# Activate the environment
# For Windows:
venv\Scripts\activate
# For Linux / macOS:
source venv/bin/activate
```

## 🧰 Installing Dependencies
```bash
# Install all required dependencies
pip install -r requirements.txt
```

## 🐘 Setting up PostgreSQL using Docker
```bash
# Pull the latest PostgreSQL image
docker pull postgres

# Run PostgreSQL container
docker run --name pg_lab8 \
  -e POSTGRES_PASSWORD=Omega1295 \
  -p 5432:5432 \
  -d postgres

# (Optional) Check container status
docker ps

# (Optional) Connect to the PostgreSQL container
docker exec -it pg_lab8 psql -U postgres
```
## ⚙️ Creating the .env File
```bash 
# Create a file named .env in the root directory of your project and add the following:  
HOST=localhost
PORT=5432
DB_NAME=studentdb
DB_USER=postgres
DB_PASSWORD=Omega1295
```  

## 🚀 Running the Application  
```bash  
# Activate virtual environment (if not already active)
# For Windows:
venv\Scripts\activate
# For Linux / macOS:
source venv/bin/activate

# Run the Python application
python main.py
```

