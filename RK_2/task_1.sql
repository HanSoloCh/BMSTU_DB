CREATE TABLE IF NOT EXISTS employee (
    employee_id SERIAL PRIMARY KEY,
    surname TEXT,
    first_name TEXT,
    second_name TEXT,
    birth_date DATE,
    post TEXT
);

CREATE TABLE IF NOT EXISTS currency (
    currency_id SERIAL PRIMARY KEY,
	currency_name VARCHAR(5)
);


CREATE TABLE IF NOT EXISTS course (
    course_id SERIAL PRIMARY KEY,
	currency_id INT REFERENCES currency(currency_id),
	sell_cost DECIMAL(10, 2),
	buy_cost DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS operation (
    operation_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employee(employee_id),
	course_id INT REFERENCES course(course_id),
	amount DECIMAL(10, 2)
);


INSERT INTO employee (surname, first_name, second_name, birth_date, post) VALUES
 ('Smith', 'John', 'A.', '1985-07-16', 'Manager'),
 ('Johnson', 'Jane', 'M.', '1992-03-28', 'Boss'),
 ('Williams', 'David', 'B.', '1978-11-05', 'Finance'),
 ('Brown', 'Emily', 'C.', '1989-05-12', 'Finance'),
 ('Jones', 'Michael', 'D.', '1982-09-21', 'Boss'),
 ('Miller', 'Sarah', 'E.', '1995-01-08', 'Manager'),
 ('Davis', 'Christopher', 'F.', '1987-06-19', 'Manager'),
 ('Wilson', 'Jessica', 'G.', '1990-10-26', 'Finance'),
 ('Moore', 'Daniel', 'H.', '1984-02-14', 'Boss'),
 ('Taylor', 'Ashley', 'I.', '1993-08-03', 'Finance');


INSERT INTO currency (currency_name) VALUES
 ('USD'),
 ('EUR'),
 ('GBP'),
 ('JPY'),
 ('CHF'),
 ('AUD'),
 ('CAD'),
 ('NZD'),
 ('SEK'),
 ('NOK');

INSERT INTO course (currency_id, sell_cost, buy_cost) VALUES
 (1, 80.50, 79.80),
 (2, 90.20, 89.50),
 (3, 100.10, 99.40),
 (4, 0.65, 0.63),
 (5, 85.30, 84.60),
 (6, 65.70, 65.00),
 (7, 68.20, 67.50),
 (8, 62.90, 62.20),
 (9, 9.20, 9.00),
 (10, 9.50, 9.30);

INSERT INTO operation (employee_id, course_id, amount) VALUES
 (1, 1, 1000.00),
 (2, 2, 500.00),
 (3, 3, 2000.00),
 (4, 4, 1500.00),
 (5, 5, 750.00),
 (6, 6, 1200.00),
 (7, 7, 900.00),
 (8, 8, 1800.00),
 (9, 9, 600.00),
 (10, 10, 400.00);





