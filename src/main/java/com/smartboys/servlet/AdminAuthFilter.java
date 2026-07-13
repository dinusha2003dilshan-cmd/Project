package com.smartboys.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Role-Based Access Control gate for /admin/* (except the login/logout endpoints).
 * Only requests carrying a valid admin session reach protected admin servlets/JSPs.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        boolean isPublic = path.equals("/admin/login") || path.startsWith("/admin/login.jsp");

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("adminId") != null;

        if (isPublic || loggedIn) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
        }
    }
}
