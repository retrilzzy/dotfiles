"""
A simple Chibisafe file uploader that uses the Chibisafe API and API key to upload files.

It is designed for Linux distros running Wayland (I use Arch Linux + Hyprland).

If it doesn't work on your system, check the commands in the functions:
`send_notification()` and `copy_to_clipboard()`

Usage:
    chibisafe_uploader.py [-h] file_path

Positional arguments:
    file_path   Full path to the file to upload

Options:
    -h, --help  show this help message and exit
"""

import os
import mimetypes
import requests
import dotenv
import logging
import argparse


logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

dotenv.load_dotenv()


def send_notification(message: str) -> None:
    os.system(f'notify-send "ChibisafeUploader" "{message}" -t 3000')

def copy_to_clipboard(url: str) -> None:
    os.system(f'echo "{url}" | wl-copy')


def upload_file(file_path: str) -> None:
    """
    Upload a file to Chibisafe API.
    """
    if not os.path.exists(file_path):
        logger.error(f"Error. File {file_path} not found.")
        send_notification(f"❌ File {file_path} not found.")
        return


    file_name = os.path.basename(file_path)
    mime_type, _ = mimetypes.guess_type(file_path)

    try:
        response = requests.post(
            url=f"{os.getenv("CHIBISAFE_URL")}/api/upload",
            
            headers={
                "x-api-key": os.getenv("CHIBISAFE_API_KEY"),
                "user-agent": "Mozilla/5.0 Chrome/131.0.0.0 Safari/537.36",
            },
            
            files={
                "file": (file_name, open(file_path, "rb"), mime_type or "application/octet-stream"),
            },
        )
        response.raise_for_status()
        logger.info(f"Successful. API response: {response.json()}")
        
        send_notification("✅ File uploaded successfully")
        copy_to_clipboard(response.json()["url"])
    
    except requests.exceptions.RequestException as e:
        logger.error(f"Error occurred while uploading file.\n{e}")
        send_notification(f"❌ Error occurred while uploading file.\n{e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="A simple Chibisafe file uploader that uses the Chibisafe API to upload files."
    )
    parser.add_argument("file_path", help="Full path to the file to upload")
    args = parser.parse_args()

    upload_file(args.file_path)
