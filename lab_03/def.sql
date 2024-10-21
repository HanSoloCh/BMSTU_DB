-- Защита (реализовать функция, которая по заданному id редактора, 
-- возвращает всех авторов, с книгами которых редактор работал) без JOIN 

CREATE OR REPLACE FUNCTION get_editors_authors(p_editors_id INT)
RETURNS TABLE (
	author_id INT,
	first_name TEXT,
	surname TEXT
) AS $$
BEGIN
	RETURN QUERY
	SELECT
		a.author_id,
		a.first_name,
		a.surname
    FROM 
        authors a
    WHERE a.author_id IN (
		SELECT bal.author_id
		FROM book_author_link bal
		WHERE bal.book_id IN (
			SELECT b.book_id
			FROM books b
			WHERE b.book_id IN (
				SELECT p.book_id
				FROM publications p
				WHERE p.editor_id = get_editors_authors.p_editors_id
			)
		)
	);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_editors_authors(7);
