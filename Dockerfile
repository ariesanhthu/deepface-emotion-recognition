FROM python:3.9-slim

WORKDIR /app

# Install system dependencies for MTCNN (TensorFlow runtime)
RUN apt-get update && \
    apt-get install -y libglib2.0-0 libsm6 libxext6 libxrender-dev && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir \
    fastapi uvicorn[standard] \
    deepface mtcnn Pillow

# Copy application files
COPY app.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Expose port for Hugging Face Spaces
EXPOSE 7860

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
