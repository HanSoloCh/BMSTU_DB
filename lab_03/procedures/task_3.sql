-- Хранимая процедура с курсором
CREATE OR REPLACE PROCEDURE increment_editors_experience()
AS $$
DECLARE
    editor_rec RECORD;
    editor_cursor CURSOR FOR SELECT editor_id, experience FROM editors;
BEGIN
    OPEN editor_cursor;
    LOOP
		-- Извлечь из курсора в запись
        FETCH editor_cursor INTO editor_rec;
        EXIT WHEN NOT FOUND;
		UPDATE editors
		SET experience = experience + 1 WHERE editor_id = editor_rec.editor_id;
    END LOOP;

    CLOSE editor_cursor;
END;
$$ LANGUAGE plpgsql;

CALL increment_editors_experience();
