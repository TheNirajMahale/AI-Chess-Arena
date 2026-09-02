"""
AI Chess Arena - Backend Launcher Entrypoint
============================================
Runs the FastAPI application on http://localhost:8000 using Uvicorn.
Supports hot reload during development and serves the REST and WebSocket API.
"""

import uvicorn
import os
import sys
from dotenv import load_dotenv

# Ensure backend root directory is included in Python module search path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
load_dotenv()

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="127.0.0.1", port=8000, reload=True)
