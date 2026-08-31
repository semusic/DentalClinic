package com.dentalclinic.dao;

import com.dentalclinic.model.Notification;

import java.sql.SQLException;
import java.util.List;

public interface NotificationDAO {

    int save(
            Notification notification
    ) throws SQLException;

    List<Notification> findByRecipientUserId(
            int recipientUserId
    ) throws SQLException;

    int markAsRead(
            int notificationId,
            int recipientUserId
    ) throws SQLException;
    
    int updateDeliveryStatus(
        int notificationId,
        String status,
        java.time.LocalDateTime sentAt
    ) throws SQLException;
}