<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html><head><title>Something went wrong</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body class="d-flex align-items-center justify-content-center" style="height:100vh">
  <div class="text-center">
    <h1 class="display-1 fw-bold">Oops!</h1>
    <p class="lead">Something went wrong on our end. Please try again shortly.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-dark">Go Home</a>
  </div>
</body></html>
