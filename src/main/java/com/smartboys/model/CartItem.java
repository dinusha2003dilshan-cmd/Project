package com.smartboys.model;

import java.math.BigDecimal;
import java.io.Serializable;

public class CartItem implements Serializable {
    private int productId;
    private String productName;
    private String imagePath;
    private BigDecimal unitPrice;
    private int quantity;

    public CartItem(int productId, String productName, String imagePath, BigDecimal unitPrice, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.imagePath = imagePath;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
    }

    public BigDecimal getLineTotal() { return unitPrice.multiply(BigDecimal.valueOf(quantity)); }

    public int getProductId() { return productId; }
    public String getProductName() { return productName; }
    public String getImagePath() { return imagePath; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
