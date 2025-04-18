FROM python:3.9-slim

# 1) Thiết lập WORKDIR và biến môi trường
WORKDIR /app
ENV HOME=/app
ENV DEEPFACE_HOME=/app/.deepface
ENV HF_HOME=/app/hf_home
ENV TRANSFORMERS_CACHE=/app/hf_home/transformers

# 2) Cài hệ thống cho OpenCV
RUN apt-get update && \
    apt-get install -y \
      libgl1-mesa-glx \
      libglib2.0-0 \
      libsm6 libxext6 libxrender-dev && \
    rm -rf /var/lib/apt/lists/*

# 3) Tạo thư mục cache
RUN mkdir -p /app/.deepface /app/hf_home/transformers

# 4) Upgrade pip và cài headless OpenCV
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir opencv-python-headless
RUN pip install --no-cache-dir \
    "tensorflow>=2.16,<2.20" \
    tf-keras

# 5) Cài DeepFace, MTCNN, Pillow
RUN pip install --no-cache-dir deepface mtcnn Pillow

# 6) Copy code và cài dependencies khác
COPY requirements.txt app.py ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
