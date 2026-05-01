from fastapi import FastAPI
from app.api.chat import router as chat_router
from app.core.database import engine
from app.models import chat as chat_models

# Initialize database tables
chat_models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="SIROOO AI API")

@app.get("/")
async def root():
    return {"message": "Welcome to SIROOO AI API"}

# Include routers
app.include_router(chat_router, prefix="/api", tags=["chat"])
