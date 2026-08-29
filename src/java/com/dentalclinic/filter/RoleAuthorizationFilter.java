package com.dentalclinic.filter;

import com.dentalclinic.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(
        urlPatterns = {
                "/patient/*",
                "/assistant/*",
                "/cashier/*",
                "/admin/*"
        }
)
public class RoleAuthorizationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        if (session == null) {
            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login"
            );
            return;
        }

        User user =
                (User) session.getAttribute(
                        "authenticatedUser"
                );

        if (user == null) {
            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login"
            );
            return;
        }

        String uri = httpRequest.getRequestURI();

        String role = user.getRoleName();

        boolean authorized =
                (uri.contains("/patient/")
                        && role.equals("PATIENT"))
                || (uri.contains("/assistant/")
                        && role.equals("ASSISTANT"))
                || (uri.contains("/cashier/")
                        && role.equals("CASHIER"))
                || (uri.contains("/admin/")
                        && role.equals("ADMIN"));

        if (!authorized) {

            httpResponse.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this resource."
            );

            return;
        }

        chain.doFilter(request, response);
    }
}