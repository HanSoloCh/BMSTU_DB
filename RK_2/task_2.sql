-- Указание должностей работников
SELECT
	employee_id,
	surname,
	first_name,
	CASE 
    	WHEN post = 'Boss' THEN 'Начальник'
    	WHEN post = 'Manager' THEN 'Менеджер'
    	WHEN post = 'Finance' THEN 'Эксперт по финансам'
    	ELSE 'Другая должность'
	END AS job_title
FROM employee;

-- Рядом с каждым сотрудником выводится дата рождения самого молодого и самого старого сотрудника с такой же должностью
SELECT 
	employee_id,
	surname,
	first_name,
	post,
	birth_date,
    MIN(birth_date) OVER (PARTITION BY post) AS min_birth_date_with_this_post,
    MAX(birth_date) OVER (PARTITION BY post) AS max_birth_date_with_this_post
FROM employee;

-- Выводит валюту у которой средняя сумма операций больше 1000
SELECT 
 currency.currency_name,
 AVG(o.amount) AS average_amount
FROM operation AS o
JOIN course AS c ON o.course_id = c.course_id
JOIN currency AS currency ON c.currency_id = currency.currency_id
GROUP BY currency.currency_name
HAVING AVG(o.amount) > 1000; 


