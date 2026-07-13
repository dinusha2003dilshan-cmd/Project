<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Smart Boys' Fashion Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<div class="d-flex">
  <div class="admin-sidebar p-0" style="width:230px">
    <div class="p-3 border-bottom border-secondary">
      <strong><i class="fa-solid fa-shirt"></i> Smart Boys Admin</strong>
      <div class="small text-white-50 mt-1">${sessionScope.adminName} (${sessionScope.adminRole})</div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products"><i class="fa-solid fa-shirt"></i> Products</a>
    <a href="${pageContext.request.contextPath}/admin/inventory"><i class="fa-solid fa-triangle-exclamation"></i> Inventory Alerts</a>
    <a href="${pageContext.request.contextPath}/admin/orders"><i class="fa-solid fa-box"></i> Orders</a>
    <a href="${pageContext.request.contextPath}/" target="_blank"><i class="fa-solid fa-store"></i> View Storefront</a>
    <a href="${pageContext.request.contextPath}/admin/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
  </div>
  <div class="flex-grow-1 p-4" style="background:var(--light-bg); min-height:100vh">
