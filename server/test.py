import requests

res = requests.post(
    "http://127.0.0.1:8000/get-items-from-image/",
    files={
        "file": ("backpack.jpg", open("backpack.jpg", "rb"), "image/jpeg"),
    },
)

print(res.json())