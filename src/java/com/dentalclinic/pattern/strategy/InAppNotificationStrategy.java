package com.dentalclinic.pattern.strategy;

import com.dentalclinic.model.Notification;
import com.dentalclinic.pattern.bridge.InAppNotificationSender;
import com.dentalclinic.pattern.bridge.NotificationSender;

public class InAppNotificationStrategy
        implements NotificationStrategy {

    private final NotificationSender sender;

    public InAppNotificationStrategy() {

        this.sender =
                new InAppNotificationSender();
    }

    @Override
    public void send(
            Notification notification) {

        try {

            sender.send(notification);

        } catch (Exception e) {

            notification.setNotificationStatus(
                    "FAILED"
            );

            System.err.println(
                    "In-app notification failed: "
                    + e.getMessage()
            );
        }
    }

    @Override
    public String getChannel() {
        return "IN_APP";
    }
}