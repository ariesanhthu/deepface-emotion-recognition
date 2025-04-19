FROM python:3.9-slim

#############################
# 1) Install system packages
#############################
# - build-essential, cmake: for any C/C++ extension compilation (e.g. retinaface) :contentReference[oaicite:0]{index=0}  
# - python3-dev: provides Python.h for building wheels :contentReference[oaicite:1]{index=1}  
# - libgl1-mesa-glx, libglib2.0-0: for OpenCV headless support :contentReference[oaicite:2]{index=2}  
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      python3-dev \
      libgl1-mesa-glx \
      libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

#############################
# 2) Create and switch to a non‑root user
#############################
RUN useradd -m -u 1000 user
ENV HOME=/home/user
USER user
WORKDIR $HOME/app

#############################
# 3) Copy requirements & app code
#############################
COPY --chown=user:user requirements.txt app.py ./

#############################
# 4) Upgrade pip & install Python deps
#############################
# Upgrade pip, setuptools, wheel to ensure availability of manylinux wheels :contentReference[oaicite:3]{index=3}  
# Then install all packages from requirements.txt :contentReference[oaicite:4]{index=4}  
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

#############################
# 5) Expose and run
#############################
EXPOSE 7860
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
