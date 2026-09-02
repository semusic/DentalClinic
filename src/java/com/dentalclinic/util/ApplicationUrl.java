package com.dentalclinic.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;

public final class ApplicationUrl {

    private static final String
            PUBLIC_BASE_URL =
            "PUBLIC_BASE_URL";

    private ApplicationUrl() {
    }

    public static String getBaseUrl(
            ServletContext context,
            HttpServletRequest request) {

        String configured =
                context.getInitParameter(
                        PUBLIC_BASE_URL
                );

        String contextPath =
                request.getContextPath();

        /*
         * If a public URL has been configured,
         * use it.
         */
        if (configured != null
                && !configured.isBlank()) {

            String base =
                    removeTrailingSlash(
                            configured.trim()
                    );

            /*
             * The configured value is the public
             * origin. Append the application
             * context automatically.
             */
            if (!contextPath.isBlank()
                    && !base.endsWith(
                            contextPath
                    )) {

                base += contextPath;
            }

            return base;
        }

        /*
         * Local development fallback.
         */
        StringBuilder url =
                new StringBuilder();

        url.append(
                request.getScheme()
        );

        url.append("://");

        url.append(
                request.getServerName()
        );

        int port =
                request.getServerPort();

        if (("http".equalsIgnoreCase(
                request.getScheme())
                && port != 80)
                ||
                ("https".equalsIgnoreCase(
                        request.getScheme())
                        && port != 443)) {

            url.append(":");
            url.append(port);
        }

        url.append(contextPath);

        return removeTrailingSlash(
                url.toString()
        );
    }

    private static String removeTrailingSlash(
            String value) {

        while (value.endsWith("/")) {

            value =
                    value.substring(
                            0,
                            value.length() - 1
                    );
        }

        return value;
    }
}