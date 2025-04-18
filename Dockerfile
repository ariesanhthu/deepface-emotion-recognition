FROM python:3.9-slim


WORKDIR /app

# 1) Upgrade pip, wheel, setuptools so pip can fetch manylinux wheels
RUN pip install --upgrade pip setuptools wheel
# 2) Install dlib from prebuilt binaries
RUN pip install --no-cache-dir \
    --prefer-binary \
    dlib==19.24.0 \
    deepface \
    Pillow

# Install system dependencies for dlib (if needed)
RUN apt-get update && \
    apt-get install -y build-essential cmake libopenblas-dev liblapack-dev libx11-dev libgtk-3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py ./

# Expose port for Hugging Face Spaces
EXPOSE 7860

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
