from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Настройки приложения. Значения по умолчанию рассчитаны на запуск
    через docker-compose (см. docker-compose.yml в корне backend/) —
    для продакшена обязательно переопредели SECRET_KEY через .env."""

    database_url: str = "postgresql://postgres:postgres@db:5432/secondlife"
    secret_key: str = "dev-secret-change-me"
    algorithm: str = "HS256"

    # Токен живёт 30 дней — это мобильное приложение, где неудобно
    # разлогинивать игрока каждую неделю. Можно уменьшить, если нужно
    # строже.
    access_token_expire_minutes: int = 60 * 24 * 30

    class Config:
        env_file = ".env"


settings = Settings()
