<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body style="background:var(--navy)">
<div class="container d-flex align-items-center justify-content-center" style="min-height:100vh">
  <div class="bg-white rounded-4 shadow p-4" style="max-width:400px; width:100%">
    <h4 class="text-center mb-3"><i class="fa-solid fa-user-shield"></i> Admin Login</h4>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/admin/login" method="post">
      <div class="mb-3">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-gold w-100">Login</button>
    </form>
    <p class="small text-muted text-center mt-3 mb-0">Default: owner@smartboys.lk / admin123</p>
  </div>
</div>
</body>
</html>
