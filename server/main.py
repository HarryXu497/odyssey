from collections.abc import Sequence
import logging
import math
import os
from typing import Annotated
from ultralytics import YOLO
from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel
import pathlib
import openai

from dotenv import load_dotenv

load_dotenv()  # This will load variables from .env file into the environment
openai.api_key = os.getenv("OPENAI_API_KEY")

app = FastAPI()

model = YOLO("yolov8x-oiv7.pt")

class YoloResult(BaseModel):
    class_name: str
    confidence: float

class RecommendationData(BaseModel):
    container_name: str
    items: list[str]

logger = logging.getLogger('uvicorn.error')
logger.setLevel(logging.DEBUG)

@app.post("/get-items-from-image/")
async def process_image(file: UploadFile):
    logger.debug(file.content_type)

    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image file")
    
    try: 
        contents = file.file.read()

        path_name = os.path.join(os.getcwd(), "uploads", file.filename)
        logger.debug(path_name)
    
        with open(path_name, 'wb+') as f:
            f.write(contents)
    except Exception:
        raise HTTPException(status_code=500, detail='Something went wrong')
    finally:
        file.file.close()
    
    try:
        results = model(path_name, stream=True)

        items: Sequence[YoloResult] = []

        for r in results:
            boxes = r.boxes

            for box in boxes:
                confidence = math.ceil((box.conf[0] * 100)) / 100

                # class name
                image_class = int(box.cls[0])
                class_name = model.names[image_class]

                items.append(
                    YoloResult(class_name=class_name, confidence=confidence)
                )
    except Exception:
        raise HTTPException(status_code=500, detail='Something went wrong')
    finally:
        try:
            os.remove(path_name)
        except Exception:
            raise HTTPException(status_code=500, detail='Something went wrong') 
    


    return { "items": items }

@app.post("/recommend/")
async def recommend(body: RecommendationData):
    logger.debug(f"Container Name: {body.container_name}")
    logger.debug(f"Items: {body.items}")

    # Create a prompt for ChatGPT based on the input data
    prompt = (
        f"You are a travel recommendation assistant. "
        f"Given the container name '{body.container_name}' and these items: {', '.join(body.items)}, "
        "what additional travel recommendations can you suggest?"
    )
    
    try:
        # Call ChatGPT's API using the openai library
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful travel assistant."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
        )
        
        # Safely extract the content from the response
        received_items = response.choices[0].message.content.strip()
    except Exception as e:
        logger.error(f"ChatGPT API error: {e}")
        raise HTTPException(status_code=500, detail="ChatGPT request failed")

    response =  {
        "container": body.container_name,
        "received_items": received_items,
        "message": "Recommendations processed successfully."
    }
    return response