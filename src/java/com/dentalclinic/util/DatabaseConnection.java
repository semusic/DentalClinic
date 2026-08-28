package com.dentalclinic.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {

    private static final String URL =
            "jdbc:mariadb://localhost:3306/dental_clinic";

    private static final String USER = "root";
    private static final String PASSWORD = "";

    private DatabaseConnection() {
        // Prevent object creation.
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}