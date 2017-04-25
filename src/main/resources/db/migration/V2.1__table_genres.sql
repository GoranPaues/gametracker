--------------------------------------------------------
--  DDL for Table GENRES
--------------------------------------------------------

CREATE TABLE GAMETRACKER.GENRES
 (	ID NUMBER(13,0) GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR2(128 CHAR) NOT NULL,
    LAST_UPDATED TIMESTAMP  DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT GENRES_PK PRIMARY KEY (ID)
);
