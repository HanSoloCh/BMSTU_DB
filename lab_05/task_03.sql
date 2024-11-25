-- таблица с атрибутом типа json
-- заполнить атрибут правдоподобными данными

CREATE TABLE IF NOT EXISTS editors_json
(
    info jsonb
);

INSERT INTO editors_json
VALUES
('{ "surname" : "Новиков",
    "firs_name" : "Артём",
    "second_name" : "Андреевич",
    "experience" : 16,
	"genre" : "Научная фантастика"
 }'
),
('{ "surname" : "Нисуев",
    "firs_name" : "Нису",
    "second_name" : "Фелексович",
    "experience" : 0,
	"genre" : "Триллер"
 }'
)

SELECT *
FROM editors_json;

DROP TABLE editors_json;