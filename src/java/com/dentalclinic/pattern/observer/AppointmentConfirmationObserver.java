package com.dentalclinic.pattern.observer;

import com.dentalclinic.model.Notification;
import com.dentalclinic.service.NotificationService;
import com.dentalclinic.service.impl.NotificationServiceImpl;

public class AppointmentConfirmationObserver
        implements NotificationObserver {

    private final NotificationService notificationService;

    public AppointmentConfirmationObserver() {

        this.notificationService =
                new NotificationServiceImpl();
    }

    @Override
    public void onNotification(
            Notification notification) {

        try {

            notificationService.send(
                    notification
            );

        } catch (Exception e) {

            /*
             * Notification failure must not crash the
             * appointment business workflow.
             *
             * The notification record remains available
             * for retry handling later.
             */
            System.err.println(
                    "Notification delivery failed: "
                    + e.getMessage()
            );
        }
    }
}