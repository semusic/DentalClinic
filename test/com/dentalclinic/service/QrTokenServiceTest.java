package com.dentalclinic.service;

import org.junit.Test;

import static org.junit.Assert.*;

public class QrTokenServiceTest {

    private final QrTokenService service =
            new QrTokenService();

    @Test
    public void shouldGenerateNonEmptyToken() {

        String token =
                service.generateToken();

        assertNotNull(token);
        assertFalse(token.isBlank());
    }

    @Test
    public void shouldGenerateTokensOfExpectedLength() {

        String token =
                service.generateToken();

        assertEquals(
                43,
                token.length()
        );
    }

    @Test
    public void shouldGenerateDifferentTokens() {

        String token1 =
                service.generateToken();

        String token2 =
                service.generateToken();

        assertNotEquals(
                token1,
                token2
        );
    }

    @Test
    public void shouldGenerateSameHashForSameToken() {

        String token =
                service.generateToken();

        String hash1 =
                service.hashToken(token);

        String hash2 =
                service.hashToken(token);

        assertEquals(
                hash1,
                hash2
        );
    }

    @Test
    public void shouldGenerateDifferentHashesForDifferentTokens() {

        String token1 =
                service.generateToken();

        String token2 =
                service.generateToken();

        String hash1 =
                service.hashToken(token1);

        String hash2 =
                service.hashToken(token2);

        assertNotEquals(
                hash1,
                hash2
        );
    }

    @Test(expected = IllegalArgumentException.class)
    public void shouldRejectNullToken() {

        service.hashToken(null);
    }

    @Test(expected = IllegalArgumentException.class)
    public void shouldRejectBlankToken() {

        service.hashToken("   ");
    }
}