-- Храниммая процедура с параметрами
CREATE OR REPLACE PROCEDURE update_age_rating(
	p_book_id INT,
	p_new_rating INT
)
AS $$
BEGIN
	UPDATE books
	SET age_rating = p_new_rating
	WHERE book_id = p_book_id;
END;
$$ LANGUAGE plpgsql;

-- Проверка
SELECT * 
FROM books b
WHERE b.book_id = 100;

CALL update_age_rating(100, 18);
