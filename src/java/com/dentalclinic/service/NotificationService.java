package com.dentalclinic.service;

import com.dentalclinic.model.Notification;

import java.sql.SQLException;
import java.util.List;

public interface NotificationService {

    int send(Notification notification)
            throws SQLException;

    List<Notification> getUserNotifications(
            int userId
    ) throws SQLException;

    int markAsRead(
            int notificationId,
            int userId
    ) throws SQLException;
}