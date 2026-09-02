package com.dentalclinic.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class QrTokenService {

    private final SecureRandom secureRandom;

    public QrTokenService() {

        this.secureRandom =
                new SecureRandom();
    }

    /**
     * Generates an opaque URL-safe token.
     */
    public String generateToken() {

        byte[] bytes =
                new byte[32];

        secureRandom.nextBytes(bytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }

    /**
     * Converts the raw QR token into a SHA-256
     * hexadecimal hash for database storage.
     */
    public String hashToken(
            String rawToken) {

        if (rawToken == null
                || rawToken.isBlank()) {

            throw new IllegalArgumentException(
                    "QR token is required."
            );
        }

        try {

            MessageDigest digest =
                    MessageDigest.getInstance(
                            "SHA-256"
                    );

            byte[] hash =
                    digest.digest(
                            rawToken.getBytes(
                                    StandardCharsets.UTF_8
                            )
                    );

            StringBuilder result =
                    new StringBuilder();

            for (byte value : hash) {

                result.append(
                        String.format(
                                "%02x",
                                value
                        )
                );
            }

            return result.toString();

        } catch (NoSuchAlgorithmException e) {

            throw new IllegalStateException(
                    "SHA-256 algorithm is unavailable.",
                    e
            );
        }
    }
}