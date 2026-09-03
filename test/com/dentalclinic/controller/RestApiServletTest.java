package com.dentalclinic.controller;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import static org.junit.Assert.*;

public class RestApiServletTest {

    private static final String BASE_URL =
            "http://localhost:8080/DentalClinic/api";

    private HttpURLConnection openConnection(
            String endpoint
    ) throws Exception {

        URL url =
                new URL(
                        BASE_URL + endpoint
                );

        HttpURLConnection connection =
                (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("GET");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(5000);

        return connection;
    }

    private String readResponse(
            HttpURLConnection connection
    ) throws Exception {

        BufferedReader reader =
                new BufferedReader(
                        new InputStreamReader(
                                connection.getInputStream()
                        )
                );

        StringBuilder response =
                new StringBuilder();

        String line;

        while ((line = reader.readLine()) != null) {
            response.append(line);
        }

        reader.close();

        return response.toString();
    }

    @Test
    public void shouldReturnApiInformation()
            throws Exception {

        HttpURLConnection connection =
                openConnection("");

        assertEquals(
                200,
                connection.getResponseCode()
        );

        String response =
                readResponse(connection);

        assertTrue(
                response.contains(
                        "DentalCare REST Web Services API"
                )
        );

        connection.disconnect();
    }

    @Test
    public void shouldReturnActiveServices()
            throws Exception {

        HttpURLConnection connection =
                openConnection("/services");

        assertEquals(
                200,
                connection.getResponseCode()
        );

        String response =
                readResponse(connection);

        assertTrue(
                response.startsWith("[")
        );

        assertTrue(
                response.contains(
                        "serviceId"
                )
        );

        connection.disconnect();
    }

    @Test
    public void shouldReturnExistingService()
            throws Exception {

        HttpURLConnection connection =
                openConnection("/services/1");

        assertEquals(
                200,
                connection.getResponseCode()
        );

        String response =
                readResponse(connection);

        assertTrue(
                response.contains(
                        "\"serviceId\":1"
                )
        );

        connection.disconnect();
    }

    @Test
    public void shouldRejectInvalidServiceIdFormat()
            throws Exception {

        HttpURLConnection connection =
                openConnection("/services/abc");

        assertEquals(
                400,
                connection.getResponseCode()
        );

        connection.disconnect();
    }

    @Test
    public void shouldReturnNotFoundForUnknownResource()
            throws Exception {

        HttpURLConnection connection =
                openConnection("/unknown-resource");

        assertEquals(
                404,
                connection.getResponseCode()
        );

        connection.disconnect();
    }
}