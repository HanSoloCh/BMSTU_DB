import eng
from sqlalchemy import text
from sqlalchemy.orm import sessionmaker


# Пример функции, которая получает количество книг по авторам
def count_books_by_author(session):
    query = text("""
        SELECT a.first_name || ' ' || a.surname AS author_name, COUNT(*) AS book_count
        FROM books b
        JOIN book_author_link bal ON b.book_id = bal.book_id
        JOIN authors a ON bal.author_id = a.author_id
        GROUP BY a.author_id
    """)

    result = session.execute(query)
    return [(row[0], row[1]) for row in result]


# Подключение к базе данных
engine = eng.get_db_engine()
Session = sessionmaker(bind=engine)
session = Session()

# Получение количества книг для каждого автора
books_by_author = count_books_by_author(session)

for author_name, book_count in books_by_author:
    print(f"Автор: {author_name}, Количество книг: {book_count}")
