package com.dentalclinic.pattern.bridge;

import com.dentalclinic.model.Notification;

public interface NotificationDelivery {

    void deliver(
            Notification notification
    ) throws Exception;

    String getProviderName();
}