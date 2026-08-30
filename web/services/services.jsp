<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.pattern.composite.DentalServiceComponent" %>
<%@ page import="com.dentalclinic.pattern.composite.DentalServiceLeaf" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DentalCare | Services</title>

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
            padding: 26px 50px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            font-size: 26px;
            font-weight: 700;
            color: #1677a5;
        }

        .header a {
            text-decoration: none;
            color: #1677a5;
            font-weight: 600;
        }

        .hero {
            text-align: center;
            padding: 55px 20px 30px;
        }

        .hero h1 {
            font-size: 40px;
            margin-bottom: 10px;
            color: #183b56;
        }

        .hero p {
            color: #718096;
            font-size: 17px;
        }

        .container {
            max-width: 1150px;
            margin: 0 auto;
            padding: 20px;
        }

        .category {
            margin: 35px 0;
        }

        .category-title {
            font-size: 25px;
            margin-bottom: 18px;
            color: #1677a5;
        }

        .services-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(270px, 1fr));
            gap: 20px;
        }

        .service-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow:
                0 10px 30px rgba(0, 0, 0, 0.06);

            border: 1px solid #edf2f7;
        }

        .service-card h3 {
            margin-top: 0;
            margin-bottom: 10px;
            color: #1f2937;
        }

        .service-description {
            color: #718096;
            line-height: 1.6;
            min-height: 55px;
        }

        .service-meta {
            margin-top: 15px;
            color: #718096;
            font-size: 14px;
        }

        .price {
            margin-top: 15px;
            font-size: 20px;
            font-weight: 700;
            color: #1677a5;
        }

        .request-button {
            display: inline-block;
            margin-top: 18px;
            padding: 11px 18px;
            border-radius: 9px;
            background: #1677a5;
            color: white;
            text-decoration: none;
            font-weight: 600;
        }

        .request-button:hover {
            opacity: 0.9;
        }

        .empty {
            text-align: center;
            padding: 50px;
            color: #718096;
        }

        @media (max-width: 650px) {

            .header {
                padding: 20px;
            }

            .hero h1 {
                font-size: 30px;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        DentalCare
    </div>

    <a href="${pageContext.request.contextPath}/login">
        Sign In
    </a>

</header>


<section class="hero">

    <h1>Our Dental Services</h1>

    <p>
        Professional care designed around
        your dental needs.
    </p>

</section>


<div class="container">

<%
    DentalServiceComponent catalog =
            (DentalServiceComponent)
                    request.getAttribute(
                            "serviceCatalog"
                    );

    if (catalog == null
            || catalog.getChildren().isEmpty()) {
%>

    <div class="empty">
        No dental services are currently available.
    </div>

<%
    } else {

        for (DentalServiceComponent category :
                catalog.getChildren()) {
%>

    <section class="category">

        <h2 class="category-title">
            <%= category.getName() %>
        </h2>

        <div class="services-grid">

<%
            for (DentalServiceComponent component :
                    category.getChildren()) {

                DentalServiceLeaf service =
                        (DentalServiceLeaf) component;
%>

            <article class="service-card">

                <h3>
                    <%= service.getName() %>
                </h3>

                <div class="service-description">
                    <%= service.getDescription() == null
                            ? "Professional dental care service."
                            : service.getDescription() %>
                </div>

                <div class="service-meta">
                    Appointment available
                </div>

                <div class="price">
                    LKR <%= service.getPrice() %>
                </div>

                <a
                    class="request-button"
                    href="${pageContext.request.contextPath}/register">
                    Create Account & Request
                </a>

            </article>

<%
            }
%>

        </div>

    </section>

<%
        }
    }
%>

</div>

</body>
</html>