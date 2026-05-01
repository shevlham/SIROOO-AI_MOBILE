from pydantic import BaseModel
import datetime
from typing import Optional

class ScheduleBase(BaseModel):
    name: str
    date: datetime.date
    start_time: datetime.time
    end_time: datetime.time
    location: str
    event_type: str

class ScheduleCreate(ScheduleBase):
    pass

class ScheduleUpdate(BaseModel):
    name: str | None = None
    date: datetime.date | None = None
    start_time: datetime.time | None = None
    end_time: datetime.time | None = None
    location: str | None = None
    event_type: str | None = None

class ScheduleResponse(ScheduleBase):
    id: int

    class Config:
        from_attributes = True
