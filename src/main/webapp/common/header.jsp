<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Boys' Fashion Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-shirt"></i> Smart Boys' Fashion</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMain">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Shop</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/sizeAssistant">Smart Size Assistant</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orderTracking">Track Order</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/wishlist">Wishlist</a></li>
      </ul>
      <ul class="navbar-nav align-items-lg-center">
        <li class="nav-item me-2">
          <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/cart"><i class="fa-solid fa-cart-shopping"></i> Cart</a>
        </li>
        <c:choose>
          <c:when test="${not empty sessionScope.customerId}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                <i class="fa-solid fa-circle-user"></i> ${sessionScope.customerName}
              </a>
              <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orderTracking">My Orders</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist">My Wishlist</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="btn btn-gold btn-sm" href="${pageContext.request.contextPath}/login">Login / Register</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
