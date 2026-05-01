from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.schemas.schedule import ScheduleResponse, ScheduleCreate, ScheduleUpdate
from app.crud.schedule import get_schedules, create_schedule, update_schedule, delete_schedule
from app.api.chat import get_db

router = APIRouter()

@router.get("/", response_model=List[ScheduleResponse])
def read_schedules(db: Session = Depends(get_db)):
    return get_schedules(db)

@router.post("/", response_model=ScheduleResponse)
def create_new_schedule(schedule: ScheduleCreate, db: Session = Depends(get_db)):
    return create_schedule(db, schedule)

@router.put("/{schedule_id}", response_model=ScheduleResponse)
def update_existing_schedule(schedule_id: int, schedule: ScheduleUpdate, db: Session = Depends(get_db)):
    db_schedule = update_schedule(db, schedule_id, schedule)
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Schedule not found")
    return db_schedule

@router.delete("/{schedule_id}")
def delete_existing_schedule(schedule_id: int, db: Session = Depends(get_db)):
    db_schedule = delete_schedule(db, schedule_id)
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Schedule not found")
    return {"message": "Schedule deleted successfully"}
