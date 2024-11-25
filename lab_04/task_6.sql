-- Пользовательский тип данных
CREATE TYPE book_author_info AS (
    author_name TEXT,
    book_title TEXT,
    genre TEXT,
	annotation TEXT
);

CREATE OR REPLACE FUNCTION get_books_info_by_author(author_id INT)
RETURNS SETOF book_author_info
AS $$
    query = f"""
        SELECT 
            a.surname AS author_name,
            b.title AS book_title,
            b.genre,
            b.annotation
        FROM books b
        JOIN book_author_link bal ON b.book_id = bal.book_id
        JOIN authors a ON bal.author_id = a.author_id
        WHERE a.author_id = {author_id}
    """
    result = plpy.execute(query)
    return result
$$ LANGUAGE plpython3u;

-- Тест
SELECT * FROM get_books_info_by_author(2);
