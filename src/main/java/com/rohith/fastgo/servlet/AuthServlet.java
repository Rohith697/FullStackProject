package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.UserDAO;
import com.rohith.fastgo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("logout".equalsIgnoreCase(action)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/home?msg=logged_out");
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("login".equalsIgnoreCase(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userDAO.authenticate(email, password);
            if (user != null) {
                session.setAttribute("user", user);
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("authError", "Invalid email or password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } else if ("register".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            if (userDAO.existsByEmail(email)) {
                request.setAttribute("registerError", "An account with email '" + email + "' already exists.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRole("USER");

            if (userDAO.register(user)) {
                User loggedIn = userDAO.authenticate(email, password);
                session.setAttribute("user", loggedIn != null ? loggedIn : user);
                response.sendRedirect(request.getContextPath() + "/home?registered=true");
            } else {
                request.setAttribute("registerError", "Registration failed. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }
}
