-- Определяемая  пользователем скалярная функция
CREATE OR REPLACE FUNCTION get_age(birth DATE)
RETURNS INT
LANGUAGE plpgsql
AS $$
BEGIN
  -- Вычисляем возраст, используя текущую дату как дату смерти
  RETURN EXTRACT(YEAR FROM age(CURRENT_DATE, birth));
END;
$$;

-- Тест
SELECT 
	author_id,
	birth_date,
	get_age(birth_date) as age
FROM authors;