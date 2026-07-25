@echo off
echo ========================================
echo   HireEra End-to-End Upload Test
echo ========================================
echo.

REM Step 1: Login
echo [1/3] Logging in as seeker@hireera.com...
curl -s -X POST "http://localhost:4000/api/auth/login" -H "Content-Type: application/json" -d "{\"email\":\"seeker@hireera.com\",\"password\":\"password123\"}" -o login_response.json
echo Login response:
type login_response.json
echo.
echo.

REM Step 2: Extract token
for /f "delims=" %%i in ('node -e "const d=require('./login_response.json');console.log(d.data.accessToken)"') do set TOKEN=%%i
echo [2/3] Token extracted: %TOKEN:~0,40%...
echo.

REM Step 3: Test profile fetch (the route the frontend uses)
echo [3a] Testing GET /api/seekers/me/profile...
curl -s "http://localhost:4000/api/seekers/me/profile" -H "Authorization: Bearer %TOKEN%" | node -e "process.stdin.on('data',d=>{const j=JSON.parse(d);console.log('  Profile fetch:',j.success?'SUCCESS':'FAIL',j.data?.headline||j.message)})"
echo.

REM Step 4: Upload avatar
echo [3b] Uploading avatar to /api/profile/me/avatar...
curl -s -X POST "http://localhost:4000/api/profile/me/avatar" -H "Authorization: Bearer %TOKEN%" -F "avatar=@dummy.png;type=image/png"
echo.
echo.

REM Step 5: Upload via seekers route too
echo [3c] Uploading avatar to /api/seekers/me/avatar...
curl -s -X POST "http://localhost:4000/api/seekers/me/avatar" -H "Authorization: Bearer %TOKEN%" -F "avatar=@dummy.png;type=image/png"
echo.
echo.

echo ========================================
echo   Done!
echo ========================================

REM Cleanup
del login_response.json 2>nul
