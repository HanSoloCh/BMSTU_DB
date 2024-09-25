import csv
from faker import Faker
import random
import datetime

BOOKSNUM = 1000

DATADIR = 'data/'

BOOK_FILE = DATADIR + 'books.csv'
AUTHOR_FILE = DATADIR + 'authors.csv'
EDITOR_FILE = DATADIR + 'editors.csv'
PUBLISHER_FILE = DATADIR + 'publishers.csv'
PUBLICATION_FILE = DATADIR + 'publications.csv'
LINK_AUTHOR_BOOK_TABLE = DATADIR + 'book_author_link.csv'

GENRES = ["Фэнтези", "Научная фантастика", "Романтика", "Триллер", "Нон-фикшн", "Исторический"]
AGE_RATINGS = [0, 6, 12, 16, 18]


def generate_books(faker, editors_dict):
    books_set = set()
    while len(books_set) < BOOKSNUM:
        books_set.add(faker.sentence(nb_words=4))

    with open(BOOK_FILE, 'w', newline='') as file:
        writer = csv.writer(file, delimiter=';')

        for i in range(1, BOOKSNUM + 1):
            book_title = books_set.pop()
            genre = random.choice(GENRES)
            age_rating = random.choice(AGE_RATINGS)
            pages = random.randint(100, 1000)
            annotation = faker.paragraph(nb_sentences=3)

            writer.writerow(
                [
                    i,
                    book_title,
                    genre,
                    age_rating,
                    pages,
                    annotation
                ]
            )
            editors_lst = editors_dict.get(genre, [])
            if not editors_lst:
                genre_with_most_editors = sorted(editors_dict.items(), key=lambda x: len(x[1]), reverse=True)
                editors_lst = genre_with_most_editors[0][1]

            generate_publications(faker, i, editors_lst)
            generate_author_book_link_table(i)


def generate_second_name(first_name, gender):
    if gender == 'male':
        return first_name + "ович" if first_name[-1] not in "ий" else first_name[:-1] + "евич"
    else:
        return first_name + "овна" if first_name[-1] not in "ий" else first_name[:-1] + "евна"


def generate_authors(faker):
    with open(AUTHOR_FILE, 'w', newline='') as file:
        writer = csv.writer(file, delimiter=';')

        for i in range(1, BOOKSNUM + 1):
            gender = random.choice(['male', 'female'])
            first_name = faker.first_name_male() if gender == 'male' else faker.first_name_female()
            surname_name = faker.last_name_male() if gender == 'male' else faker.last_name_female()
            second_name = generate_second_name(faker.first_name_male(), gender)

            birth_date = faker.date_between(start_date=datetime.date(1900, 1, 1), end_date=datetime.date(2023, 1, 1))
            death_date = faker.date_between(start_date=birth_date + datetime.timedelta(days=1)) if random.choice(
                [True, False]) else None

            nationality = faker.country_code()

            writer.writerow(
                [
                    i,
                    surname_name,
                    first_name,
                    second_name,
                    birth_date,
                    death_date,
                    nationality,
                ]
            )


def generate_editors(faker):
    editors_dict = {genre: [] for genre in GENRES}

    with open(EDITOR_FILE, 'w', newline='') as file:
        writer = csv.writer(file, delimiter=';')

        for i in range(1, BOOKSNUM + 1):
            gender = random.choice(['male', 'female'])
            first_name = faker.first_name_male() if gender == 'male' else faker.first_name_female()
            surname_name = faker.last_name_male() if gender == 'male' else faker.last_name_female()
            second_name = generate_second_name(faker.first_name_male(), gender)

            experience = random.randint(1, 40)
            genre = random.choice(GENRES)

            writer.writerow(
                [
                    i,
                    surname_name,
                    first_name,
                    second_name,
                    experience,
                    genre,
                ]
            )

            editors_dict[genre].append(i)
    return editors_dict


def generate_publishers(faker):
    with open(PUBLISHER_FILE, 'w', newline='') as file:
        publishers_set = set()
        while len(publishers_set) < BOOKSNUM:
            publishers_set.add(faker.company())

        writer = csv.writer(file, delimiter=';')

        for i in range(1, BOOKSNUM + 1):
            publisher_name = publishers_set.pop()
            phone_number = faker.phone_number()
            country = faker.country()
            foundation_date = faker.date_between(start_date=datetime.date(1900, 1, 1), end_date=datetime.date(2023, 1, 1))
            address = faker.address()

            writer.writerow(
                [
                    i,
                    publisher_name,
                    phone_number,
                    country,
                    foundation_date,
                    address,
                ]
            )


def generate_publications(faker, book_id, editors_lst):
    with open(PUBLICATION_FILE, 'a', newline='') as f:
        writer = csv.writer(f, delimiter=';')
        publications_num = random.randint(1, 3)

        for _ in range(publications_num):
            writer.writerow(
                [
                    book_id,
                    random.choice(editors_lst),
                    random.randint(1, BOOKSNUM),
                    faker.date_between(
                        start_date=datetime.date(1900, 1, 1),
                        end_date=datetime.date(2023, 1, 1)
                    ),
                    random.randint(1, 1_000) * 100
                ]
            )


def generate_author_book_link_table(book_id):
    with open(LINK_AUTHOR_BOOK_TABLE, 'a', newline='') as f:
        writer = csv.writer(f, delimiter=';')
        authors_id = random.sample(range(1, BOOKSNUM + 1), random.randint(1, 3))
        for i in authors_id:
            writer.writerow(
                [
                    book_id,
                    i
                ]
            )


if __name__ == '__main__':
    faker = Faker('ru_RU')
    editors_dict = generate_editors(faker)
    generate_books(faker, editors_dict)
    generate_authors(faker)
    generate_publishers(faker)
