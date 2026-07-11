from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from .. import models, schemas
from ..auth import get_current_user
from ..database import get_db

router = APIRouter(prefix="/progress", tags=["progress"])


@router.get("", response_model=schemas.ProgressOut)
def get_progress(
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    progress = (
        db.query(models.Progress)
        .filter(models.Progress.user_id == current_user.id)
        .first()
    )
    if progress is None:
        progress = models.Progress(user_id=current_user.id)
        db.add(progress)
        db.commit()
        db.refresh(progress)
    return progress


@router.put("", response_model=schemas.ProgressOut)
def save_progress(
    data: schemas.ProgressIn,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    progress = (
        db.query(models.Progress)
        .filter(models.Progress.user_id == current_user.id)
        .first()
    )
    if progress is None:
        progress = models.Progress(user_id=current_user.id)
        db.add(progress)

    progress.stage = data.stage
    progress.beat_index = data.beat_index
    progress.page_index = data.page_index
    db.commit()
    db.refresh(progress)
    return progress
