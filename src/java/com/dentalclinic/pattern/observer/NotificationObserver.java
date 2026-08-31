package com.dentalclinic.pattern.observer;

import com.dentalclinic.model.Notification;

public interface NotificationObserver {

    void onNotification(
            Notification notification
    );
}