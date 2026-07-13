package com.smartboys.servlet;

import com.smartboys.dao.CategoryDAO;
import com.smartboys.dao.ProductDAO;
import com.smartboys.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;

/**
 * Dynamic Product Management (CRUD) for admins.
 * action=list|new|create|edit|update|delete ; supports image upload (multipart).
 */
@WebServlet("/admin/products")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        action = (action == null) ? "list" : action;

        switch (action) {
            case "new" -> {
                req.setAttribute("categories", categoryDAO.getAllCategories());
                req.getRequestDispatcher("/admin/productForm.jsp").forward(req, resp);
            }
            case "edit" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("product", productDAO.getProductById(id));
                req.setAttribute("categories", categoryDAO.getAllCategories());
                req.getRequestDispatcher("/admin/productForm.jsp").forward(req, resp);
            }
            case "delete" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                productDAO.deleteProduct(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
            default -> {
                req.setAttribute("products", productDAO.getAllProductsForAdmin());
                req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Product p = new Product();
        String idParam = req.getParameter("productId");
        if (idParam != null && !idParam.isBlank()) p.setProductId(Integer.parseInt(idParam));

        p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        p.setProductName(req.getParameter("productName"));
        p.setDescription(req.getParameter("description"));
        p.setPrice(new BigDecimal(req.getParameter("price")));
        p.setColor(req.getParameter("color"));
        p.setSizeLabel(req.getParameter("sizeLabel"));
        p.setMinAge(Integer.parseInt(req.getParameter("minAge")));
        p.setMaxAge(Integer.parseInt(req.getParameter("maxAge")));
        p.setStockQty(Integer.parseInt(req.getParameter("stockQty")));
        p.setLowStockLimit(Integer.parseInt(req.getParameter("lowStockLimit")));
        p.setActive(req.getParameter("active") != null);

        String uploadedImagePath = handleImageUpload(req);
        if (uploadedImagePath != null) {
            p.setImagePath(uploadedImagePath);
        } else {
            String existing = req.getParameter("existingImagePath");
            p.setImagePath(existing);
        }

        if (idParam != null && !idParam.isBlank()) {
            productDAO.updateProduct(p);
        } else {
            productDAO.addProduct(p);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    /** Saves an uploaded product image under /images/products and returns its relative web path. */
    private String handleImageUpload(HttpServletRequest req) throws IOException, ServletException {
        Part filePart = req.getPart("imageFile");
        if (filePart == null || filePart.getSize() == 0) return null;

        // Basic server-side validations
        final long MAX_SIZE = 5L * 1024L * 1024L; // 5MB (matches @MultipartConfig)
        if (filePart.getSize() > MAX_SIZE) {
            getServletContext().log("Uploaded file exceeds max allowed size: " + filePart.getSize());
            return null;
        }

        final Set<String> allowed = Set.of("image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp");
        String contentType = filePart.getContentType();
        if (contentType == null || !allowed.contains(contentType.toLowerCase())) {
            getServletContext().log("Rejected upload with content-type: " + contentType);
            return null;
        }

        String original = filePart.getSubmittedFileName();

        String ext;
        switch (contentType.toLowerCase()) {
            case "image/png" -> ext = ".png";
            case "image/gif" -> ext = ".gif";
            case "image/webp" -> ext = ".webp";
            default -> ext = ".jpg"; // covers image/jpeg and image/jpg
        }

        // Fallback: if the original filename had a stronger extension, keep it (but sanitized)
        if (ext.isEmpty() && original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }

        String newFileName = UUID.randomUUID().toString() + ext;

        String uploadDir = getServletContext().getRealPath("/images/products");
        Path dirPath = Path.of(uploadDir == null ? "images/products" : uploadDir);
        if (!Files.exists(dirPath)) Files.createDirectories(dirPath);

        Path target = dirPath.resolve(newFileName).normalize();
        if (!target.startsWith(dirPath.normalize())) {
            getServletContext().log("Upload path traversal attempt: " + target);
            return null;
        }

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return "images/products/" + newFileName;
    }
}
