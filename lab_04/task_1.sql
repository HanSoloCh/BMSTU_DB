-- Определяемая  пользователем скалярная функция
CREATE OR REPLACE FUNCTION calc_factorial(n INTEGER)
RETURNS BIGINT
AS $$
    if n < 0:
        raise ValueError("n must be a non-negative integer")
    elif n == 0:
        return 1
    else:
        result = 1
        for i in range(1, n + 1):
            result *= i
        return result
$$ LANGUAGE plpython3u;

-- Тест
SELECT calc_factorial(5);