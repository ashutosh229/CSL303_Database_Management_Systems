# Lab 8 — Programming Language with DBMS (Solution)

## Contents
- `main.py` — Python script implementing all required tasks (DDL, DML, queries, menu).
- `requirements.txt` — Python dependencies.
- `README.md` — this file.

## Prerequisites
- Docker installed.
- Dockerized PostgreSQL running (example):
```bash
docker pull postgres
docker run --name pg_lab -e POSTGRES_PASSWORD=admin123 -p 5432:5432 -d postgres
