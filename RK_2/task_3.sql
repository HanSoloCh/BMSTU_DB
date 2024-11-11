CREATE OR REPLACE PROCEDURE backup_schema(schema_name TEXT) AS $$
DECLARE
    db_name TEXT := current_database();
    backup_suffix TEXT := db_name || '_' || to_char(current_date, 'YYYYDDMM');
    obj RECORD;
BEGIN
    FOR obj IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = schema_name AND table_type = 'BASE TABLE'
    LOOP
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I.%I_%s AS TABLE %I.%I',
            schema_name, obj.table_name, backup_suffix, schema_name, obj.table_name
        );
    END LOOP;
    
    RAISE NOTICE 'Backup completed';
END;
$$ LANGUAGE plpgsql;

CALL backup_schema('public');



