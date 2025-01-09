from sqlalchemy.orm import sessionmaker
from models import Authors, Books, Publishers
from sqlalchemy import func

# 1. Список авторов
def get_authors(session):
    data = session.query(Authors.surname, Authors.first_name, Authors.second_name).limit(5).all()
    for row in data:
        print((row.surname, row.first_name, row.second_name))

# 2. Список книг
def get_books(session):
    data = session.query(Books.title, Books.genre, Books.age_rating).limit(5).all()
    for row in data:
        print((row.title, row.genre, row.age_rating))

# 3. Среднее количество страниц в книгах
def get_avg_pages_count(session):
    data = session.query(func.avg(Books.pages).label("avg_pages")).scalar()
    print(f"Среднее количество страниц: {data}")

# 4. Количество книг по жанрам
def get_books_count_by_genre(session):
    data = session.query(
        Books.genre,
        func.count(Books.book_id).label("count")
    ).group_by(Books.genre).all()
    for row in data:
        print((row.genre, row.count))

# 5. Список книг и их аннотации
def get_books_with_annotation(session):
    data = session.query(Books.title, Books.annotation).limit(5).all()
    for row in data:
        print((row.title, row.annotation))
