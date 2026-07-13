package com.smartboys.servlet;

import com.smartboys.dao.ProductDAO;
import com.smartboys.dao.SizeChartDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/** The "Smart Size Assistant" — recommends a size from age/height/weight and shows matching stock. */
@WebServlet("/sizeAssistant")
public class SizeAssistantServlet extends HttpServlet {

    private final SizeChartDAO sizeChartDAO = new SizeChartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/sizeAssistant.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int age = Integer.parseInt(req.getParameter("age"));
            int height = Integer.parseInt(req.getParameter("height"));
            int weight = Integer.parseInt(req.getParameter("weight"));

            String recommendedSize = sizeChartDAO.recommendSize(age, height, weight);

            req.setAttribute("recommendedSize", recommendedSize);
            req.setAttribute("matchingProducts", productDAO.getProductsBySize(recommendedSize));
            req.setAttribute("age", age);
            req.setAttribute("height", height);
            req.setAttribute("weight", weight);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Please enter valid numeric age, height and weight.");
        }
        req.getRequestDispatcher("/sizeAssistant.jsp").forward(req, resp);
    }
}
