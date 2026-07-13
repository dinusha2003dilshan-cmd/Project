package com.smartboys.servlet;

import com.smartboys.dao.ProductDAO;
import com.smartboys.model.CartItem;
import com.smartboys.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Session-based Interactive Shopping Cart.
 * action=add | update | remove | view
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = getCart(session);
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int qty = parseQty(req.getParameter("qty"));
            Product p = productDAO.getProductById(productId);
            if (p != null) {
                if (cart.containsKey(productId)) {
                    cart.get(productId).setQuantity(cart.get(productId).getQuantity() + qty);
                } else {
                    cart.put(productId, new CartItem(p.getProductId(), p.getProductName(),
                            p.getImagePath(), p.getPrice(), qty));
                }
            }
        } else if ("update".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int qty = parseQty(req.getParameter("qty"));
            if (cart.containsKey(productId)) {
                if (qty <= 0) cart.remove(productId);
                else cart.get(productId).setQuantity(qty);
            }
        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            cart.remove(productId);
        } else if ("clear".equals(action)) {
            cart.clear();
        }

        BigDecimal subtotal = cart.values().stream()
                .map(CartItem::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        req.setAttribute("cartItems", cart.values());
        req.setAttribute("subtotal", subtotal);

        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    private int parseQty(String s) {
        try { int q = Integer.parseInt(s); return Math.max(q, 0); }
        catch (Exception e) { return 1; }
    }
}
