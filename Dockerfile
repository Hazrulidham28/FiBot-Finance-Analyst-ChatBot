# Use an official Python runtime as a base image
FROM python:3.9-slim

# Install system packages (poppler-utils is needed by pdf2image)
RUN apt-get update && apt-get install -y --no-install-recommends \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt /app/

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install Python dependencies with an increased timeout
RUN pip install --default-timeout=100 --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . /app

# Create a .streamlit configuration directory and file to disable file watcher by default
RUN mkdir -p /app/.streamlit
RUN echo "[server]\nfileWatcherType = \"none\"" > /app/.streamlit/config.toml

# Expose the port on which Streamlit runs
EXPOSE 8501

# Define the command to run your Streamlit app
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
