<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Notification" %>

<%
    List<Notification> notifications =
            (List<Notification>)
                    request.getAttribute(
                            "notifications"
                    );
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Notifications
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f9fc;
            color: #263238;
        }

        .header {
            background: white;
            padding: 20px 40px;
            border-bottom: 1px solid #e5e7eb;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            color: #1677a5;
            font-size: 25px;
            font-weight: 700;
        }

        .back {
            text-decoration: none;
            color: #1677a5;
            font-weight: 600;
        }

        .container {
            max-width: 950px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h1 {
            color: #183b56;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 28px;
        }

        .notification {
            background: white;
            padding: 22px;
            border-radius: 14px;
            margin-bottom: 15px;

            box-shadow:
                0 7px 25px rgba(0, 0, 0, 0.05);

            border: 1px solid #edf2f7;
        }

        .notification.unread {
            border-left: 4px solid #1677a5;
        }

        .top {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }

        .subject {
            font-size: 18px;
            font-weight: 700;
            color: #183b56;
        }

        .type {
            font-size: 12px;
            padding: 6px 10px;
            border-radius: 15px;
            background: #eaf4fb;
            color: #1677a5;
            font-weight: 700;
        }

        .message {
            margin-top: 12px;
            color: #4a5568;
            line-height: 1.7;
        }

        .meta {
            margin-top: 15px;
            color: #718096;
            font-size: 12px;
        }

        .empty {
            background: white;
            padding: 55px 30px;
            border-radius: 16px;
            text-align: center;
            color: #718096;
        }

        @media (max-width: 650px) {

            .top {
                flex-direction: column;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        DentalCare
    </div>

    <a
        class="back"
        href="${pageContext.request.contextPath}/patient/dashboard">

        Dashboard

    </a>

</header>


<main class="container">

    <h1>
        Notifications
    </h1>

    <p class="subtitle">
        Appointment updates and important messages
        from DentalCare.
    </p>


    <%
        if (notifications == null
                || notifications.isEmpty()) {
    %>

        <div class="empty">

            <h2>
                No notifications
            </h2>

            <p>
                You currently have no notifications.
            </p>

        </div>

    <%
        } else {

            for (Notification notification :
                    notifications) {

                boolean unread =
                        notification.getReadAt() == null;
    %>

        <article
            class="notification <%= unread
                    ? "unread"
                    : "" %>">

            <div class="top">

                <div class="subject">

                    <%= notification.getSubject() == null
                            ? "DentalCare Notification"
                            : notification.getSubject() %>

                </div>

                <div class="type">

                    <%= notification.getNotificationType() %>

                </div>

            </div>


            <div class="message">

                <%= notification.getMessage() %>

            </div>


            <div class="meta">

                <%
                    if (notification.getAppointmentId()
                            != null) {
                %>

                    Appointment #
                    <%= notification.getAppointmentId() %>
                    &nbsp; • &nbsp;

                <%
                    }
                %>

                <%= notification.getCreatedAt() %>

                &nbsp; • &nbsp;

                <%= notification.getNotificationStatus() %>

            </div>

        </article>

    <%
            }
        }
    %>

</main>

</body>

</html>