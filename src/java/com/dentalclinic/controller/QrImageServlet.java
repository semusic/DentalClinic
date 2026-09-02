package com.dentalclinic.controller;

import com.dentalclinic.dao.InvoiceDAO;
import com.dentalclinic.dao.impl.InvoiceDAOImpl;
import com.dentalclinic.service.QrTokenService;
import com.dentalclinic.model.Invoice;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import com.dentalclinic.util.ApplicationUrl;
import jakarta.servlet.http.HttpServletResponse;

import javax.imageio.ImageIO;

import java.awt.image.BufferedImage;
import java.io.IOException;

import java.util.HashMap;
import java.util.Map;

@WebServlet("/qr")
public class QrImageServlet
        extends HttpServlet {

    private InvoiceDAO invoiceDAO;
    private QrTokenService qrTokenService;

    @Override
    public void init() {

        invoiceDAO =
                new InvoiceDAOImpl();

        qrTokenService =
                new QrTokenService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String rawToken =
                request.getParameter("t");

        if (rawToken == null
                || rawToken.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "QR token is required."
            );

            return;
        }

        try {

            String tokenHash =
                    qrTokenService.hashToken(
                            rawToken
                    );

            Invoice invoice =
                    invoiceDAO
                            .findByQrTokenHash(
                                    tokenHash
                            )
                            .orElse(null);

            if (invoice == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "QR code is invalid."
                );

                return;
            }

            if (!"PAID".equalsIgnoreCase(
                    invoice.getInvoiceStatus())) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "QR is only available for paid invoices."
                );

                return;
            }

            if (!rawToken.equals(
                    invoice.getQrToken())) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Invalid QR token."
                );

                return;
            }
            
            String publicBaseUrl =
                    ApplicationUrl.getBaseUrl(
                            getServletContext(),
                            request
                    );

            String recordUrl =
                    publicBaseUrl
                    + "/patient-record?t="
                    + java.net.URLEncoder.encode(
                            rawToken,
                            java.nio.charset.StandardCharsets.UTF_8
                    );

            String contextPath =
                    request.getContextPath();

            

            Map<EncodeHintType, Object> hints =
                    new HashMap<>();

            hints.put(
                    EncodeHintType.ERROR_CORRECTION,
                    ErrorCorrectionLevel.M
            );

            hints.put(
                    EncodeHintType.CHARACTER_SET,
                    "UTF-8"
            );

            BitMatrix matrix =
                    new MultiFormatWriter()
                            .encode(
                                    recordUrl,
                                    BarcodeFormat.QR_CODE,
                                    320,
                                    320,
                                    hints
                            );

            BufferedImage image =
                    new BufferedImage(
                            320,
                            320,
                            BufferedImage.TYPE_INT_RGB
                    );

            for (int x = 0;
                 x < 320;
                 x++) {

                for (int y = 0;
                     y < 320;
                     y++) {

                    image.setRGB(
                            x,
                            y,
                            matrix.get(
                                    x,
                                    y
                            )
                                    ? 0xFF000000
                                    : 0xFFFFFFFF
                    );
                }
            }

            response.setContentType(
                    "image/png"
            );

            response.setHeader(
                    "Cache-Control",
                    "no-store"
            );

            ImageIO.write(
                    image,
                    "PNG",
                    response.getOutputStream()
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to generate QR code.",
                    e
            );
        }
    }
}