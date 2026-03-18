"""
FastAPI Notes Sharing Application
"""

import os
import sys
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv('DB_USER', 'root')
DB_PASS = os.getenv('DB_PASS', 'root')
DB_HOST = os.getenv('DB_HOST', '127.0.0.1')
DB_PORT = os.getenv('DB_PORT', '3306')
DB_NAME = os.getenv('DB_NAME', 'notesharingapp_python')

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(
    DATABASE_URL,
    echo=os.getenv('SQLALCHEMY_ECHO', 'False') == 'True',
    pool_size=10,
    max_overflow=20
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        from app.models import Base
        Base.metadata.create_all(bind=engine)
        print("Database tables verified")
    except Exception as e:
        print(f"Database warning: {str(e)[:80]}")
    yield
    print("Application shutdown")

app = FastAPI(
    title="Notes Sharing Application",
    description="Notes Sharing Application with FastAPI",
    version="1.0.0",
    lifespan=lifespan
)

app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")

from app.routers import auth, notes, admin, main

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(notes.router, prefix="/notes", tags=["Notes"])
app.include_router(admin.router, prefix="/admin", tags=["Admin"])
app.include_router(main.router, tags=["Main"])

app.state.templates = templates

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=os.getenv('ENVIRONMENT', 'development') == 'development',
        log_level="info"
    )
