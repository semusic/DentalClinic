<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="com.dentalclinic.dto.PatientRecordDTO" %>
<%@ page import="java.util.List" %>

<%
    PatientRecordDTO record =
            (PatientRecordDTO)
                    request.getAttribute("record");

    List<PatientRecordDTO.ServiceRecord>
            services =
            record.getServices();

    List<PatientRecordDTO.PaymentRecord>
            payments =
            record.getPayments();
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Patient Record
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

        .container {
            max-width: 950px;
            margin: 35px auto;
            padding: 20px;
        }

        .header {
            background: white;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 20px;

            box-shadow:
                0 8px 28px rgba(0,0,0,0.05);
        }

        .brand {
            color: #1677a5;
            font-size: 26px;
            font-weight: 700;
        }

        h1 {
            margin: 8px 0;
            color: #183b56;
        }

        .muted {
            color: #718096;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            margin-bottom: 20px;

            box-shadow:
                0 8px 28px rgba(0,0,0,0.05);
        }

        h2 {
            margin-top: 0;
            color: #183b56;
        }

        .details {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
            gap: 14px;
        }

        .detail {
            background: #f8fafc;
            padding: 15px;
            border-radius: 10px;
        }

        .label {
            font-size: 12px;
            color: #718096;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 700;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 13px 8px;
            border-bottom:
                1px solid #edf2f7;
            text-align: left;
        }

        th {
            color: #718096;
            font-size: 12px;
        }

        .right {
            text-align: right;
        }

        .paid {
            padding: 18px;
            background: #edf9f2;
            border-radius: 12px;
            color: #18794e;
        }

        .paid-amount {
            font-size: 25px;
            font-weight: 700;
            margin-top: 5px;
        }

        .medicine {
            padding: 16px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .notes {
            white-space: pre-wrap;
            background: #f8fafc;
            border-radius: 10px;
            padding: 17px;
            line-height: 1.6;
        }

        .footer {
            text-align: center;
            color: #718096;
            font-size: 12px;
            padding: 15px;
        }

        @media (max-width: 700px) {

            .details {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 12px;
            }

            .card,
            .header {
                padding: 20px;
            }

            table {
                font-size: 13px;
            }
        }

    </style>

</head>

<body>

<main class="container">

    <section class="header">

        <div class="brand">
            DentalCare
        </div>

        <h1>
            Patient Visit Record
        </h1>

        <div class="muted">

            Secure record accessed from the patient's
            clinic QR code.

        </div>

    </section>


    <!-- PATIENT -->

    <section class="card">

        <h2>
            Patient
        </h2>

        <div class="details">

            <div class="detail">

                <div class="label">
                    Name
                </div>

                <div class="value">
                    <%= record.getPatientName() %>
                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Phone
                </div>

                <div class="value">
                    <%= record.getPatientPhone() %>
                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Email
                </div>

                <div class="value">
                    <%= record.getPatientEmail() %>
                </div>

            </div>

        </div>

    </section>


    <!-- VISIT -->

    <section class="card">

        <h2>
            Visit Information
        </h2>

        <div class="details">

            <div class="detail">

                <div class="label">
                    Visit ID
                </div>

                <div class="value">
                    #<%= record.getVisitId() %>
                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Appointment
                </div>

                <div class="value">

                    <%= record.getAppointmentDateTime()
                            == null
                            ? "Not available"
                            : record
                                .getAppointmentDateTime() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Doctor
                </div>

                <div class="value">
                    <%= record.getDoctorName() %>
                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Checked In
                </div>

                <div class="value">

                    <%= record.getCheckedInAt()
                            == null
                            ? "Not recorded"
                            : record.getCheckedInAt() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Consultation Started
                </div>

                <div class="value">

                    <%= record
                            .getConsultationStartedAt()
                            == null
                            ? "Not recorded"
                            : record
                                .getConsultationStartedAt() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Consultation Completed
                </div>

                <div class="value">

                    <%= record
                            .getConsultationCompletedAt()
                            == null
                            ? "Not recorded"
                            : record
                                .getConsultationCompletedAt() %>

                </div>

            </div>

        </div>

    </section>


    <!-- SERVICES -->

    <section class="card">

        <h2>
            Services Performed
        </h2>

        <table>

            <thead>

                <tr>

                    <th>
                        Service
                    </th>

                    <th>
                        Quantity
                    </th>

                    <th class="right">
                        Unit Price
                    </th>

                    <th class="right">
                        Total
                    </th>

                </tr>

            </thead>

            <tbody>

            <%
                if (services == null
                        || services.isEmpty()) {
            %>

                <tr>

                    <td colspan="4">
                        No services recorded.
                    </td>

                </tr>

            <%
                } else {

                    for (
                        PatientRecordDTO.ServiceRecord
                                service :
                        services
                    ) {
            %>

                <tr>

                    <td>
                        <%= service.getServiceName() %>
                    </td>

                    <td>
                        <%= service.getQuantity() %>
                    </td>

                    <td class="right">

                        LKR
                        <%= service.getUnitPrice() %>

                    </td>

                    <td class="right">

                        LKR
                        <%= service.getLineTotal() %>

                    </td>

                </tr>

            <%
                    }
                }
            %>

            </tbody>

        </table>

    </section>


    <!-- PAYMENT -->

    <section class="card">

        <h2>
            Payment
        </h2>


        <div class="details">

            <div class="detail">

                <div class="label">
                    Invoice
                </div>

                <div class="value">

                    <%= record.getInvoiceNumber() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Invoice Total
                </div>

                <div class="value">

                    LKR
                    <%= record.getInvoiceTotal() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Receipt
                </div>

                <div class="value">

                    <%= record.getLatestReceiptNumber()
                            == null
                            ? "Not available"
                            : record
                                .getLatestReceiptNumber() %>

                </div>

            </div>

        </div>


        <br>


        <div class="paid">

            <div>
                TOTAL PAID
            </div>

            <div class="paid-amount">

                LKR
                <%= record.getTotalPaid() %>

            </div>

        </div>


        <br>


        <h3>
            Payment Transactions
        </h3>


        <table>

            <thead>

                <tr>

                    <th>
                        Reference
                    </th>

                    <th>
                        Method
                    </th>

                    <th>
                        Amount
                    </th>

                    <th>
                        Date
                    </th>

                </tr>

            </thead>

            <tbody>

            <%
                if (payments == null
                        || payments.isEmpty()) {
            %>

                <tr>

                    <td colspan="4">
                        No payment transactions found.
                    </td>

                </tr>

            <%
                } else {

                    for (
                        PatientRecordDTO.PaymentRecord
                                payment :
                        payments
                    ) {
            %>

                <tr>

                    <td>

                        <%= payment
                                .getPaymentReference() %>

                    </td>

                    <td>

                        <%= payment
                                .getPaymentMethod() %>

                    </td>

                    <td>

                        LKR
                        <%= payment.getAmount() %>

                    </td>

                    <td>

                        <%= payment
                                .getTransactionDate() %>

                    </td>

                </tr>

            <%
                    }
                }
            %>

            </tbody>

        </table>

    </section>


    <!-- MEDICINE -->

    <section class="card">

        <h2>
            Medicine
        </h2>

        <div class="medicine">

            Medicine prescribed:

            <strong>

                <%= record.isMedicinePrescribed()
                        ? "Yes"
                        : "No" %>

            </strong>

            <p>

                Medicine names and dosages are not
                recorded in the system. The doctor provides
                the medication instructions directly to
                the patient.

            </p>

        </div>

    </section>


    <!-- NOTES / FOLLOW-UP -->

    <section class="card">

        <h2>
            Clinical / Follow-up Notes
        </h2>

        <div class="notes">

            <%= record.getVisitNotes()
                    == null
                    || record.getVisitNotes().isBlank()
                    ? "No follow-up or clinical notes recorded."
                    : record.getVisitNotes() %>

        </div>

    </section>


    <div class="footer">

        DentalCare • Patient record generated from
        the clinic QR system.

    </div>

</main>

</body>

</html>