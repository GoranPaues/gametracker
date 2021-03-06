--------------------------------------------------------
--  DDL for Table PLATFORMS
--------------------------------------------------------

CREATE TABLE GAMETRACKER.PLATFORMS
 (	ID NUMBER(13,0) GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR2(128 CHAR) NOT NULL,
    LAST_UPDATED TIMESTAMP  DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT PLATFORMS_PK PRIMARY KEY (ID)
);
