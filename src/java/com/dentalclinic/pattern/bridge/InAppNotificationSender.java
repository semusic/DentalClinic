package com.dentalclinic.pattern.bridge;

public class InAppNotificationSender
        extends NotificationSender {

    public InAppNotificationSender() {

        super(
                new InAppNotificationDelivery()
        );
    }
}