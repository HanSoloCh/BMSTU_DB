-- Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
CREATE OR REPLACE PROCEDURE fibonacci_proc(IN n INT, OUT result INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF n = 0 THEN
        result := 0;
    ELSIF n = 1 THEN
        result := 1;
    ELSE
        DECLARE
            temp1 INT;
            temp2 INT;
        BEGIN
            CALL fibonacci_proc(n - 1, temp1);
            CALL fibonacci_proc(n - 2, temp2);
            result := temp1 + temp2;
        END;
    END IF;
END;
$$;

-- Тест
DO $$
DECLARE
    result INT;
BEGIN
    CALL fibonacci_proc(5, result);
    RAISE NOTICE 'Fibonacci number: %', result;
END $$;