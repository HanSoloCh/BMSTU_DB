-- извлечение данных в JSON
CREATE OR REPLACE PROCEDURE backup()
LANGUAGE plpgsql
AS $$
DECLARE
    t text;
    query TEXT;
BEGIN
    FOR t IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
    LOOP
        -- Генерация запроса для COPY
        query := format(
            'COPY (SELECT row_to_json(r) FROM %I AS r) TO ''/var/lib/postgresql/14/main/%s.json''',
            t, t
        );
        RAISE NOTICE 'Executing: %', query; -- Для отладки
        EXECUTE query;
    END LOOP;
END
$$;

-- Вызов процедуры
CALL backup();


