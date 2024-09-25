DROP DATABASE IF EXISTS books_db;
CREATE DATABASE books_db;

CREATE TABLE IF NOT EXISTS authors (
    author_id SERIAL PRIMARY KEY,
    surname TEXT,
    first_name TEXT,
    second_name TEXT,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS editors (
    editor_id SERIAL PRIMARY KEY,
    surname TEXT,
    first_name TEXT,
    second_name TEXT,
    experience INT,
    genre TEXT
);

CREATE TABLE IF NOT EXISTS publishers (
    publisher_id SERIAL PRIMARY KEY,
    name TEXT,
    phone VARCHAR(30),
    country TEXT,
    foundation_date DATE,
    address TEXT
);

CREATE TABLE IF NOT EXISTS books (
    book_id SERIAL PRIMARY KEY,
    title TEXT,
    genre TEXT,
    age_rating INT,
    pages INT,
    annotation TEXT
);

CREATE TABLE IF NOT EXISTS book_author_link (
    author_id INT REFERENCES authors(author_id),
    book_id INT REFERENCES books(book_id)
);

CREATE TABLE IF NOT EXISTS publications (
    book_id INT REFERENCES books(book_id),
    publisher_id INT REFERENCES publishers(publisher_id),
    editor_id INT REFERENCES editors(editor_id),
    publication_date DATE,
    circulation INT
);