package com.dentalclinic.pattern.strategy;

import com.dentalclinic.model.Notification;

public interface NotificationStrategy {

    void send(Notification notification);

    String getChannel();
}