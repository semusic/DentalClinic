package com.dentalclinic.pattern.bridge;

import com.dentalclinic.model.Notification;
import java.time.LocalDateTime;

public class EmailNotificationDelivery implements NotificationDelivery {

    private static final String PUBLIC_BASE_URL =
            System.getenv("PUBLIC_BASE_URL") != null && !System.getenv("PUBLIC_BASE_URL").isBlank()
                    ? System.getenv("PUBLIC_BASE_URL")
                    : "http://localhost:8080/DentalClinic";

    @Override
    public void deliver(Notification notification) {
        notification.setChannel("EMAIL");
        notification.setNotificationStatus("SENT");
        notification.setSentAt(LocalDateTime.now());

        System.out.println("==================================================");
        System.out.println("📬 DOCTOR EMAIL NOTIFICATION DISPATCHED");
        System.out.println("Provider: " + getProviderName());
        System.out.println("Public Base URL: " + PUBLIC_BASE_URL);
        System.out.println("Recipient User ID: " + notification.getRecipientUserId());
        System.out.println("Subject: " + notification.getSubject());
        System.out.println("Body:");
        System.out.println(notification.getMessage());
        System.out.println("==================================================");
    }

    @Override
    public String getProviderName() {
        return "SMTP_CONFIGURED_MAILER";
    }

    public static String getPublicBaseUrl() {
        return PUBLIC_BASE_URL;
    }
}