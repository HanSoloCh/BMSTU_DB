import psycopg2
from sqlalchemy.orm import Session
from sqlalchemy import func, extract, case

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey, Date
from sqlalchemy import create_engine

DATABASE_URL = "postgresql+psycopg2://artem:traban2011@localhost:5432/rk_3"

def get_db_engine():
    engine = create_engine(DATABASE_URL)
    Base.metadata.create_all(engine)
    return engine

Base = declarative_base()

class Satellite(Base):
    __tablename__ = 'satellite'
    satellite_id = Column(Integer, primary_key=True)
    name = Column(String)
    production_date = Column(Date)
    country = Column(String)

class Flight(Base):
    __tablename__ = 'flights'
    satellite_id = Column(Integer, ForeignKey('satellite.satellite_id'), primary_key=True)
    launch_date = Column(Date, primary_key=True)
    time = Column(String)
    week_day = Column(String)
    type = Column(Integer)



def connect_to_db():
    conn = psycopg2.connect(
        dbname="rk_3",
        user="artem",
        password="traban2011",
        host="localhost",
        port="5432"
    )
    return conn

def main_menu():
    print("\nМеню:")
    print("1. Найти страны, в которых космические аппараты производятся только в мае")
    print("2. Найти спутник, который в этом году первым вернулся на землю")
    print("3. Найти спутник, который в прошлом календарном году вернулся последним")
    print("4. Найти страны, в которых космические аппараты производятся только в мае (ORM)")
    print("5. Найти спутник, который в этом году первым вернулся на землю(ORM)")
    print("6. Найти спутник, который в прошлом календарном году вернулся последним(ORM)")

    print("0. Выход")
    choice = input("Выберите действие: ")
    return choice

def db_first(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
        SELECT country
        FROM satellite
        GROUP BY country
        HAVING COUNT(CASE WHEN EXTRACT(MONTH FROM production_date) != 5 THEN 1 END) = 0 AND COUNT(*) > 0;
        """, ())
        i = 0
        for row in cursor.fetchall():
            print(f"\n{row[0]}")

def db_sec(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
        SELECT s.name
        FROM satellite s
        JOIN flights f ON s.satellite_id = f.satellite_id
        WHERE date_part('year', f.launch_date) = date_part('year', CURRENT_DATE)
        ORDER BY f.launch_date
        LIMIT 1;
        """, ())
        for row in cursor.fetchall():
            print(f"\n{row[0]}")

def db_third(conn):
    with conn.cursor() as cursor:
        cursor.execute("""
        SELECT s.name
        FROM satellite s
        JOIN flights f ON s.satellite_id = f.satellite_id
        WHERE date_part('year', f.launch_date) = date_part('year', CURRENT_DATE) - 1
        ORDER BY f.launch_date DESC
        LIMIT 1;
        """, ())
        for row in cursor.fetchall():
            print(f"\n{row[0]}")

def orm_first(session):
    countries = session.query(Satellite.country) \
        .group_by(Satellite.country) \
        .having(func.count(case(
            (extract('month', Satellite.production_date) != 5, 1),
            else_=None
        )) == 0, func.count(Satellite.country) > 0) \
        .all()
    if countries:
        for country in countries:
            print(country[0])


def orm_sec(session):
    this_year = extract('year', func.now())
    first_return = session.query(Satellite) \
        .join(Flight, Satellite.satellite_id == Flight.satellite_id) \
        .filter(extract('year', Flight.return_date) == this_year) \
        .order_by(Flight.return_date) \
        .first()
    if first_return:
        print(f"\n{first_return.name}")

def orm_third(session):
    last_year = extract('year', func.now()) - 1
    last_return = session.query(Satellite) \
        .join(Flight, Satellite.satellite_id == Flight.satellite_id) \
        .filter(extract('year', Flight.return_date) == last_year) \
        .order_by(Flight.return_date.desc()) \
        .first()
    if last_return:
        print(f"\n{last_return.name}")


def main():
    engine = get_db_engine()
    engine.connect()

    session = Session(engine)



    conn = connect_to_db()
    while True:
        choice = main_menu()
        if choice == "1":
            db_first(conn)
        elif choice == "2":
            db_sec(conn)
        elif choice == "3":
            db_third(conn)
        elif choice == "4":
            orm_first(session)
        elif choice == "5":
            orm_sec(session)
        elif choice == "6":
            orm_third(session)
        elif choice == "0":
            conn.close()
            break
        else:
            print("Неверный выбор.")


if __name__ == "__main__":
    main()