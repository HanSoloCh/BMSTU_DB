from sqlalchemy import create_engine
from models import Base

DATABASE_URL = "postgresql+psycopg2://artem:traban2011@localhost:5432/books_db"  # Новый URL базы данных

def get_db_engine():
    engine = create_engine(DATABASE_URL)

    Base.metadata.create_all(engine)  # Создание всех таблиц на основе моделей
    return engine
