CREATE TABLE parsed_editors (
    id SERIAL PRIMARY KEY,
    surname TEXT,
    first_name TEXT,
    second_name TEXT,
    experience INT,
    genre TEXT
);

INSERT INTO parsed_editors (surname, first_name, second_name, experience, genre)
SELECT 
    info->>'surname',
    info->>'first_name',
    info->>'second_name',
    (info->>'experience')::INTEGER,
    info->>'genre'
FROM editors_json;

SELECT * FROM parsed_editors;
