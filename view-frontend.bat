@echo off
echo ========================================
echo  Private RAG Copilot - Frontend Preview
echo ========================================
echo.
echo Installing dependencies (this may take a minute)...
cd frontend
call npm install

echo.
echo Starting development server...
echo.
echo Opening browser in 5 seconds...
start "" cmd /k "npm run dev"

timeout /t 5 /nobreak >nul
start http://localhost:3000

echo.
echo ========================================
echo  Frontend is running!
echo ========================================
echo.
echo URL: http://localhost:3000
echo.
echo Press Ctrl+C in the server window to stop
echo.
pause
