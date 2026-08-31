package com.dentalclinic.pattern.bridge;

public class EmailNotificationSender
        extends NotificationSender {

    public EmailNotificationSender() {

        super(
                new EmailNotificationDelivery()
        );
    }
}