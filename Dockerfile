# Use Python slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for layer caching)
COPY requirements.txt .

# Install dependencies inside container (needed for uvicorn at runtime)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py .

# Expose port 80
EXPOSE 80

# Start FastAPI with uvicorn
ENTRYPOINT ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
