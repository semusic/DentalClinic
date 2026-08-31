package com.dentalclinic.pattern.bridge;

import com.dentalclinic.model.Notification;

public abstract class NotificationSender {

    protected final NotificationDelivery delivery;

    protected NotificationSender(
            NotificationDelivery delivery) {

        if (delivery == null) {
            throw new IllegalArgumentException(
                    "Notification delivery is required."
            );
        }

        this.delivery = delivery;
    }

    public void send(
            Notification notification
    ) throws Exception {

        if (notification == null) {
            throw new IllegalArgumentException(
                    "Notification is required."
            );
        }

        delivery.deliver(notification);
    }

    public String getProviderName() {
        return delivery.getProviderName();
    }
}