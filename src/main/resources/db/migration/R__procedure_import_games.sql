CREATE OR REPLACE PROCEDURE gametracker.import_games AS

    l_game_id          games.id%TYPE;
    l_shelf_id         shelves.id%TYPE;
    l_platform_id      platforms.id%TYPE;
    l_date_added       DATE;
    l_shelves_obj      json_object_t;
    l_shelves_list     json_key_list;
    l_shelf_obj        json_object_t;
    l_platforms_obj    json_object_t;
    l_platforms_list   json_key_list;
BEGIN
    FOR rc IN (
        SELECT
            *
        FROM
            grouvee_import
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
        l_shelves_list := nvl(
            l_shelves_obj.get_keys,
            json_key_list()
        );
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

        /* MERGE PLATFORMS */

        l_platforms_obj := json_object_t(rc.platforms);
        l_platforms_list := nvl(
            l_platforms_obj.get_keys,
            json_key_list()
        );
        FOR i IN 1..l_platforms_list.count LOOP
            BEGIN
                SELECT
                    id
                INTO
                    l_platform_id
                FROM
                    platforms
                WHERE
                    name = l_platforms_list(i);

            EXCEPTION
                WHEN no_data_found THEN
                    INSERT INTO platforms ( name ) VALUES ( l_platforms_list(i) ) RETURNING id INTO l_platform_id;

            END;

            INSERT INTO platform_list (
                game_id,
                platform_id
            ) SELECT
                l_game_id,
                l_platform_id
            FROM
                dual
            WHERE
                NOT
                    EXISTS (
                        SELECT
                            1
                        FROM
                            platform_list
                        WHERE
                                game_id = l_game_id
                            AND
                                platform_id = l_platform_id
                    );

        END LOOP;
        /* END PLATFORMS */

        /* END GAME INFO */

    END LOOP;

    COMMIT;
END import_games;