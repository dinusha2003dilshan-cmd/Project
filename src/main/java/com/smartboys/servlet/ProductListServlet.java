package com.smartboys.servlet;

import com.smartboys.dao.CategoryDAO;
import com.smartboys.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

/** Backs the Advanced Filtering Engine: category, age group, price range, color, keyword. */
@WebServlet("/products")
public class ProductListServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer categoryId = parseInt(req.getParameter("categoryId"));
        BigDecimal minPrice = parseDecimal(req.getParameter("minPrice"));
        BigDecimal maxPrice = parseDecimal(req.getParameter("maxPrice"));
        String color = req.getParameter("color");
        Integer age = parseInt(req.getParameter("age"));
        String keyword = req.getParameter("keyword");

        req.setAttribute("products",
                productDAO.searchProducts(categoryId, minPrice, maxPrice, color, age, keyword));
        req.setAttribute("categories", categoryDAO.getAllCategories());
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedColor", color);
        req.setAttribute("selectedAge", age);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/products.jsp").forward(req, resp);
    }

    private Integer parseInt(String s) {
        try { return (s == null || s.isBlank()) ? null : Integer.valueOf(s); }
        catch (NumberFormatException e) { return null; }
    }

    private BigDecimal parseDecimal(String s) {
        try { return (s == null || s.isBlank()) ? null : new BigDecimal(s); }
        catch (NumberFormatException e) { return null; }
    }
}
