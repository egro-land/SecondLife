from typing import List, Optional

from pydantic import BaseModel, EmailStr, Field


# --- Авторизация -------------------------------------------------------


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=6)


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


# --- Прогресс ------------------------------------------------------------


class ProgressIn(BaseModel):
    stage: str
    beat_index: int = 0
    page_index: int = 0


class ProgressOut(ProgressIn):
    model_config = {"from_attributes": True}


# --- Профиль персонажа -----------------------------------------------------


class ProfileIn(BaseModel):
    name: Optional[str] = None
    name_mode: Optional[str] = None
    language: Optional[str] = None
    reasons: Optional[List[str]] = None
    interests: Optional[List[str]] = None
    level: Optional[str] = None


class ProfileOut(ProfileIn):
    model_config = {"from_attributes": True}
