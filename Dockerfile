FROM python:3.9-slim

# --- 1) Tạo user không phải root theo Guidelines của Spaces
RUN useradd -m -u 1000 user
USER user

# --- 2) Thiết lập HOME và WORKDIR
ENV HOME=/home/user
WORKDIR $HOME/app

# --- 3) Cấu hình DeepFace và HF cache
ENV DEEPFACE_HOME=$HOME
ENV HF_HOME=$HOME/hf_home
ENV TRANSFORMERS_CACHE=$HF_HOME/transformers

# --- 4) Cài hệ thống cho OpenCV
RUN apt-get update && \
    apt-get install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev && \
    rm -rf /var/lib/apt/lists/*

# --- 5) Tạo thư mục lưu weights và cache
RUN mkdir -p $HOME/.deepface $HF_HOME/transformers

# --- 6) Upgrade pip và cài thư viện
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir \
    opencv-python-headless \
    "tensorflow>=2.16,<2.20" tf-keras \
    deepface mtcnn Pillow

# --- 7) Copy code với quyền user và install dependencies
COPY --chown=user:user ./requirements.txt ./app.py ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
