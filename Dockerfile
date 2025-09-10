FROM python:3.11-slim

# Set working directory
WORKDIR /app



# Copy app
COPY app.py .

# Expose port (for documentation purposes)
EXPOSE 80

# Run app with uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
