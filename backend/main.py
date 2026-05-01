from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel
from datetime import datetime

import models, database

# Initialize database tables
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

# Pydantic models for request/response
class MessageBase(BaseModel):
    sender: str
    content: str

class MessageCreate(MessageBase):
    pass

class Message(MessageBase):
    id: int
    timestamp: datetime

    class Config:
        from_attributes = True

# Dependency to get DB session
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
async def root():
    return {"message": "Welcome to SIROOO AI API"}

@app.get("/api/chat", response_model=List[Message])
def get_chat_history(db: Session = Depends(get_db)):
    messages = db.query(models.ChatMessage).order_by(models.ChatMessage.timestamp.asc()).all()
    return messages

@app.post("/api/chat", response_model=Message)
def post_message(message: MessageCreate, db: Session = Depends(get_db)):
    db_message = models.ChatMessage(sender=message.sender, content=message.content)
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    
    # Simple AI Response logic (just echoing for now)
    if message.sender == "user":
        ai_response = models.ChatMessage(
            sender="ai", 
            content=f"SIROOO AI received: {message.content}"
        )
        db.add(ai_response)
        db.commit()
    
    return db_message
