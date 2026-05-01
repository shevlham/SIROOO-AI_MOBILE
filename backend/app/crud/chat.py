from sqlalchemy.orm import Session
from app.models.chat import ChatMessage
from app.schemas.chat import MessageCreate

def get_chat_history(db: Session):
    return db.query(ChatMessage).order_by(ChatMessage.timestamp.asc()).all()

def create_chat_message(db: Session, message: MessageCreate):
    db_message = ChatMessage(sender=message.sender, content=message.content)
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    
    # Simple AI Response logic
    if message.sender == "user":
        ai_response = ChatMessage(
            sender="ai", 
            content=f"SIROOO AI received: {message.content}"
        )
        db.add(ai_response)
        db.commit()
        
    return db_message
