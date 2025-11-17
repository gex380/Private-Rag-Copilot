@echo off
echo ========================================
echo  Private RAG Copilot - Development Mode
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ERROR: Please run this script from the project root directory
    pause
    exit /b 1
)

echo [1/3] Starting Backend Server...
echo.
start "RAG Backend" cmd /k "cd backend && python -m venv venv 2>nul && venv\Scripts\activate && pip install -r requirements.txt >nul 2>&1 && echo Backend ready! && python -m app.main"

timeout /t 3 /nobreak >nul

echo [2/3] Starting Frontend Server...
echo.
start "RAG Frontend" cmd /k "cd frontend && npm install >nul 2>&1 && echo Frontend ready! && npm run dev"

timeout /t 5 /nobreak >nul

echo [3/3] Opening in Browser...
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo API Docs: http://localhost:8000/docs
echo.

timeout /t 3 /nobreak >nul
start http://localhost:3000
start http://localhost:8000/docs

echo.
echo ========================================
echo  Servers are running!
echo ========================================
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo API Docs: http://localhost:8000/docs
echo.
echo Press any key to stop all servers...
pause >nul

taskkill /FI "WindowTitle eq RAG Backend*" /T /F
taskkill /FI "WindowTitle eq RAG Frontend*" /T /F

echo.
echo All servers stopped.
pause
