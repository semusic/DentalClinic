package com.dentalclinic.util;

import java.sql.Connection;

public class DatabaseConnectionTest {

    public static void main(String[] args) {

        try (Connection connection =
                     DatabaseConnection.getConnection()) {

            System.out.println("Database connection successful.");

            System.out.println(
                    "Connected to: "
                    + connection.getMetaData().getDatabaseProductName()
            );

            System.out.println(
                    "Database version: "
                    + connection.getMetaData().getDatabaseProductVersion()
            );

        } catch (Exception e) {

            System.err.println("Database connection failed.");
            e.printStackTrace();
        }
    }
}