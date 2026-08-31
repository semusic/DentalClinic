package com.dentalclinic.security;

import com.dentalclinic.model.DoctorApprovalToken;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;

public class ApprovalTokenGenerator {

    private static final int TOKEN_BYTES = 32;

    private static final int EXPIRY_HOURS = 48;

    private final SecureRandom secureRandom;

    public ApprovalTokenGenerator() {
        this.secureRandom =
                new SecureRandom();
    }

    public DoctorApprovalToken generate() {

        byte[] bytes =
                new byte[TOKEN_BYTES];

        secureRandom.nextBytes(bytes);

        String rawToken =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(bytes);

        String tokenHash =
                hash(rawToken);

        LocalDateTime expiresAt =
                LocalDateTime.now()
                        .plusHours(EXPIRY_HOURS);

        return new DoctorApprovalToken(
                rawToken,
                tokenHash,
                expiresAt
        );
    }

    public String hash(String rawToken) {

        if (rawToken == null
                || rawToken.isBlank()) {

            throw new IllegalArgumentException(
                    "Approval token is required."
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
                    "SHA-256 is not available.",
                    e
            );
        }
    }
}