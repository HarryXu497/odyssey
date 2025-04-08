from collections.abc import Sequence
import logging
import math
import os
from typing import Annotated
from ultralytics import YOLO
from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel
import pathlib
from openai import OpenAI

from dotenv import load_dotenv

load_dotenv()  # This will load variables from .env file into the environment

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

app = FastAPI()

model = YOLO("yolov8x-oiv7.pt")

class YoloResult(BaseModel):
    class_name: str
    confidence: float

class RecommendationData(BaseModel):
    container_name: str
    items: list[str]
    weather_data: str
    location_data: str
    user_preferences: str

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
    # Build your prompt
    prompt = (
        f"You are a travel recommendation assistant. "
        f"The container is a '{body.container_name}'. "
        f"It already contains: {', '.join(body.items)}. "
        f"Weather: {body.weather_data}. "
        f"Location: {body.location_data}. "
        f"User preferences: {body.user_preferences}. "
        "Please give me a comma-separated list of 4 NEW travel items "
        "that are not already in the container. Make sure they are helpful and useful for our traveler!"
        "Each item can be one word max"
    )

    # Call the Chat API
    response = client.chat.completions.create(model="gpt-4o-mini-2024-07-18",         # or "gpt-4o-mini"
    messages=[
        {"role": "system", "content": "You are a helpful travel assistant."},
        {"role": "user",   "content": prompt}
    ],
    temperature=0.7)

    # Extract and clean up the raw string
    raw = response.choices[0].message.content.strip()

    # Turn it into a real Python list
    recommended_items_list = [
        item.strip() for item in raw.split("'") if item.strip()
    ]

    # FastAPI will serialize this to JSON automatically
    return {
        "container": body.container_name,
        "recommended_items": recommended_items_list,
        "message": "Recommendations processed successfully."
    }
