package com.dentalclinic.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordHasher {

    private static final int SALT_LENGTH = 16;
    private static final int ITERATIONS = 120_000;
    private static final int KEY_LENGTH = 256;

    private PasswordHasher() {
        // Utility class.
    }

    public static String hashPassword(String password) {
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException(
                    "Password cannot be empty."
            );
        }

        byte[] salt = new byte[SALT_LENGTH];
        new SecureRandom().nextBytes(salt);

        byte[] hash = derive(password.toCharArray(), salt);

        return "PBKDF2-SHA256$"
                + ITERATIONS
                + "$"
                + Base64.getEncoder().encodeToString(salt)
                + "$"
                + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean verifyPassword(
            String password,
            String storedHash) {

        if (password == null || storedHash == null) {
            return false;
        }

        try {
            String[] parts = storedHash.split("\\$");

            if (parts.length != 4) {
                return false;
            }

            int iterations = Integer.parseInt(parts[1]);

            byte[] salt =
                    Base64.getDecoder().decode(parts[2]);

            byte[] expected =
                    Base64.getDecoder().decode(parts[3]);

            byte[] actual =
                    derive(
                            password.toCharArray(),
                            salt,
                            iterations,
                            expected.length * 8
                    );

            return constantTimeEquals(expected, actual);

        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] derive(
            char[] password,
            byte[] salt) {

        return derive(
                password,
                salt,
                ITERATIONS,
                KEY_LENGTH
        );
    }

    private static byte[] derive(
            char[] password,
            byte[] salt,
            int iterations,
            int keyLength) {

        try {
            PBEKeySpec spec =
                    new PBEKeySpec(
                            password,
                            salt,
                            iterations,
                            keyLength
                    );

            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance(
                            "PBKDF2WithHmacSHA256"
                    );

            return factory.generateSecret(spec)
                    .getEncoded();

        } catch (
                NoSuchAlgorithmException
                | InvalidKeySpecException e) {

            throw new IllegalStateException(
                    "Password hashing is unavailable.",
                    e
            );
        }
    }

    private static boolean constantTimeEquals(
            byte[] a,
            byte[] b) {

        if (a == null || b == null) {
            return false;
        }

        int result = a.length ^ b.length;

        int length = Math.min(a.length, b.length);

        for (int i = 0; i < length; i++) {
            result |= a[i] ^ b[i];
        }

        return result == 0;
    }
}