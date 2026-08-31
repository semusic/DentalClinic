package com.dentalclinic.model;

import java.time.LocalDateTime;

public class DoctorApprovalToken {

    private String rawToken;
    private String tokenHash;
    private LocalDateTime expiresAt;
    private LocalDateTime usedAt;

    public DoctorApprovalToken() {
    }

    public DoctorApprovalToken(
            String rawToken,
            String tokenHash,
            LocalDateTime expiresAt) {

        this.rawToken = rawToken;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
    }

    public String getRawToken() {
        return rawToken;
    }

    public void setRawToken(String rawToken) {
        this.rawToken = rawToken;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public void setTokenHash(String tokenHash) {
        this.tokenHash = tokenHash;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }
}