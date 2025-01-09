CREATE TABLE IF NOT EXISTS satellite (
    satellite_id INT PRIMARY KEY,
    name TEXT,
    production_date DATE,
    country TEXT
);

INSERT INTO satellite (satellite_id, name, production_date, country) VALUES
(1, 'SIT-2086', '2050-01-01', 'Россия'),
(2, 'Шицзян 16-02', '2049-12-01', 'Китай');


CREATE TABLE IF NOT EXISTS flights (
    satellite_id INT REFERENCES satellite(satellite_id),
    launch_date DATE,
    time TEXT,
    week_day TEXT,
    type INT,
    PRIMARY KEY (satellite_id, launch_date)
);

INSERT INTO flights (satellite_id, launch_date, time, week_day, type) VALUES
(1, '2050-05-11', '09:00', 'Среда', 1),
(1, '2051-06-14', '23:05', 'Среда', 0),
(1, '2051-10-10', '23:50', 'Вторник', 1),
(2, '2050-05-11', '15:15', 'Среда', 1),
(1, '2052-01-01', '12:15', 'Понедельник', 0);


-- Первый запрос (Выводит информацию о спутниках, которые ни разу не запускались)
SELECT *
FROM satellite s
WHERE NOT EXISTS (
    SELECT 1
    FROM flights f
    WHERE s.satellite_id = f.satellite_id
);

--- Второй запрос (Выодит id спутников, которые запускались более 5 раз)
SELECT satellite_id
FROM flights f
GROUP BY satellite_id
HAVING count(*) > 5;

