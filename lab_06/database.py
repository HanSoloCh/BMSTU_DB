import psycopg2

def connect_to_db():
    conn = psycopg2.connect(
        dbname="books_db",
        user="artem",
        password="traban2011",
        host="localhost",
        port="5432"
    )
    return conn

def scalar_query(conn):
    with conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM authors WHERE death_date IS NOT NULL;")
        result = cursor.fetchone()
        print("Количество живых авторов:", result[0])

def join_query(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT b.title, p.publication_date, p.circulation
            FROM books b 
            JOIN publications p ON b.book_id = p.book_id
            WHERE b.book_id = %s;
        """, (user_id, ))
        i = 0
        for row in cursor.fetchall():
            if i == 0:
                print(f"\nКнига с ID={user_id}: {row[0]}")
            print(f"{i + 1} публикация от {row[1]} количество копий - {row[2]}")
            i += 1

def cte_window_query(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
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
        """, ( ))
        print(f"{'id':5}|{'Название':50}|{'Число страниц':20}")
        for row in cursor.fetchall():
            print(f"{row[0]:5}|{row[1]:50}|{row[2]:20}")

def metadata_query(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT column_name, data_type
            FROM information_schema.columns
            WHERE table_name = 'authors';
        """)
        for row in cursor.fetchall():
            print(f"Имя столбца: {row[0]}, Тип данных: {row[1]}")

def call_scalar_function(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute("SELECT get_author_publication_count(%s);", (user_id,))
        print("Общее число публикаций автора: ", cursor.fetchone()[0])

def call_table_function(conn, request_id):
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM get_author_books(%s);", (request_id,))
        print(f"{'book_id':10}|{'title':30}|{'publication_date':20}|{'publisher_id':20}")
        for row in cursor.fetchall():
            print(f"{row[0]:10}|{row[1]:30}|{row[2]:20}|{row[3]:20}")

def call_stored_procedure(conn, repair_id, new_status):
    with conn.cursor() as cursor:
        cursor.execute("CALL update_age_rating(%s, %s);", (repair_id, new_status))
        conn.commit()
        print("Возрастной рейтинг обновлен")

def call_system_function(conn):
    with conn.cursor() as cursor:
        cursor.execute("SELECT CURRENT_DATE;")
        print("Текущая дата:", cursor.fetchone()[0])

def create_table(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS artists (
                artist_id SERIAL PRIMARY KEY,
                surname TEXT,
                first_name TEXT,
                second_name TEXT,
                experience INT
            );
        """)
        conn.commit()
        print("Таблица artists создана")

def is_table_exists(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_name = 'artists'
            );
        """)
        return cursor.fetchone()[0]

def insert_data(conn):
    if not is_table_exists(conn):
        print("Таблицы artists не существует")
        return
    with conn.cursor() as cursor:
        surname = input("Введите фамилию: ")
        first_name = input("Введите имя: ")
        second_name = input("Введите отчество: ")
        age = int(input("Введите стаж: "))


        cursor.execute("INSERT INTO artists (surname, first_name, second_name, experience) VALUES (%s, %s, %s, %s);",
                       (surname, first_name, second_name, age,))
        conn.commit()
        print("Запись добавлена")