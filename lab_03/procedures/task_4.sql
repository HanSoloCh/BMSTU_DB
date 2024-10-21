-- Хранимая процедура для доступа к метаданным
CREATE OR REPLACE PROCEDURE get_table_metadata()
LANGUAGE plpgsql
AS $$
DECLARE
    row RECORD;
BEGIN
    -- Выводим список всех таблиц, их схем и владельцев
    FOR row IN 
        SELECT table_schema, table_name, table_type
        FROM information_schema.tables
        WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
    LOOP
        RAISE NOTICE 'Schema: %, Table: %, Type: %', row.table_schema, row.table_name, row.table_type;
    END LOOP;
END;
$$;

CALL get_table_metadata();
