-- Пример не рабочий, т.к. при большом количестве полей NOT NULL, приходится указывать много полей.
-- Поэтому тут создается представление, хранящее книгу и авторов в качестве массива
-- При добавлении записи в представление она добавляется в БД посредством добавлении соответствующих записей в таблицы

-- Триггер INSTEAD OF
CREATE OR REPLACE VIEW book_authors AS
SELECT 
    b.title AS book_title,
    array_agg(a.surname) AS authors
FROM 
    books b
JOIN 
    book_author_link bal ON b.book_id = bal.book_id
JOIN 
    authors a ON bal.author_id = a.author_id
GROUP BY 
    b.book_id, b.title;


CREATE OR REPLACE FUNCTION insert_book_authors()
RETURNS TRIGGER AS $$
DECLARE
    new_book_id INTEGER;
    author_id INTEGER;
	author TEXT;
BEGIN
    -- Вставляем новую книгу в таблицу books
    INSERT INTO books (title)
    VALUES (NEW.book_title)
    RETURNING book_id INTO new_book_id;

    -- Вставляем авторов из массива authors
    FOREACH author IN ARRAY NEW.authors
    LOOP
        -- Сначала нужно получить author_id, если он уже существует
        INSERT INTO authors (surname)
        VALUES (author)
        ON CONFLICT (surname) DO NOTHING
        RETURNING author_id INTO author_id;

        -- Если author_id не был возвращен (т.е. автор уже существует), получаем его
        IF author_id IS NULL THEN
            SELECT a.author_id INTO author_id 
            FROM authors a 
            WHERE a.surname = author;
        END IF;

        -- Добавляем запись в связывающую таблицу
        INSERT INTO book_author_link (book_id, author_id)
        VALUES (new_book_id, author_id);
    END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER book_authors_insert
INSTEAD OF INSERT ON book_authors
FOR EACH ROW 
EXECUTE FUNCTION insert_book_authors();


INSERT INTO book_authors (book_title, authors)
VALUES ('Новая книга', ARRAY['Иванов', 'Петров']);


-- Удаление триггера
DROP TRIGGER IF EXISTS book_authors_insert ON book_authors;

-- Удаление представления
DROP VIEW IF EXISTS book_authors;

DROP FUNCTION IF EXISTS insert_book_authors;




