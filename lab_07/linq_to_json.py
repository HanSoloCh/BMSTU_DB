import os
from sqlalchemy.orm import class_mapper
from json import dumps, load

from models import Books, Authors

# Сериализация книги
def serialize_all(model):
    columns = [c.key for c in class_mapper(model.__class__).columns]
    return dict((c, getattr(model, c)) for c in columns)

# Сохранение книг в JSON
def books_to_json(session):
    serialized_books = [
        serialize_all(book)
        for book in session.query(Books).order_by(Books.book_id).all()
    ]

    with open('books.json', 'w', encoding='utf-8') as f:
        f.write(dumps(serialized_books, indent=4, ensure_ascii=False))
    print("Данные книг записаны в books.json")

def read_books_json(book_cnt=10):
    with open('books.json', 'r', encoding='utf-8') as f:
        books = load(f)

    for i in range(0, book_cnt):
        print(books[i])
