package com.guran.gametracker;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;

@SpringBootApplication
public class GameTrackerApplication implements CommandLineRunner {

	private static final Logger log = LoggerFactory.getLogger(GameTrackerApplication.class);

	public static void main(String args[]) {
		SpringApplication.run(GameTrackerApplication.class, args);
	}

	@Autowired
	JdbcTemplate jdbcTemplate;

	@Override
	public void run(String... strings) throws Exception {

		log.info("Test query with JDBC Template...");
		jdbcTemplate.query(
				"SELECT p.name platform, count(*) number_of_games FROM\n" +
						"platforms p\n" +
						"JOIN platform_list pl ON pl.platform_id = p.id\n" +
						"JOIN games g ON g.id = pl.game_id\n" +
						"--exclude platforms where I have games but dont play\n" +
						"WHERE p.name NOT IN ('Linux','Mac','iPhone')\n" +
						"--exclude backlog games\n" +
						"AND pl.game_id NOT IN (SELECT game_id \n" +
						"                         FROM shelf_list sl\n" +
						"                         JOIN shelves s ON s.id = sl.shelf_id\n" +
						"                         WHERE s.name = 'Backlog')\n" +
						"GROUP BY p.name\n" +
						"HAVING count(*) > 10\n" +
						"ORDER BY count(*)",
				(rs, rowNum) -> new PlatformChart(rs.getString("platform"), rs.getLong("number_of_games"))
		).forEach(platformchart -> log.info(platformchart.toString()));
	}
}