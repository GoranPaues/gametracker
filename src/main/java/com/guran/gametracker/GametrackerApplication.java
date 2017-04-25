package com.guran.gametracker;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;
import java.util.Optional;
import java.util.Properties;

@SpringBootApplication
public class GameTrackerApplication {

	// Get PORT and HOST from Environment or set default
	public static final Optional host;
	public static final Optional port;
	public static final Properties myProps = new Properties();

	static {
		host = Optional.ofNullable(System.getenv("HOSTNAME"));
		port = Optional.ofNullable(System.getenv("PORT"));
	}

	private static final Logger log = LoggerFactory.getLogger(GameTrackerApplication.class);

	public static void main(String[] args) {
		// Set properties

		myProps.setProperty("server.address", (String) host.orElse("localhost"));
		myProps.setProperty("server.port", (String) port.orElse("8080"));

		SpringApplication app = new SpringApplication(GameTrackerApplication.class);
		app.setDefaultProperties(myProps);
		app.run(args);

	}
}