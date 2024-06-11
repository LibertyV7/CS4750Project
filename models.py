from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Member(Base):
    __tablename__ = 'members'
    id = Column(Integer , primary_key=True)
    firstName = Column(String(50))
    lastName = Column(String(50))
    computingID = Column(String(50))
    provieSemester = Column(String(50))
    duesPaid = Column(String(50))