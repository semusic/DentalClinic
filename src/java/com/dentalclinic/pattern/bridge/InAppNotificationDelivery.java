package com.dentalclinic.pattern.bridge;

import com.dentalclinic.model.Notification;

import java.time.LocalDateTime;

public class InAppNotificationDelivery
        implements NotificationDelivery {

    @Override
    public void deliver(
            Notification notification
    ) {

        /*
         * In-app notification delivery is completed when
         * the notification is available in the database.
         */
        notification.setChannel("IN_APP");

        notification.setNotificationStatus(
                "SENT"
        );

        notification.setSentAt(
                LocalDateTime.now()
        );
    }

    @Override
    public String getProviderName() {
        return "IN_APP_DATABASE";
    }
}