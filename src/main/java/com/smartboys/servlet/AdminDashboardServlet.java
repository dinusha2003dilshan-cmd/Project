package com.smartboys.servlet;

import com.smartboys.dao.OrderDAO;
import com.smartboys.dao.ProductDAO;
import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/** Sales Dashboard Analytics — revenue totals + Chart.js-ready JSON for bar/pie graphs. */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
        req.setAttribute("orderCount", orderDAO.getOrderCount());
        req.setAttribute("lowStockProducts", productDAO.getLowStockProducts());
        req.setAttribute("lowStockCount", productDAO.getLowStockProducts().size());

        // Daily revenue (last 14 days) for the bar/line chart
        List<Object[]> daily = orderDAO.getDailyRevenue(14);
        JSONArray dailyLabels = new JSONArray();
        JSONArray dailyValues = new JSONArray();
        for (Object[] row : daily) {
            dailyLabels.put(row[0].toString());
            dailyValues.put(row[1]);
        }
        JSONObject dailyChart = new JSONObject();
        dailyChart.put("labels", dailyLabels);
        dailyChart.put("values", dailyValues);
        req.setAttribute("dailyChartJson", dailyChart.toString());

        // Revenue by category for the pie chart
        List<Object[]> byCategory = orderDAO.getRevenueByCategory();
        JSONArray catLabels = new JSONArray();
        JSONArray catValues = new JSONArray();
        for (Object[] row : byCategory) {
            catLabels.put(row[0].toString());
            catValues.put(row[1]);
        }
        JSONObject catChart = new JSONObject();
        catChart.put("labels", catLabels);
        catChart.put("values", catValues);
        req.setAttribute("categoryChartJson", catChart.toString());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
