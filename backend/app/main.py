from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .database import Base, engine
from .routers import auth, profile, progress

# Создаёт таблицы при старте, если их ещё нет. Для маленького проекта
# этого достаточно; когда схема БД станет сложнее и начнёт меняться —
# стоит перейти на Alembic-миграции вместо create_all.
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Вторая жизнь — API")

app.add_middleware(
    CORSMiddleware,
    # TODO: перед продакшеном сузить до конкретных источников —
    # "*" ок только для разработки.
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(progress.router)
app.include_router(profile.router)


@app.get("/health")
def health():
    return {"status": "ok"}
