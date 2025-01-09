-- 4
-- работа с json

-- 4.1
-- извлечь json фрагмент из json документа
SELECT info->'genre' AS genre
FROM editors_json;


-- 4.2
-- извлечь значения кокретных узлов или атрибутов
-- Извлекаем фамилии (surname) и жанры (genre)
SELECT 
    info->>'surname' AS surname,
    info->>'experience' AS experience
FROM editors_json;
     

-- 4.3
-- проверка на существование атрибута
-- Создаем функцию для проверки наличия ключа в JSON-документе
CREATE OR REPLACE FUNCTION is_key(k TEXT, j JSONB)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN j->k IS NOT NULL;
END
$$;

-- Проверяем наличие атрибута "experience" в JSON-документе
SELECT 
    info->>'surname' AS surname,
    is_key('experience', info) AS experience_exists
FROM editors_json;


-- 4.4
-- изменить json документ
UPDATE editors_json
SET info = jsonb_set(info, '{experience}', '20', true)
WHERE info->>'surname' = 'Новиков';

-- Проверяем изменения
SELECT 
    info->>'surname' AS surname,
    info->>'experience' AS experience
FROM editors_json;


-- 4.5
-- разделить json на несколько строк по узлам
CREATE OR REPLACE FUNCTION get_editor_struct(surname TEXT)
RETURNS TABLE
(
    surname TEXT,
    jkey TEXT,
    jvalue TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT 
            info->>'surname', 
            kv.*
        FROM editors_json
        CROSS JOIN LATERAL jsonb_each_text(info) kv
        WHERE info->>'surname' = surname;
END
$$;

-- Пример использования функции
SELECT *
FROM get_editor_struct('Новиков');
