CREATE OR REPLACE PROCEDURE gametracker.import_games AS

    l_game_id        games.id%TYPE;
    l_shelf_id       shelves.id%TYPE;
    l_platform_id    platforms.id%TYPE;
    l_top_obj        json_object_t;
    l_dept_arr       json_array_t;
    l_shelves_list   json_key_list;
    l_shelf_obj      json_object_t;
BEGIN
    FOR rc IN (
        SELECT
            *
        FROM
            grouvee_import
    ) LOOP
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

            l_top_obj := json_object_t(rc.shelves);
            l_shelves_list := l_top_obj.get_keys;
            FOR j IN 1..l_shelves_list.count LOOP
                BEGIN
                    SELECT
                        id
                    INTO
                        l_shelf_id
                    FROM
                        shelves
                    WHERE
                        name = l_shelves_list(j);

                EXCEPTION
                    WHEN no_data_found THEN
                        INSERT INTO shelves ( name ) VALUES ( l_shelves_list(j) ) 
                        RETURNING id INTO l_shelf_id;

                END;
            --l_shelves_obj := TREAT(l_shelves_list(j) AS JSON_OBJECT_T).get_object;
            
            /*update shelf_list
            set date_added = 
            last_updated = systimestamp
            where name = rc.name
            returning id into l_game_id;
            */
            END LOOP;

        END IF;

    END LOOP;

    COMMIT;
END import_games;