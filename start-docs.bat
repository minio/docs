@echo off
setlocal

echo ==========================================
echo        MinIO Documentation Docker         
echo ==========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Docker is not running. Please start Docker first.
    exit /b 1
)

REM Parse command line arguments
if "%1"=="" goto usage
if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="logs" goto logs
if "%1"=="rebuild" goto rebuild
if "%1"=="restart" goto restart
goto usage

:start
echo 🔨 Building MinIO documentation Docker image...
docker-compose build
if %errorlevel% neq 0 (
    echo ❌ Failed to build the Docker image
    exit /b 1
)

echo ✅ Build completed successfully!
echo.
echo 🚀 Starting MinIO documentation server...
docker-compose up -d
if %errorlevel% neq 0 (
    echo ❌ Failed to start the container
    exit /b 1
)

echo ✅ MinIO documentation is now running!
echo.
echo 📖 Access the documentation at: http://localhost:8000
echo.
echo 🔧 Useful commands:
echo    - Stop:    start-docs.bat stop
echo    - Logs:    start-docs.bat logs
echo    - Rebuild: start-docs.bat rebuild
echo.
goto end

:stop
echo 🛑 Stopping MinIO documentation server...
docker-compose down
echo ✅ MinIO documentation server stopped
goto end

:logs
echo 📋 Showing MinIO documentation logs...
docker-compose logs -f
goto end

:rebuild
echo 🔄 Rebuilding MinIO documentation...
docker-compose down
docker-compose build --no-cache
docker-compose up -d
echo ✅ MinIO documentation rebuilt and restarted
goto end

:restart
call :stop
call :start
goto end

:usage
echo Usage: %0 {start^|stop^|logs^|rebuild^|restart}
echo.
echo Commands:
echo   start    - Build and start the documentation server (default)
echo   stop     - Stop the documentation server
echo   logs     - Show container logs
echo   rebuild  - Rebuild and restart the container
echo   restart  - Stop and start the container
exit /b 1

:end