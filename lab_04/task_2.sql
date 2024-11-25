-- Пользовательская агрегатная функция
CREATE OR REPLACE FUNCTION count_books_step(state BIGINT, genre VARCHAR)
RETURNS BIGINT
AS $$
    return state + 1
$$ LANGUAGE plpython3u;

CREATE OR REPLACE AGGREGATE count_books_by_genre(VARCHAR) (
    SFUNC = count_books_step,
    STYPE = BIGINT,
    INITCOND = '0'
);

-- Тест
SELECT genre, count_books_by_genre(genre) AS total_books
FROM books
GROUP BY genre;
