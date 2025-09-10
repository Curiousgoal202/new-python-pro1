FROM python:3.11-slim

WORKDIR /app

# Copy your source code only (no requirements installation here)
COPY . .

# Run FastAPI app with Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
