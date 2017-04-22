--------------------------------------------------------
--  DDL for Table SHELVES
--------------------------------------------------------

CREATE TABLE GAMETRACKER.SHELVES
 (	ID NUMBER(13,0) GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR2(128 CHAR) NOT NULL,
    LAST_UPDATED TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT SHELVES_PK PRIMARY KEY (ID)
);
