FROM python:3.9-slim
WORKDIR /app

# 1) System deps
RUN apt-get update && \
    apt-get install -y \
    build-essential cmake pkg-config \
    libx11-dev libgtk-3-dev \
    libboost-all-dev python3-dev \
    libopenblas-dev liblapack-dev && \
    rm -rf /var/lib/apt/lists/*

# 2) Upgrade pip & install Python wheel deps
RUN pip install --upgrade pip setuptools wheel

# 3) Install dlib (binary) + DeepFace
RUN pip install --no-cache-dir --prefer-binary dlib==19.24.6 deepface Pillow

# 4) Install other requirements
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 5) App code
COPY app.py ./

EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
