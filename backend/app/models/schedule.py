from sqlalchemy import Column, Integer, String, Date, Time
from app.core.database import Base

class Schedule(Base):
    __tablename__ = "schedules"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    date = Column(Date)
    start_time = Column(Time)
    end_time = Column(Time)
    location = Column(String)
    event_type = Column(String)
