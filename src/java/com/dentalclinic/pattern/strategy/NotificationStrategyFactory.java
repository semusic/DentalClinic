package com.dentalclinic.pattern.strategy;

public class NotificationStrategyFactory {

    public NotificationStrategy create(
            String channel) {

        if (channel == null
                || channel.isBlank()) {

            throw new IllegalArgumentException(
                    "Notification channel is required."
            );
        }

        return switch (
                channel.toUpperCase()
        ) {

            case "IN_APP" ->
                    new InAppNotificationStrategy();

            case "EMAIL" ->
                    new EmailNotificationStrategy();

            default ->
                    throw new IllegalArgumentException(
                            "Unsupported notification channel: "
                            + channel
                    );
        };
    }
}