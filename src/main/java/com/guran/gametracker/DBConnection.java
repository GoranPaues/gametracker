package com.guran.gametracker;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;

import oracle.jdbc.pool.OracleDataSource;
import org.flywaydb.core.Flyway;

/**
 * Created by goranpaues on 2017-04-25.
 */
public class DBConnection {

    private static final String URL = "jdbc:oracle:thin:@";
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    //Environment Variable Cloud
    public static final Optional<String> DBAAS_USERNAME = Optional.ofNullable(System.getenv("DBAAS_USER_NAME"));
    public static final Optional<String> DBAAS_PASSWORD = Optional.ofNullable(System.getenv("DBAAS_USER_PASSWORD"));
    public static final Optional<String> DBAAS_DEFAULT_CONNECT_DESCRIPTOR = Optional.ofNullable(System.getenv("DBAAS_DEFAULT_CONNECT_DESCRIPTOR"));

    //Local settings
    public static final String LOCAL_USERNAME = "gametracker";
    public static final String LOCAL_PASSWORD = "gametracker";
    public static final String LOCAL_DEFAULT_CONNECT_DESCRIPTOR = "localhost:1521/ORCLPDB1";

    private static Connection connection = null;
    private static DBConnection instance = null;

    private DBConnection() {
        try {
            Class.forName(DRIVER).newInstance();
        } catch (Exception sqle) {
            sqle.getMessage();
        }
    }

    public static DBConnection getInstance() {
        if (connection == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    public Connection getConnection() {
        if (connection == null) {
            try {
                OracleDataSource ods = new OracleDataSource();
                ods.setURL(URL + DBAAS_DEFAULT_CONNECT_DESCRIPTOR.orElse(LOCAL_DEFAULT_CONNECT_DESCRIPTOR));
                ods.setUser(DBAAS_USERNAME.orElse(LOCAL_USERNAME));
                ods.setPassword(DBAAS_PASSWORD.orElse(LOCAL_PASSWORD));

                Flyway flyway = new Flyway();
                flyway.setDataSource(ods);
                flyway.setTable("SCHEMA_VERSION");
                flyway.migrate();

                connection = ods.getConnection();
            } catch (SQLException e) {
                e.getMessage();
            }
        }
        return connection;
    }

}
