-- Триггер
CREATE OR REPLACE FUNCTION log_author_status_change()
RETURNS TRIGGER
AS $$
if TD['old']['death_date'] is None and TD['new']['death_date'] is not None:
    plpy.notice(f"Author ID {TD['new']['author_id']} rest in peace.")
$$ LANGUAGE plpython3u;

CREATE OR REPLACE TRIGGER trigger_log_author_status_change
BEFORE UPDATE ON authors
FOR EACH ROW
WHEN (OLD.death_date IS DISTINCT FROM NEW.death_date)
EXECUTE FUNCTION log_author_status_change();


-- Тест
UPDATE authors
SET death_date = '2024-11-25'
WHERE author_id = 200