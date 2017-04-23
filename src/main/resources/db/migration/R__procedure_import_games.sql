CREATE OR REPLACE PROCEDURE gametracker.import_games AS

    l_game_id        games.id%TYPE;
    l_shelf_id       shelves.id%TYPE;
    l_platform_id    platforms.id%TYPE;
    l_dept_arr       json_array_t;
    l_shelves_obj    json_object_t;
    l_shelves_list   json_key_list;
    l_shelf_list     json_key_list;
    l_shelf_arr      json_array_t;
    l_shelf_obj      json_object_t;
    l_date_added     DATE;
    l_boolean_char   VARCHAR2(10 CHAR);
BEGIN
    FOR rc IN (
        SELECT
            *
        FROM
            grouvee_import
        WHERE
            ROWNUM < 2
    ) LOOP
    
        /* MERGE GAME INFO */
        UPDATE games
            SET
                rating = rc.rating,
                review = rc.review,
                time_played = JSON_VALUE(rc.dates,'$.seconds_played')
        WHERE
            name = rc.name
        RETURNING id INTO l_game_id;

        IF
            SQL%rowcount = 0
        THEN
            INSERT INTO games (
                name,
                rating,
                review,
                time_played
            ) VALUES (
                rc.name,
                rc.rating,
                rc.review,
                JSON_VALUE(rc.dates,'$.seconds_played')
            ) RETURNING id INTO l_game_id;

        END IF;
        /* END GAME INFO */
        
        /* MERGE SHELVES */

        l_shelves_obj := json_object_t(rc.shelves);
        l_shelves_list := l_shelves_obj.get_keys;
        FOR i IN 1..l_shelves_list.count LOOP
            BEGIN
                SELECT
                    id
                INTO
                    l_shelf_id
                FROM
                    shelves
                WHERE
                    name = l_shelves_list(i);

            EXCEPTION
                WHEN no_data_found THEN
                    INSERT INTO shelves ( name ) VALUES ( l_shelves_list(i) ) RETURNING id INTO l_shelf_id;

            END;

            l_shelf_obj := l_shelves_obj.get_object(l_shelves_list(i) );
            l_date_added := TO_DATE(
                l_shelf_obj.get_string('date_added'),
                'yyyy-mm-dd"T"hh24:mi:ss"Z"'
            );
            UPDATE shelf_list
                SET
                    date_added = l_date_added
            WHERE
                    game_id = l_game_id
                AND
                    shelf_id = l_shelf_id;

            IF
                SQL%rowcount = 0
            THEN
                INSERT INTO shelf_list (
                    game_id,
                    shelf_id,
                    date_added
                ) VALUES (
                    l_game_id,
                    l_shelf_id,
                    l_date_added
                );

            END IF;

        END LOOP;
        /* END SHELVES */

        /* MERGE SHELVES */

        l_shelves_obj := json_object_t(rc.shelves);
        l_shelves_list := l_shelves_obj.get_keys;
        FOR i IN 1..l_shelves_list.count LOOP
            BEGIN
                SELECT
                    id
                INTO
                    l_shelf_id
                FROM
                    shelves
                WHERE
                    name = l_shelves_list(i);

            EXCEPTION
                WHEN no_data_found THEN
                    INSERT INTO shelves ( name ) VALUES ( l_shelves_list(i) ) RETURNING id INTO l_shelf_id;

            END;

            l_shelf_obj := l_shelves_obj.get_object(l_shelves_list(i) );
            l_date_added := TO_DATE(
                l_shelf_obj.get_string('date_added'),
                'yyyy-mm-dd"T"hh24:mi:ss"Z"'
            );
            UPDATE shelf_list
                SET
                    date_added = l_date_added
            WHERE
                    game_id = l_game_id
                AND
                    shelf_id = l_shelf_id;

            IF
                SQL%rowcount = 0
            THEN
                INSERT INTO shelf_list (
                    game_id,
                    shelf_id,
                    date_added
                ) VALUES (
                    l_game_id,
                    l_shelf_id,
                    l_date_added
                );

            END IF;

        END LOOP;
        /* END SHELVES */

    END LOOP;
    /* END GAMES */
    
    COMMIT;
END import_games;