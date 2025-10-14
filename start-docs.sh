#!/bin/bash

# MinIO Documentation Docker Startup Script

echo "=========================================="
echo "       MinIO Documentation Docker         "
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Function to build and start the container
start_docs() {
    echo "🔨 Building MinIO documentation Docker image..."
    docker-compose build
    
    if [ $? -eq 0 ]; then
        echo "✅ Build completed successfully!"
        echo ""
        echo "🚀 Starting MinIO documentation server..."
        docker-compose up -d
        
        if [ $? -eq 0 ]; then
            echo "✅ MinIO documentation is now running!"
            echo ""
            echo "📖 Access the documentation at: http://localhost:8000"
            echo ""
            echo "🔧 Useful commands:"
            echo "   - Stop:    docker-compose down"
            echo "   - Logs:    docker-compose logs -f"
            echo "   - Rebuild: docker-compose build --no-cache"
            echo ""
        else
            echo "❌ Failed to start the container"
            exit 1
        fi
    else
        echo "❌ Failed to build the Docker image"
        exit 1
    fi
}

# Function to stop the container
stop_docs() {
    echo "🛑 Stopping MinIO documentation server..."
    docker-compose down
    echo "✅ MinIO documentation server stopped"
}

# Function to show logs
show_logs() {
    echo "📋 Showing MinIO documentation logs..."
    docker-compose logs -f
}

# Function to rebuild
rebuild_docs() {
    echo "🔄 Rebuilding MinIO documentation..."
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    echo "✅ MinIO documentation rebuilt and restarted"
}

# Parse command line arguments
case "$1" in
    "start"|"")
        start_docs
        ;;
    "stop")
        stop_docs
        ;;
    "logs")
        show_logs
        ;;
    "rebuild")
        rebuild_docs
        ;;
    "restart")
        stop_docs
        start_docs
        ;;
    *)
        echo "Usage: $0 {start|stop|logs|rebuild|restart}"
        echo ""
        echo "Commands:"
        echo "  start    - Build and start the documentation server (default)"
        echo "  stop     - Stop the documentation server"
        echo "  logs     - Show container logs"
        echo "  rebuild  - Rebuild and restart the container"
        echo "  restart  - Stop and start the container"
        exit 1
        ;;
esac