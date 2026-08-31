package com.dentalclinic.pattern.bridge;

import com.dentalclinic.model.Notification;

public class EmailNotificationDelivery
        implements NotificationDelivery {

    @Override
    public void deliver(
            Notification notification
    ) {

        /*
         * Email delivery is deliberately kept behind this
         * abstraction. The SMTP/provider configuration will
         * be connected later without changing the
         * notification strategies.
         *
         * Until a provider is configured, the notification
         * remains PENDING for email delivery.
         */
        notification.setChannel("EMAIL");

        notification.setNotificationStatus(
                "PENDING"
        );

        System.out.println(
                "Email notification queued for user "
                + notification.getRecipientUserId()
        );
    }

    @Override
    public String getProviderName() {
        return "SMTP";
    }
}