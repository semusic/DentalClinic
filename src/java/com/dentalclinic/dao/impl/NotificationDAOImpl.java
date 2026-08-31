package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.NotificationDAO;
import com.dentalclinic.model.Notification;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl
        implements NotificationDAO {

    private static final String INSERT_NOTIFICATION = """
        INSERT INTO notifications
        (
            recipient_user_id,
            appointment_id,
            notification_type,
            channel,
            subject,
            message,
            notification_status,
            scheduled_at
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_RECIPIENT = """
        SELECT
            notification_id,
            recipient_user_id,
            appointment_id,
            notification_type,
            channel,
            subject,
            message,
            notification_status,
            scheduled_at,
            sent_at,
            read_at,
            retry_count,
            created_at,
            updated_at
        FROM notifications
        WHERE recipient_user_id = ?
        ORDER BY created_at DESC
        """;

    private static final String MARK_AS_READ = """
        UPDATE notifications
        SET
            read_at = CURRENT_TIMESTAMP,
            notification_status = 'READ'
        WHERE notification_id = ?
          AND recipient_user_id = ?
          AND read_at IS NULL
        """;
    
    private static final String UPDATE_DELIVERY_STATUS = """
    UPDATE notifications
    SET
        notification_status = ?,
        sent_at = ?
    WHERE notification_id = ?
    """;

    @Override
    public int save(
            Notification notification
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_NOTIFICATION,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    notification.getRecipientUserId()
            );

            if (notification.getAppointmentId() != null) {

                statement.setInt(
                        2,
                        notification.getAppointmentId()
                );

            } else {

                statement.setNull(
                        2,
                        java.sql.Types.INTEGER
                );
            }

            statement.setString(
                    3,
                    notification.getNotificationType()
            );

            statement.setString(
                    4,
                    notification.getChannel()
            );

            statement.setString(
                    5,
                    notification.getSubject()
            );

            statement.setString(
                    6,
                    notification.getMessage()
            );

            statement.setString(
                    7,
                    notification.getNotificationStatus()
            );

            if (notification.getScheduledAt() != null) {

                statement.setTimestamp(
                        8,
                        Timestamp.valueOf(
                                notification.getScheduledAt()
                        )
                );

            } else {

                statement.setNull(
                        8,
                        java.sql.Types.TIMESTAMP
                );
            }

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException(
                "Unable to create notification."
        );
    }

    @Override
    public List<Notification> findByRecipientUserId(
            int recipientUserId
    ) throws SQLException {

        List<Notification> notifications =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_RECIPIENT)) {

            statement.setInt(
                    1,
                    recipientUserId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    notifications.add(
                            mapNotification(
                                    resultSet
                            )
                    );
                }
            }
        }

        return notifications;
    }

    @Override
    public int markAsRead(
            int notificationId,
            int recipientUserId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             MARK_AS_READ)) {

            statement.setInt(
                    1,
                    notificationId
            );

            statement.setInt(
                    2,
                    recipientUserId
            );

            return statement.executeUpdate();
        }
    }

    private Notification mapNotification(
            ResultSet resultSet
    ) throws SQLException {

        Notification notification =
                new Notification();

        notification.setNotificationId(
                resultSet.getInt(
                        "notification_id"
                )
        );

        notification.setRecipientUserId(
                resultSet.getInt(
                        "recipient_user_id"
                )
        );

        int appointmentId =
                resultSet.getInt(
                        "appointment_id"
                );

        if (resultSet.wasNull()) {
            notification.setAppointmentId(null);
        } else {
            notification.setAppointmentId(
                    appointmentId
            );
        }

        notification.setNotificationType(
                resultSet.getString(
                        "notification_type"
                )
        );

        notification.setChannel(
                resultSet.getString(
                        "channel"
                )
        );

        notification.setSubject(
                resultSet.getString(
                        "subject"
                )
        );

        notification.setMessage(
                resultSet.getString(
                        "message"
                )
        );

        notification.setNotificationStatus(
                resultSet.getString(
                        "notification_status"
                )
        );

        Timestamp scheduledAt =
                resultSet.getTimestamp(
                        "scheduled_at"
                );

        if (scheduledAt != null) {

            notification.setScheduledAt(
                    scheduledAt.toLocalDateTime()
            );
        }

        Timestamp sentAt =
                resultSet.getTimestamp(
                        "sent_at"
                );

        if (sentAt != null) {

            notification.setSentAt(
                    sentAt.toLocalDateTime()
            );
        }

        Timestamp readAt =
                resultSet.getTimestamp(
                        "read_at"
                );

        if (readAt != null) {

            notification.setReadAt(
                    readAt.toLocalDateTime()
            );
        }

        notification.setRetryCount(
                resultSet.getInt(
                        "retry_count"
                )
        );

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            notification.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        Timestamp updatedAt =
                resultSet.getTimestamp(
                        "updated_at"
                );

        if (updatedAt != null) {

            notification.setUpdatedAt(
                    updatedAt.toLocalDateTime()
            );
        }

        return notification;
    }
    
    @Override
public int updateDeliveryStatus(
        int notificationId,
        String status,
        java.time.LocalDateTime sentAt
) throws SQLException {

    try (Connection connection =
                 DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(
                         UPDATE_DELIVERY_STATUS)) {

        statement.setString(
                1,
                status
        );

        if (sentAt != null) {

            statement.setTimestamp(
                    2,
                    Timestamp.valueOf(sentAt)
            );

        } else {

            statement.setNull(
                    2,
                    java.sql.Types.TIMESTAMP
            );
        }

        statement.setInt(
                3,
                notificationId
        );

        return statement.executeUpdate();
    }
}
}