--------------------------------------------------------
--  DDL for Table GAMES
--------------------------------------------------------

CREATE TABLE gametracker.games
 (	id NUMBER(13,0) GENERATED ALWAYS AS IDENTITY,
    name VARCHAR2(128 CHAR) NOT NULL ENABLE,
    shelves CLOB,
    platforms CLOB,
    rating NUMBER(1,0),
    review CLOB,
    dates CLOB,
    genres CLOB,
    franchises CLOB,
    developers CLOB,
    publishers CLOB,
    release_date DATE,
    grouvee_url VARCHAR2(2048 CHAR),
    giantbomb_iD NUMBER(13,0),
    CONSTRAINT games_pk PRIMARY KEY (id),
    CONSTRAINT shelves_json CHECK (shelves IS JSON (STRICT)),
    CONSTRAINT platforms_json CHECK (platforms IS JSON (STRICT)),
    CONSTRAINT dates_json CHECK (dates IS JSON (STRICT)),
    CONSTRAINT genres_json CHECK (genres IS JSON (STRICT)),
    CONSTRAINT franchises_json CHECK (franchises IS JSON (STRICT)),
    CONSTRAINT developers_json CHECK (developers IS JSON (STRICT)),
    CONSTRAINT publishers_json CHECK (publishers IS JSON (STRICT))
);
