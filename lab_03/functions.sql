-- Скалярная функция
CREATE OR REPLACE FUNCTION get_author_publication_count(p_author_id INT)
RETURNS INT
AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM book_author_link
        WHERE author_id = p_author_id
    );
END;
$$ LANGUAGE plpgsql;


SELECT get_author_publication_count(2) as publication_count;

-- Подставляемая табличная функция
CREATE OR REPLACE FUNCTION get_author_books(p_author_id INT)
RETURNS TABLE (
	book_id INT,
	title TEXT,
	publication_date DATE,
	publisher_id INT,
	editor_id INT
) AS $$
BEGIN
	RETURN QUERY
	SELECT
		b.book_id,
		b.title,
		p.publication_date,
		p.publisher_id,
		p.editor_id
    FROM 
        books b
    JOIN 
        book_author_link bal ON b.book_id = bal.book_id
    JOIN 
        publications p ON p.book_id = b.book_id
    WHERE 
        bal.author_id = p_author_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_author_books(1);


-- Многооператорная функция
CREATE OR REPLACE FUNCTION get_author_books_with_check(p_author_id INT)
RETURNS TABLE (
    book_id INT,
    title TEXT,
    publication_date DATE,
    publisher_id INT
) AS $$
BEGIN
    -- Проверка на наличие книг у автора
    IF NOT EXISTS (
        SELECT 1
        FROM book_author_link bal
        WHERE bal.author_id = p_author_id
    ) THEN
        RAISE NOTICE 'Author with ID % does not have any books.', p_author_id;
        RETURN;
    END IF;

    -- Если книги есть, вернуть их
    RETURN QUERY
    SELECT 
        b.book_id,
        b.title,
        p.publication_date,
        p.publisher_id
    FROM 
        books b
    JOIN 
        book_author_link bal ON b.book_id = bal.book_id
    JOIN 
        publications p ON p.book_id = b.book_id
    WHERE 
        bal.author_id = p_author_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_author_books_with_check(0);

-- Рекурсивная функция
CREATE OR REPLACE FUNCTION fibonacci_func(n INT) 
RETURNS INT AS $$
BEGIN
    IF n = 0 THEN
        RETURN 0;
    ELSIF n = 1 THEN
        RETURN 1;
    ELSE
        RETURN fibonacci_func(n - 1) + fibonacci_func(n - 2);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Тест
SELECT * from fibonacci_func(4);