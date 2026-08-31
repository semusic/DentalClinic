package com.dentalclinic.pattern.strategy;

import com.dentalclinic.model.Notification;
import com.dentalclinic.pattern.bridge.EmailNotificationSender;
import com.dentalclinic.pattern.bridge.NotificationSender;

public class EmailNotificationStrategy
        implements NotificationStrategy {

    private final NotificationSender sender;

    public EmailNotificationStrategy() {

        this.sender =
                new EmailNotificationSender();
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
                    "Email notification failed: "
                    + e.getMessage()
            );
        }
    }

    @Override
    public String getChannel() {
        return "EMAIL";
    }
}