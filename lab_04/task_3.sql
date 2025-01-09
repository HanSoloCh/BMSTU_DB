-- Пользовательская табличная функция
CREATE OR REPLACE FUNCTION get_books_by_author(author_id INTEGER)
RETURNS TABLE (
    book_id INTEGER,
    title TEXT
)
AS $$
    result = plpy.execute(f"""
        SELECT b.book_id,
               b.title
		FROM books b
       	JOIN book_author_link bal ON b.book_id = bal.book_id
        JOIN authors a ON bal.author_id = a.author_id
		WHERE a.author_id = {author_id}
    """)
    return result
$$ LANGUAGE plpython3u;


-- Тест
SELECT * FROM get_books_by_author(2);



