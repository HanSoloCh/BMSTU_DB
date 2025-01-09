from sqlalchemy import Column, Integer, String, Date, ForeignKey, CheckConstraint, UniqueConstraint, DefaultClause
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.schema import Sequence

Base = declarative_base()


class Authors(Base):
    __tablename__ = "authors"

    author_id = Column(Integer, Sequence('authors_author_id_seq'), primary_key=True)
    surname = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    second_name = Column(String(50), nullable=False)
    birth_date = Column(Date, nullable=False)
    death_date = Column(Date, nullable=True, default=None)
    nationality = Column(String(2), nullable=False)

    books = relationship("Books", secondary="book_author_link", back_populates="authors")

    __table_args__ = (
        UniqueConstraint("surname", "first_name", "second_name", name="unique_author"),
        CheckConstraint("birth_date < death_date", name="date_check"),
    )


class Books(Base):
    __tablename__ = "books"

    book_id = Column(Integer, Sequence('books_book_id_seq'), primary_key=True)
    title = Column(String(100), nullable=False, unique=True)
    genre = Column(String(50), nullable=False)
    age_rating = Column(Integer, nullable=False, server_default=DefaultClause("0"))
    pages = Column(Integer, nullable=False)
    annotation = Column(String, nullable=False)

    authors = relationship("Authors", secondary="book_author_link", back_populates="books")

    __table_args__ = (
        CheckConstraint("age_rating >= 0 AND age_rating <= 18", name="books_age_rating_check"),
    )

class Editors(Base):
    __tablename__ = "editors"

    editor_id = Column(Integer, Sequence('editors_editor_id_seq'), primary_key=True)
    surname = Column(String(50), nullable=False)
    first_name = Column(String(50), nullable=False)
    second_name = Column(String(50), nullable=False)
    experience = Column(Integer, nullable=False, server_default=DefaultClause("0"))
    genre = Column(String, nullable=False)

    __table_args__ = (
        UniqueConstraint("surname", "first_name", "second_name", name="unique_editor"),
        CheckConstraint("experience >= 0", name="experience_check"),
    )


class Publishers(Base):
    __tablename__ = "publishers"

    publisher_id = Column(Integer, Sequence('publishers_publisher_id_seq'), primary_key=True)
    name = Column(String(100), nullable=False, unique=True)
    phone = Column(String(30), nullable=False)
    country = Column(String(50), nullable=False)
    foundation_date = Column(Date, nullable=False)
    address = Column(String(100), nullable=False)


class BookAuthorLink(Base):
    __tablename__ = "book_author_link"

    author_id = Column(Integer, ForeignKey("authors.author_id"), primary_key=True)
    book_id = Column(Integer, ForeignKey("books.book_id"), primary_key=True)


class Publications(Base):
    __tablename__ = "publications"

    book_id = Column(Integer, ForeignKey("books.book_id"), primary_key=True)
    publisher_id = Column(Integer, ForeignKey("publishers.publisher_id"), primary_key=True)
    editor_id = Column(Integer, ForeignKey("editors.editor_id"), primary_key=True)
    publication_date = Column(Date, nullable=False)
    circulation = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint("circulation >= 0", name="circulation_check"),
    )
