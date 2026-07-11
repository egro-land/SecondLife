from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from .. import models, schemas
from ..auth import create_access_token, hash_password, verify_password
from ..database import get_db

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=schemas.Token)
def register(data: schemas.UserCreate, db: Session = Depends(get_db)):
    email = data.email.lower()

    existing = db.query(models.User).filter(models.User.email == email).first()
    if existing:
        raise HTTPException(
            status_code=400, detail="Пользователь с такой почтой уже существует"
        )

    user = models.User(email=email, hashed_password=hash_password(data.password))
    db.add(user)
    db.commit()
    db.refresh(user)

    # Сразу заводим пустые прогресс и профиль — так /progress и /profile
    # всегда возвращают что-то осмысленное, без отдельной обработки
    # "записи ещё не существует" на каждом эндпоинте.
    db.add(models.Progress(user_id=user.id))
    db.add(models.Profile(user_id=user.id))
    db.commit()

    return schemas.Token(access_token=create_access_token(user.id))


@router.post("/login", response_model=schemas.Token)
def login(data: schemas.UserLogin, db: Session = Depends(get_db)):
    email = data.email.lower()
    user = db.query(models.User).filter(models.User.email == email).first()

    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Неверная почта или пароль")

    return schemas.Token(access_token=create_access_token(user.id))
