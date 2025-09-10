FROM python:3.11-slim

WORKDIR /app

# Copy app and requirements
COPY app.py requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

# Start FastAPI on port 80
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
