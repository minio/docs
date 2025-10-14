# MinIO Documentation Docker Image
FROM node:18-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    make \
    git \
    curl \
    pandoc \
    asciidoc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
COPY requirements.txt ./

# Install Node.js dependencies
RUN npm install

# Create Python virtual environment and install dependencies
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Make shell scripts executable
RUN chmod +x *.sh

# Build the documentation (ensure complete Sphinx build)
RUN . venv/bin/activate && \
    npm run build && \
    cp source/default-conf.py source/conf.py && \
    mkdir -p build/master/html && \
    sphinx-build -b html source build/master/html -v -E -a

# Expose port 8000 for the HTTP server
EXPOSE 8000

# Create a startup script
RUN echo '#!/bin/bash\n\
cd /app\n\
. venv/bin/activate\n\
echo "MinIO Documentation is ready!"\n\
echo "Starting HTTP server on port 8000..."\n\
echo "Access the documentation at: http://localhost:8000"\n\
# Check for the correct documentation path\n\
if [ -d "build/master/html" ] && [ -f "build/master/html/index.html" ]; then\n\
    echo "Serving MinIO documentation from build/master/html"\n\
    python3 -m http.server 8000 --directory "build/master/html"\n\
elif [ -d "build/main/mindocs/html" ] && [ -f "build/main/mindocs/html/index.html" ]; then\n\
    echo "Serving MinIO documentation from build/main/mindocs/html"\n\
    python3 -m http.server 8000 --directory "build/main/mindocs/html"\n\
else\n\
    echo "Documentation not found in expected location. Available files:"\n\
    find build -name "*.html" -type f 2>/dev/null | head -5 || echo "No HTML files found"\n\
    echo "Directory structure:"\n\
    ls -la build/ 2>/dev/null || echo "Build directory not found"\n\
    echo "Serving from current directory as fallback"\n\
    python3 -m http.server 8000\n\
fi\n\
' > /app/start.sh && chmod +x /app/start.sh

# Set the startup command
CMD ["/app/start.sh"]