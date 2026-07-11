from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from .. import models, schemas
from ..auth import get_current_user
from ..database import get_db

router = APIRouter(prefix="/profile", tags=["profile"])


@router.get("", response_model=schemas.ProfileOut)
def get_profile(
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    profile = (
        db.query(models.Profile)
        .filter(models.Profile.user_id == current_user.id)
        .first()
    )
    if profile is None:
        profile = models.Profile(user_id=current_user.id)
        db.add(profile)
        db.commit()
        db.refresh(profile)
    return profile


@router.put("", response_model=schemas.ProfileOut)
def save_profile(
    data: schemas.ProfileIn,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    profile = (
        db.query(models.Profile)
        .filter(models.Profile.user_id == current_user.id)
        .first()
    )
    if profile is None:
        profile = models.Profile(user_id=current_user.id)
        db.add(profile)

    profile.name = data.name
    profile.name_mode = data.name_mode
    profile.language = data.language
    profile.reasons = data.reasons
    profile.interests = data.interests
    profile.level = data.level
    db.commit()
    db.refresh(profile)
    return profile
