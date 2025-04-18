FROM python:3.9-slim
WORKDIR /app

# 1) Cài hệ thống cho OpenCV
RUN apt-get update && \
    apt-get install -y \
      libgl1-mesa-glx \
      libglib2.0-0 \
      libsm6 libxext6 libxrender-dev && \
    rm -rf /var/lib/apt/lists/*

# 2) Upgrade pip và cài headless OpenCV
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir opencv-python-headless
RUN pip install --no-cache-dir \
    "tensorflow>=2.16,<2.20" \
    tf-keras
# 3) Cài DeepFace, MTCNN, Pillow
RUN pip install --no-cache-dir deepface mtcnn Pillow

# 4) Copy code và chạy app
COPY app.py requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
