-- Защита
WITH CTE AS (
	SELECT 
		pub.publisher_id,
		name,
		pages * circulation as total_pages_in_circulation
	FROM publishers pub 
	JOIN publications publc ON pub.publisher_id = publc.publisher_id
	JOIN books b ON publc.book_id = b.book_id 
),
CTE_2 AS (
	SELECT
		publisher_id,
		name,
		SUM(total_pages_in_circulation) as total_pages
	FROM CTE
	GROUP BY publisher_id, name
)
SELECT 
	publisher_id,
	name,
	total_pages
FROM CTE_2
WHERE total_pages = (
	SELECT MAX(total_pages)
	FROM CTE_2
);

-- Инструкция SELECT, использующая предикат сравнения.
SELECT book_id, title, age_rating
FROM books
WHERE age_rating >= 16;

-- Инструкция SELECT, использующая предикат BETWEEN.
SELECT author_id, surname, birth_date
FROM authors
WHERE birth_date BETWEEN '1900-01-01' AND '1999-12-31';

-- Инструкция SELECT, использующая предикат LIKE.
SELECT publisher_id, name
FROM publishers
WHERE name LIKE 'ООО%';

-- Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
SELECT title, genre
FROM books
WHERE genre IN (
	SELECT genre
	FROM books
	GROUP BY genre
	HAVING COUNT(*) > 10
);

-- Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
SELECT author_id, first_name, surname
FROM authors
WHERE EXISTS 
(
	SELECT book_id
	FROM book_author_link
	WHERE authors.author_id = book_author_link.author_id
);

-- Инструкция SELECT, использующая предикат сравнения с квантором.
SELECT author_id, first_name, surname
FROM authors
WHERE birth_date < ALL
(
	SELECT foundation_date
	FROM publishers
);

-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
SELECT b.book_id, b.title, SUM(p.circulation) AS total_copies, COUNT(*) AS total_publications
FROM books b LEFT JOIN publications p ON b.book_id = p.book_id
GROUP BY b.book_id
ORDER BY b.book_id;

-- Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
SELECT b.book_id, b.title,
	(SELECT SUM(p.circulation)
	FROM publications p
	WHERE b.book_id = p.book_id) AS total_copies,
	(SELECT COUNT(*)
	FROM publications p
	WHERE b.book_id = p.book_id) AS total_publications
FROM books b;

-- Инструкция SELECT, использующая простое выражение CASE.
SELECT 
	b.book_id, 
	title, 
	CASE EXTRACT(YEAR FROM MAX(publication_date))
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) THEN 'This year'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - 1 THEN 'Last year'
        ELSE CONCAT(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM MAX(p.publication_date)), ' years ago')
	END AS last_publications
FROM 
	books b LEFT JOIN publications p ON p.book_id = b.book_id
GROUP BY b.book_id;

-- Инструкция SELECT, использующая поисковое выражение CASE.
SELECT
	b.book_id,
	title,
	CASE
		WHEN SUM(circulation) > 100000 THEN 'Bestseller'
		WHEN SUM(circulation) > 10000 THEN 'Famous book'
		WHEN SUM(circulation) > 1000 THEN 'Well known book'
		ELSE 'Casual book'
	END AS book_glory
FROM 
	books b LEFT JOIN publications p ON p.book_id = b.book_id
GROUP BY b.book_id;

-- Создание ново временно локально таблицы из результирующего набора данных инструкции SELECT.
CREATE TEMP TABLE BookPublications AS
SELECT
	book_id,
	title,
	(SELECT SUM(circulation)
	FROM publications p
	WHERE p.book_id = b.book_id) AS total_publications
FROM
	books b;

-- Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM.
SELECT 
	'By copies' AS Criteria,
	title AS "Best Seller"
FROM
	books b
JOIN
	(
	SELECT
		book_id,
		SUM(circulation) AS p_count
	FROM 
		publications p
	GROUP BY 
		book_id
	ORDER BY 
		p_count DESC
	LIMIT 1
	) AS total_publications
ON b.book_id = total_publications.book_id;

-- Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
SELECT
	a.first_name,
	a.surname,
	b.title
FROM authors a
JOIN book_author_link bal ON a.author_id = bal.author_id
JOIN books b ON b.book_id = bal.book_id
WHERE b.book_id IN (
	SELECT book_id
	FROM publications
	WHERE publisher_id = (
		SELECT publisher_id
		FROM publishers
		WHERE foundation_date = (
			SELECT MIN(foundation_date)
			FROM publishers
		)
	)
);

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
SELECT
	a.author_id,
	first_name,
	surname,
	COUNT(bal.book_id) AS total_books
FROM authors a
LEFT JOIN book_author_link bal ON a.author_id = bal.author_id
GROUP BY a.author_id;

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING.
SELECT 
	a.author_id,
	a.first_name, 
	a.surname,
	COUNT(bal.book_id) AS total_books
FROM authors a
LEFT JOIN book_author_link bal ON a.author_id = bal.author_id
GROUP BY a.author_id
HAVING COUNT(bal.book_id) > 1;

-- Однострочная инструкция INSERT, выполняющая вставку в таблицу одно строки значени.
INSERT INTO authors(surname, first_name, second_name, birth_date, nationality)
VALUES('Новиков', 'Артём', 'Андреевич', '2004-02-11', 'RU');

-- Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
INSERT INTO authors (surname, first_name, second_name, birth_date, nationality)
SELECT 
    'Новиков',
    'Артём',
    'Андреевич',
    '2004-02-11',
    a.nationality
FROM
	(SELECT DISTINCT nationality FROM authors) a;

-- Простая инструкция UPDATE.
UPDATE authors
SET death_date = CURRENT_DATE
WHERE surname = 'Новиков' AND first_name = 'Артём' AND second_name = 'Андреевич';

-- Инструкция UPDATE со скалярным подзапросом в предложении SET.
UPDATE authors
SET death_date = (
	SELECT MIN(death_date)
	FROM authors
	WHERE nationality = 'RU'
)
WHERE surname = 'Новиков' AND first_name = 'Артём' AND second_name = 'Андреевич';

-- Простая инструкция DELETE.
DELETE FROM authors
WHERE surname = 'Новиков' AND first_name = 'Артём' AND second_name = 'Андреевич';

-- Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
DELETE FROM authors a
WHERE NOT EXISTS (
	SELECT 1
	FROM book_author_link bal
    WHERE bal.author_id = a.author_id
);

-- Инструкция SELECT, использующая простое обобщенное табличное выражение
WITH BooksWithPublications AS (
    SELECT 
        b.book_id, 
        b.title, 
        SUM(p.circulation) AS total_copies
    FROM 
        books b
    JOIN 
        publications p ON b.book_id = p.book_id
    GROUP BY 
        b.book_id
)
SELECT 
    book_id, 
    title, 
    total_copies
FROM 
    BooksWithPublications
WHERE 
    total_copies > 1000;

-- Оконные функции. Использование конструкци MIN/MAX/AVG OVER()
SELECT 
    a.nationality,
    a.author_id,
	a.surname,
    COUNT(bal.book_id) AS TotalBooks,
    AVG(COUNT(bal.book_id)) OVER (PARTITION BY a.nationality) AS AvgBooksPerAuthor,
    MIN(COUNT(bal.book_id)) OVER (PARTITION BY a.nationality) AS MinBooksPerAuthor,
    MAX(COUNT(bal.book_id)) OVER (PARTITION BY a.nationality) AS MaxBooksPerAuthor
FROM 
    authors a
LEFT JOIN 
    book_author_link bal ON a.author_id = bal.author_id
GROUP BY 
    a.author_id, a.nationality
ORDER BY 
    a.nationality,
	a.author_id;


-- Оконные фнкции для устранения дублей
WITH CTE AS (
    SELECT 
        a.author_id,
        a.surname,
        a.first_name,
        a.nationality,
        ROW_NUMBER() OVER (PARTITION BY a.author_id ORDER BY a.author_id) AS rn
    FROM 
        authors a
    JOIN 
        book_author_link bal ON a.author_id = bal.author_id
)
SELECT 
    author_id, surname, first_name, nationality
FROM 
    CTE
WHERE 
    rn = 1;


-- Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
CREATE TEMPORARY TABLE employee_hierarchy (
    employee_id SERIAL PRIMARY KEY,
    employee_name TEXT,
    manager_id INT,
	UNIQUE(employee_name)
);

INSERT INTO employee_hierarchy (employee_name, manager_id) VALUES 
('CEO', NULL),
('Manager 1', 1),
('Manager 2', 1),
('Employee 1', 2),
('Employee 2', 2),
('Employee 3', 3);


WITH RECURSIVE EmployeeTree AS (
    -- Начальный запрос: выбрать самого главного начальника
    SELECT 
        employee_id,
        employee_name,
        manager_id,
        1 AS level -- Начинаем с уровня 1 (главный начальник)
    FROM 
        employee_hierarchy
    WHERE 
        manager_id IS NULL  -- Главный начальник, у которого нет начальника
    UNION ALL
    -- Рекурсивная часть: выбрать всех подчиненных на основе предыдущего уровня
    SELECT 
        eh.employee_id,
        eh.employee_name,
        eh.manager_id,
        et.level + 1 AS level -- Увеличиваем уровень на 1
    FROM 
        employee_hierarchy eh
    JOIN 
        EmployeeTree et ON eh.manager_id = et.employee_id
)
-- Основной запрос для вывода иерархии сотрудников
SELECT 
    employee_id,
    employee_name,
    manager_id,
    level
FROM 
    EmployeeTree
ORDER BY 
    level, employee_id;

DROP TABLE employee_hierarchy;
