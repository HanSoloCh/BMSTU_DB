from sqlalchemy.orm import Session, sessionmaker
import eng
from linq_to_sql import *
from linq_to_object import *
from linq_to_json import read_books_json, books_to_json

# Пример вызова функций
if __name__ == "__main__":
    engine = eng.get_db_engine()
    engine.connect()

    session = Session(engine)

    print("=======LINQ to Object=======")

    print("Список авторов:")
    get_authors(session)

    print("\nСписок книг:")
    get_books(session)

    print("\nСреднее количество страниц в книгах:")
    get_avg_pages_count(session)

    print("\nКоличество книг по жанрам:")
    get_books_count_by_genre(session)

    print("\nСписок книг и их аннотации:")
    get_books_with_annotation(session)

    print("=======LINQ to JSON=======")

    books_to_json(session)

    read_books_json()

    print("=======LINQ to SQL=======")

    print("Список авторов:")
    select_authors(session)

    print("\nКниги написанные определенным автором:")
    select_books_by_author(session)

    print("\nДобавление нового автора:")
    insert_author(session)

    print("\nОбновление национальности автора:")
    update_author(session)

    print("\nУдаление автора:")
    delete_author(session)
