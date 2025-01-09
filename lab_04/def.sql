CREATE OR REPLACE PROCEDURE calc_median(genre TEXT)
AS $$
result = plpy.execute(f"""
    SELECT 
        COALESCE(EXTRACT(YEAR FROM death_date), EXTRACT(YEAR FROM CURRENT_DATE)) - EXTRACT(YEAR FROM birth_date) AS age
    FROM books b
    JOIN book_author_link bal ON b.book_id = bal.book_id
    JOIN authors a ON bal.author_id = a.author_id
    WHERE b.genre = '{genre}'
""")

ages = [row['age'] for row in result]

if len(ages) == 0:
    plpy.notice(f'Нет данных для жанра: {genre}')
    return

median_age = ages[int(len(ages) / 2)]
plpy.notice(f'{median_age} для жанра {genre}')

$$ LANGUAGE plpython3u;

-- Тест
CALL calc_median('Триллер');
CALL calc_median('Научная фантастика');