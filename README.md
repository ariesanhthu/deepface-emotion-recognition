---
title: Deepface Emotion Recognition
emoji: 😻
colorFrom: blue
colorTo: blue
sdk: docker
pinned: false
license: mit
app_file: app.py
app_port: 7860
startup_duration_timeout: 1h
---

# FastAPI + DeepFace Emotion Analyzer

This application uses FastAPI to receive an image upload, runs DeepFace analysis (emotion detection), and returns the dominant emotion as JSON.

## Endpoints

- **POST** `/analyze`
  - Request: multipart/form-data with key `file` containing the image
  - Response: `{ "dominant_emotion": "happy" }`

## Local setup

1. Clone this repo:
   ```bash
   git clone https://your-repo-url.git
   cd fastapi-deepface-space
   ```
2. Build & run locally:
   ```bash
   docker build -t fastapi-deepface .
   docker run -p 7860:7860 fastapi-deepface
   ```
3. Test with `curl`:
   ```bash
   curl -F "file=@/path/to/image.jpg" http://localhost:7860/analyze
   ```

## Deploy to Hugging Face Spaces

1. Create a new Space on Hugging Face:
   - Choose **Custom Space**
   - Select **Docker** as the SDK
2. Push this repository to your new Space's Git URL:
   ```bash
   git remote add hf https://huggingface.co/spaces/your-username/your-space
   git push hf main
   ```
3. Wait for the build to complete.
4. Your API will be available at `https://your-space-name.hf.space/analyze`
