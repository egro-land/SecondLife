from sqlalchemy import JSON, Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from .database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    progress = relationship(
        "Progress", back_populates="user", uselist=False, cascade="all, delete-orphan"
    )
    profile = relationship(
        "Profile", back_populates="user", uselist=False, cascade="all, delete-orphan"
    )


class Progress(Base):
    """На каком моменте истории остановился игрок — ровно то же самое,
    что раньше хранилось локально через GameProgress во Flutter."""

    __tablename__ = "progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    # По умолчанию "mainMenu" — у только что зарегистрированного игрока
    # ещё нет прогресса, он должен увидеть главное меню и сам открыть
    # книгу, а не оказаться сразу в середине пролога.
    stage = Column(String, nullable=False, default="mainMenu")
    beat_index = Column(Integer, nullable=False, default=0)
    page_index = Column(Integer, nullable=False, default=0)
    updated_at = Column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    user = relationship("User", back_populates="progress")


class Profile(Base):
    """Данные из регистрации персонажа ("Книга воспоминаний")."""

    __tablename__ = "profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    name = Column(String, nullable=True)
    name_mode = Column(String, nullable=True)
    language = Column(String, nullable=True)
    reasons = Column(JSON, nullable=True)
    interests = Column(JSON, nullable=True)
    level = Column(String, nullable=True)
    updated_at = Column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    user = relationship("User", back_populates="profile")
