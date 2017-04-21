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
				"SELECT count(1) cnt FROM grouvee_import WHERE name = ?", new Object[] { "Homeworld" },
				(rs, rowNum) -> new Integer(rs.getInt("cnt"))
		).forEach(integer -> log.info(integer.toString()));
	}
}