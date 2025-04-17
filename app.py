from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from deepface import DeepFace
import uuid
import os

app = FastAPI()

UPLOAD_DIR = "/tmp/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/analyze")
async def analyze_image(file: UploadFile = File(...)):
    # Save uploaded file to disk
    try:
        ext = os.path.splitext(file.filename)[1]
        temp_filename = f"{uuid.uuid4()}{ext}"
        temp_path = os.path.join(UPLOAD_DIR, temp_filename)
        with open(temp_path, "wb") as buffer:
            buffer.write(await file.read())

        # Perform analysis
        analysis = DeepFace.analyze(
            img_path=temp_path,
            detector_backend='dlib',
            align=True,
            actions=['emotion']
        )

        dominant_emotion = analysis.get('dominant_emotion')
        return JSONResponse(content={"dominant_emotion": dominant_emotion})

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        # Cleanup
        if os.path.exists(temp_path):
            os.remove(temp_path)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=7860)