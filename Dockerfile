FROM python:3.9-slim

# 1) Cài hệ thống (phải là root)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev \
 && rm -rf /var/lib/apt/lists/*

# 2) Tạo user và home directory
RUN useradd -m -u 1000 user

# 3) Thiết lập biến môi trường
ENV HOME=/home/user \
    DEEPFACE_HOME=$HOME \
    HF_HOME=$HOME/hf_home \
    TRANSFORMERS_CACHE=$HF_HOME/transformers

# 4) Tạo thư mục cache và chuyển quyền
RUN mkdir -p $HOME/.deepface $HF_HOME/transformers \
 && chown -R user:user $HOME

# 5) Chuyển sang non-root user
USER user
WORKDIR $HOME/app

# 6) Cài Python packages
COPY --chown=user:user requirements.txt app.py ./
RUN pip install --upgrade pip setuptools wheel \
 && pip install --no-cache-dir -r requirements.txt

EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
