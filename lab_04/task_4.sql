-- Хранимая процедура
CREATE OR REPLACE PROCEDURE find_most_published_author(author_id INT)
AS $$
result = plpy.execute(f"""
    SELECT 
        a.author_id,
        a.surname,
        b.genre,
        COUNT(b.genre) AS book_in_genre_count
    FROM books b
    JOIN book_author_link bal ON b.book_id = bal.book_id
    JOIN authors a ON bal.author_id = a.author_id
    WHERE a.author_id = {author_id}
    GROUP BY b.genre, a.author_id, a.surname
    ORDER BY book_in_genre_count DESC
    LIMIT 1
""")

if len(result) == 0:
    plpy.notice("No publications found.")
else:
    author = result[0]['surname']
    count = result[0]['book_in_genre_count']
    genre = result[0]['genre']
    plpy.notice(f"The author {author} with ID {author_id} wrote most books in {genre} ({count}).")
$$ LANGUAGE plpython3u;

-- Тест
CALL find_most_published_author(2);