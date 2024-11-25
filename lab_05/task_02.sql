-- Создание временной таблицы для загрузки JSON
CREATE TEMP TABLE json_tab(json_t json);

-- Загрузка данных из JSON-файла
COPY json_tab FROM '/var/lib/postgresql/14/main/editors.json';

-- Создание основной таблицы
CREATE TABLE IF NOT EXISTS bg_copy_editors
(
    editor_id SERIAL PRIMARY KEY,
    surname TEXT NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    experience INT DEFAULT 0,
    genre TEXT NOT NULL,
	UNIQUE(surname, first_name, second_name),
	CHECK(experience >= 0)
);

-- Вставка данных из JSON в основную таблицу
INSERT INTO bg_copy_editors
SELECT j.*
FROM json_tab
CROSS JOIN LATERAL json_populate_record(null::bg_copy_editors, json_t) AS j;

-- Вспомогательные запросы для проверки данных
SELECT * FROM json_tab;

SELECT * FROM bg_copy_editors ORDER BY editor_id;

-- Пример сравнения с оригинальной таблицей (если она существует)
SELECT * FROM editors ORDER BY editor_id;

-- Удаление временной таблицы после использования
DROP TABLE json_tab;
