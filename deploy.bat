@echo off
REM ============================================================================
REM AI AUTONOMOUS REPORT GENERATOR - RENDER DEPLOYMENT HELPER (Windows)
REM ============================================================================
REM This script automates common deployment tasks on Windows
REM Usage: deploy.bat [command]

setlocal enabledelayedexpansion

REM Colors (Windows 10+)
for /F %%A in ('echo prompt $H ^| cmd') do set "BS=%%A"
set GREEN=[92m
set BLUE=[94m
set YELLOW=[93m
set RED=[91m
set NC=[0m

goto :main

:print_header
    echo.
    echo %BLUE%================================%NC%
    echo %BLUE%%~1%NC%
    echo %BLUE%================================%NC%
    echo.
    exit /b

:print_success
    echo %GREEN%[OK] %~1%NC%
    exit /b

:print_warning
    echo %YELLOW%[WARN] %~1%NC%
    exit /b

:print_error
    echo %RED%[ERROR] %~1%NC%
    exit /b

:check_git
    call :print_header "Checking Git Configuration"
    
    where git >nul 2>nul
    if errorlevel 1 (
        call :print_error "Git is not installed"
        exit /b 1
    )
    
    if not exist ".git" (
        call :print_error "Not a git repository"
        exit /b 1
    )
    
    call :print_success "Git repository found"
    
    for /f "tokens=*" %%i in ('git config --get remote.origin.url') do (
        call :print_success "Remote: %%i"
    )
    exit /b

:validate_deps
    call :print_header "Validating Dependencies"
    
    where python >nul 2>nul
    if errorlevel 1 (
        call :print_warning "Python not found in PATH"
    ) else (
        for /f "tokens=*" %%i in ('python --version') do (
            call :print_success "%%i found"
        )
    )
    
    where node >nul 2>nul
    if errorlevel 1 (
        call :print_warning "Node.js not found in PATH"
    ) else (
        for /f "tokens=*" %%i in ('node --version') do (
            call :print_success "Node %%i found"
        )
    )
    
    where npm >nul 2>nul
    if errorlevel 1 (
        call :print_warning "npm not found in PATH"
    ) else (
        for /f "tokens=*" %%i in ('npm --version') do (
            call :print_success "npm %%i found"
        )
    )
    exit /b

:test_backend
    call :print_header "Testing Backend Configuration"
    
    if not exist "backend\requirements.txt" (
        call :print_error "requirements.txt not found in backend\"
        exit /b 1
    )
    
    call :print_success "requirements.txt found"
    
    if exist "backend\main.py" (
        call :print_success "main.py found"
    )
    
    if exist "backend\render.yaml" (
        call :print_success "render.yaml found"
    )
    
    exit /b

:test_frontend
    call :print_header "Testing Frontend Configuration"
    
    if not exist "frontend" (
        call :print_warning "Frontend directory not found"
        exit /b 1
    )
    
    if not exist "frontend\package.json" (
        call :print_error "package.json not found in frontend\"
        exit /b 1
    )
    
    call :print_success "package.json found"
    
    if exist "frontend\vite.config.js" (
        call :print_success "vite.config.js found"
    )
    
    exit /b

:show_checklist
    call :print_header "Pre-Deployment Checklist"
    
    echo Before deploying on Render, ensure:
    echo.
    echo [ ] 1. Git repository is up to date
    echo [ ] 2. All changes are committed
    echo [ ] 3. requirements.txt is in backend\
    echo [ ] 4. render.yaml is properly configured
    echo [ ] 5. MongoDB Atlas account created
    echo [ ] 6. Environment variables ready:
    echo       - MONGODB_URI
    echo       - MONGODB_DB_NAME
    echo       - SECRET_KEY
    echo       - CORS_ORIGINS
    echo       - API keys (OPENAI_API_KEY, GROQ_API_KEY, etc.)
    echo.
    exit /b

:show_instructions
    call :print_header "Render Deployment Instructions"
    
    echo.
    echo Step 1: Push Changes to GitHub
    echo   $ git add .
    echo   $ git commit -m "Fix: Update pandas and Python version for Render"
    echo   $ git push origin main
    echo.
    
    echo Step 2: Create Web Service on Render
    echo   1. Go to https://render.com/dashboard
    echo   2. Click 'New +' -^> 'Web Service'
    echo   3. Select your GitHub repository
    echo   4. Configure:
    echo      - Name: autonomous-report-backend
    echo      - Environment: Python
    echo      - Root Directory: backend
    echo      - Build Command: pip install --upgrade pip setuptools wheel ^&^& pip install --no-cache-dir --no-build-isolation -r requirements.txt
    echo      - Start Command: gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT
    echo   5. Add Environment Variables
    echo   6. Click 'Deploy'
    echo.
    
    echo Step 3: Monitor Deployment
    echo   - Check Logs tab for errors
    echo   - Wait for 'Service is live' message
    echo   - Test API: https://your-service-url.onrender.com/docs
    echo.
    
    echo Step 4: Configure Frontend (Optional - Vercel)
    echo   1. Go to https://vercel.com
    echo   2. Import project
    echo   3. Set VITE_API_URL env var
    echo   4. Deploy
    echo.
    exit /b

:main
    if "%~1"=="" (
        goto :show_help
    )
    
    if /i "%~1"=="check" (
        call :check_git
        call :validate_deps
        call :test_backend
        call :test_frontend
        goto :end
    )
    
    if /i "%~1"=="test" (
        call :test_backend
        call :test_frontend
        goto :end
    )
    
    if /i "%~1"=="prepare" (
        call :check_git
        call :validate_deps
        call :show_checklist
        goto :end
    )
    
    if /i "%~1"=="deploy" (
        call :show_instructions
        goto :end
    )
    
    if /i "%~1"=="checklist" (
        call :show_checklist
        goto :end
    )
    
    if /i "%~1"=="help" (
        goto :show_help
    )
    
    call :print_error "Unknown command: %~1"
    echo Run: deploy.bat help
    exit /b 1

:show_help
    call :print_header "Deployment Helper Script (Windows)"
    
    echo.
    echo Commands:
    echo   check      - Validate git and dependencies
    echo   test       - Test backend and frontend
    echo   prepare    - Prepare for deployment
    echo   deploy     - Show deployment instructions
    echo   checklist  - Show pre-deployment checklist
    echo   help       - Show this help message
    echo.
    echo Example:
    echo   ^> deploy.bat check
    echo   ^> deploy.bat prepare
    echo.

:end
    echo.
    call :print_success "Done!"
    endlocal
