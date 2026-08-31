package com.dentalclinic.service.impl;

import com.dentalclinic.dao.NotificationDAO;
import com.dentalclinic.dao.impl.NotificationDAOImpl;
import com.dentalclinic.model.Notification;
import com.dentalclinic.pattern.strategy.NotificationStrategy;
import com.dentalclinic.pattern.strategy.NotificationStrategyFactory;
import com.dentalclinic.service.NotificationService;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class NotificationServiceImpl
        implements NotificationService {

    private final NotificationDAO notificationDAO;
    private final NotificationStrategyFactory
            strategyFactory;

    public NotificationServiceImpl() {

        this.notificationDAO =
                new NotificationDAOImpl();

        this.strategyFactory =
                new NotificationStrategyFactory();
    }

    @Override
    public int send(
            Notification notification
    ) throws SQLException {

        if (notification == null) {
            throw new IllegalArgumentException(
                    "Notification is required."
            );
        }

        if (notification.getRecipientUserId() <= 0) {
            throw new IllegalArgumentException(
                    "Recipient user is required."
            );
        }

        /*
         * Select the appropriate delivery strategy.
         */
        NotificationStrategy strategy =
                strategyFactory.create(
                        notification.getChannel()
                );

        /*
         * Store the notification first.
         */
        notification.setNotificationStatus(
                "PENDING"
        );

        int notificationId =
                notificationDAO.save(
                        notification
                );

        notification.setNotificationId(
                notificationId
        );

        /*
         * Perform channel-specific handling.
         */
        strategy.send(notification);

    notificationDAO.updateDeliveryStatus(
            notificationId,
            notification.getNotificationStatus(),
            notification.getSentAt()
    );

    return notificationId;
    }

    @Override
    public List<Notification> getUserNotifications(
            int userId
    ) throws SQLException {

        return notificationDAO
                .findByRecipientUserId(userId);
    }

    @Override
    public int markAsRead(
            int notificationId,
            int userId
    ) throws SQLException {

        return notificationDAO.markAsRead(
                notificationId,
                userId
        );
    }
}