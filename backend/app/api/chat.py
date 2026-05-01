from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas.chat import Message, MessageCreate
from app.crud.chat import get_chat_history, create_chat_message
from app.core.database import SessionLocal

router = APIRouter()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/chat", response_model=List[Message])
def read_chat_history(db: Session = Depends(get_db)):
    return get_chat_history(db)

@router.post("/chat", response_model=Message)
def post_new_message(message: MessageCreate, db: Session = Depends(get_db)):
    return create_chat_message(db, message)
