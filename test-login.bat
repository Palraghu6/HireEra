@echo off
curl -s -X POST "http://localhost:4000/api/auth/login" -H "Content-Type: application/json" -d "{\"email\":\"seeker@hireera.com\",\"password\":\"password123\"}"
