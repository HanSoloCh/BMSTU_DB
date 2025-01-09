from sqlalchemy import select, insert, update, delete, text
from models import Authors, Books, Publishers, Editors, BookAuthorLink, Publications

# 1. Однотабличный запрос на выборку
def select_authors(session):
    res = session.execute(
        select(Authors.first_name, Authors.surname).limit(5)
    )

    for author in res:
        print((author.first_name, author.surname))


# 2. Многотабличный запрос на выборку с использованием ORM
def select_books_by_author(session):
    books = session.query(Books.title, Authors.first_name, Authors.surname).\
        join(BookAuthorLink, Books.book_id == BookAuthorLink.book_id).\
        join(Authors, BookAuthorLink.author_id == Authors.author_id).\
        all()

    for book in books:
        author_name = f"{book.first_name} {book.surname}"
        print(f"{book.title} - {author_name}")


# 3. Добавление, изменение и удаление данных
# Добавление нового автора
def insert_author(session):
    try:
        first_name = input("Имя автора: ")
        surname = input("Фамилия автора: ")
        second_name = input("Отчество автора: ")
        birth_date = input("Дата рождения (YYYY-MM-DD): ")
        nationality = input("Национальность: ")

        session.execute(
            insert(Authors).values(
                first_name=first_name,
                surname=surname,
                second_name=second_name,
                birth_date=birth_date,
                nationality=nationality
            )
        )
        session.commit()
        print("Автор успешно добавлен!")
    except Exception as e:
        print("Ошибка при добавлении автора:", e)

# Обновление информации об авторе
def update_author(session):
    author_id = int(input("ID автора: "))
    new_nationality = input("Новая национальность: ")

    exists = session.query(
        session.query(Authors).filter(Authors.author_id == author_id).exists()
    ).scalar()

    if not exists:
        print("Такого автора нет!")
        return

    session.execute(
        update(Authors).where(Authors.author_id == author_id).values(nationality=new_nationality)
    )
    session.commit()
    print("Национальность автора успешно обновлена!")

# Удаление автора
def delete_author(session):
    author_id = int(input("ID автора для удаления: "))

    exists = session.query(
        session.query(Authors).filter(Authors.author_id == author_id).exists()
    ).scalar()

    if not exists:
        print("Такого автора нет!")
        return

    session.execute(
        delete(Authors).where(Authors.author_id == author_id)
    )
    session.commit()
    print("Автор успешно удалён!")
