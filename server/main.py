from collections.abc import Sequence
import logging
import math
import os
from typing import Annotated
from ultralytics import YOLO
from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel
import pathlib

app = FastAPI()

model = YOLO("yolov8x-oiv7.pt")

class YoloResult(BaseModel):
    class_name: str
    confidence: float

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