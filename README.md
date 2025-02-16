# FiBot: Financial Assistant AI Assistant

FiBot is a Streamlit-based AI assistant designed for financial data analysis. It allows users to upload PDF documents, converts them into a searchable vector database using FAISS, and leverages retrieval-augmented generation (RAG) with Ollama to answer financial questions based on the document content.

## Features

- **PDF Upload & Processing:**  
  Upload PDF files, convert them to images for preview, and extract text content for analysis.
- **Vector Database:**  
  Create or load a FAISS-based vector store for storing document embeddings.
- **Retrieval-Augmented Generation:**  
  Use document context along with a language model (via Ollama) to generate answers for financial queries.
- **Dockerized Deployment:**  
  Easily deploy the entire application (and the Ollama service) using Docker and Docker Compose for portability.

## Prerequisites

- **Python 3.9+** (for local development)
- **Docker** (for containerized deployment)
- **Poppler** (required by `pdf2image` for processing PDFs; installed via your OS package manager or Docker)

## Installation & Setup

### Local Development

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/fibot.git
   cd fibot
   ```

2. **Create and Activate a Virtual Environment:**

   ```bash
   python -m venv venv
   # Windows:
   venv\Scripts\activate
   # macOS/Linux:
   source venv/bin/activate
   ```

3. **Install Python Dependencies:**

   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

4. **Configure Environment Variables (Optional):**  
   Create a `.env` file or set environment variables (e.g., `OLLAMA_BASE_URL`):

   ```bash
   export OLLAMA_BASE_URL="http://localhost:11437"
   ```

5. **Run the Application:**

   ```bash
   streamlit run app.py
   ```

### Docker Deployment

This project includes a Docker setup for easy deployment.

1. **Build the Docker Image:**

   ```bash
   docker build -t fibot:latest .
   ```

2. **Run the Container:**

   To run the container with a persistent volume for your vector database:

   ```bash
   docker run -p 8501:8501 -v "$(pwd)/local_vector_db":/app/local_vector_db fibot:latest
   ```

   > **Note:**

   - On Windows CMD, use: `%cd%\local_vector_db`
   - On PowerShell, use: `${PWD}\local_vector_db`

3. **Access the App:**  
   Open your browser and navigate to [http://localhost:8501](http://localhost:8501).

### Docker Compose (Optional)

You can also run both the FiBot app and the Ollama service together using Docker Compose. Create a `docker-compose.yml` file in the project root:

```yaml
version: "3.8"
services:
  fibot:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8501:8501"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11437
    depends_on:
      - ollama

  ollama:
    image: ollama:latest
    ports:
      - "11437:11437"
```

Then start the services with:

```bash
docker-compose up
```

## Configuration

- **Streamlit Config:**  
  A default configuration is provided in `.streamlit/config.toml` to disable the file watcher (to avoid Torch-related errors).

- **Ollama Base URL:**  
  The application uses an environment variable `OLLAMA_BASE_URL` (defaulting to `http://localhost:11437`) to connect to the Ollama service. When using Docker Compose with containerized Ollama, it is set to `http://ollama:11437`.

## Troubleshooting

- **ConnectionError to Ollama:**

  - Ensure that Ollama is installed and running.
  - If using Docker, verify that your service’s base URL is correctly set. If not containerized, consider using `host.docker.internal` on Docker Desktop.

- **Timeouts During Dependency Installation:**  
  If you encounter pip timeout errors during the Docker build, try increasing the timeout in your Dockerfile:

  ```dockerfile
  RUN pip install --default-timeout=100 --no-cache-dir -r requirements.txt
  ```

## Acknowledgments

- [Streamlit](https://streamlit.io/)
- [FAISS](https://github.com/facebookresearch/faiss)
- [Ollama](https://ollama.com/)
- [LangChain](https://github.com/hwchase17/langchain)
