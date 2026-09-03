package com.dentalclinic.util;

import org.junit.Test;

import static org.junit.Assert.*;

public class PasswordHasherTest {

    @Test
    public void shouldHashPasswordSuccessfully() {

        String hash =
                PasswordHasher.hashPassword("DentalCare@123");

        assertNotNull(hash);
        assertFalse(hash.isBlank());

        assertTrue(
                hash.startsWith("PBKDF2-SHA256$")
        );
    }

    @Test
    public void shouldVerifyCorrectPassword() {

        String password =
                "DentalCare@123";

        String hash =
                PasswordHasher.hashPassword(password);

        assertTrue(
                PasswordHasher.verifyPassword(
                        password,
                        hash
                )
        );
    }

    @Test
    public void shouldRejectIncorrectPassword() {

        String hash =
                PasswordHasher.hashPassword(
                        "DentalCare@123"
                );

        assertFalse(
                PasswordHasher.verifyPassword(
                        "WrongPassword@123",
                        hash
                )
        );
    }

    @Test
    public void shouldGenerateDifferentHashesForSamePassword() {

        String hash1 =
                PasswordHasher.hashPassword(
                        "DentalCare@123"
                );

        String hash2 =
                PasswordHasher.hashPassword(
                        "DentalCare@123"
                );

        assertNotEquals(
                hash1,
                hash2
        );
    }

    @Test
    public void shouldNotStorePlainTextPassword() {

        String password =
                "DentalCare@123";

        String hash =
                PasswordHasher.hashPassword(
                        password
                );

        assertNotEquals(
                password,
                hash
        );
    }

    @Test
    public void shouldRejectNullPassword() {

        assertFalse(
                PasswordHasher.verifyPassword(
                        null,
                        "invalid"
                )
        );
    }

    @Test
    public void shouldRejectNullStoredHash() {

        assertFalse(
                PasswordHasher.verifyPassword(
                        "DentalCare@123",
                        null
                )
        );
    }

    @Test(expected = IllegalArgumentException.class)
    public void shouldRejectBlankPasswordWhenHashing() {

        PasswordHasher.hashPassword("   ");
    }

    @Test
    public void shouldRejectMalformedStoredHash() {

        assertFalse(
                PasswordHasher.verifyPassword(
                        "DentalCare@123",
                        "not-a-valid-pbkdf2-hash"
                )
        );
    }

    @Test
    public void shouldRejectTamperedStoredHash() {

        String hash =
                PasswordHasher.hashPassword(
                        "DentalCare@123"
                );

        String tamperedHash =
                hash.substring(
                        0,
                        hash.length() - 1
                ) + "X";

        assertFalse(
                PasswordHasher.verifyPassword(
                        "DentalCare@123",
                        tamperedHash
                )
        );
    }
}