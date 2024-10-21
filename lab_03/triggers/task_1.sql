-- Триггер BEFORE
CREATE OR REPLACE FUNCTION set_max_rating()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.age_rating > 18 THEN
		NEW.age_rating := 18;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_book_insert
BEFORE INSERT ON books
FOR EACH ROW
EXECUTE FUNCTION set_max_rating();

-- Тест и проверки
INSERT INTO books(title, genre, age_rating, pages, annotation)
VALUES('Птицы', 'Фентези', 20, 600, 'Крутая книга');

DELETE FROM books b
WHERE b.title = 'Птицы';

SELECT *
FROM books b
WHERE b.title = 'Птицы';
