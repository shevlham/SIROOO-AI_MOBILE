from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime
from database import Base

class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(Integer, primary_key=True, index=True)
    sender = Column(String)  # 'user' or 'ai'
    content = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
