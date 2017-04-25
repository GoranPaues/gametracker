CREATE OR REPLACE PROCEDURE gametracker.import_games AS

    l_game_id          games.id%TYPE;
    l_shelf_id         shelves.id%TYPE;
    l_platform_id      platforms.id%TYPE;
    l_genre_id         genres.id%TYPE;
    l_time_played      games.time_played%TYPE;
    l_release_date     games.release_date%TYPE;
    l_date_added       DATE;
    l_shelves_obj      json_object_t;
    l_shelves_list     json_key_list;
    l_shelf_obj        json_object_t;
    l_platforms_obj    json_object_t;
    l_platforms_list   json_key_list;
    l_genres_obj       json_object_t;
    l_genres_list      json_key_list;
BEGIN
    FOR rc IN (
        SELECT
            *
        FROM
            grouvee_import
    ) LOOP
    
        /* MERGE GAME INFO */
        l_time_played := JSON_VALUE ( rc.dates,'$.seconds_played' );
        IF
            length(rc.release_date) = 10
        THEN
            l_release_date := TO_DATE(
                rc.release_date,
                'yyyy-mm-dd'
            );
        ELSIF length(rc.release_date) = 7 THEN
            l_release_date := TO_DATE(
                rc.release_date,
                'yyyy-mm'
            );
        ELSIF length(rc.release_date) = 4 THEN
            l_release_date := TO_DATE(
                rc.release_date,
                'yyyy'
            );
        ELSE
            l_release_date := NULL;
        END IF;

        UPDATE games
            SET
                rating = rc.rating,
                review = rc.review,
                time_played = l_time_played,
                release_date = l_release_date,
                grouvee_url = rc.url,
                giantbomb_id = rc.giantbomb_id
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
                time_played,
                release_date,
                grouvee_url,
                giantbomb_id
            ) VALUES (
                rc.name,
                rc.rating,
                rc.review,
                l_time_played,
                l_release_date,
                rc.url,
                rc.giantbomb_id
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

        /* MERGE GENRES */

        l_genres_obj := json_object_t(rc.genres);
        l_genres_list := nvl(
            l_genres_obj.get_keys,
            json_key_list()
        );
        FOR i IN 1..l_genres_list.count LOOP
            BEGIN
                SELECT
                    id
                INTO
                    l_genre_id
                FROM
                    genres
                WHERE
                    name = l_genres_list(i);

                EXCEPTION
                WHEN no_data_found THEN
                INSERT INTO genres ( name ) VALUES ( l_genres_list(i) ) RETURNING id INTO l_genre_id;

            END;

            INSERT INTO genre_list (
                game_id,
                genre_id
            ) SELECT
                  l_game_id,
                  l_genre_id
              FROM
                  dual
              WHERE
                  NOT
                  EXISTS (
                      SELECT
                          1
                      FROM
                          genre_list
                      WHERE
                          game_id = l_game_id
                          AND
                          genre_id = l_genre_id
                  );

        END LOOP;
        /* END genres */

        /* END GAME INFO */

    END LOOP;

    COMMIT;
END import_games;