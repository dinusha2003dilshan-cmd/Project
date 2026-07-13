<%@ include file="/common/header.jsp" %>

<div class="container my-5" style="max-width:420px">
  <div class="bg-white rounded-4 shadow-sm p-4">
    <h4 class="mb-3 text-center">Login</h4>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <form action="${pageContext.request.contextPath}/login" method="post">
      <input type="hidden" name="redirect" value="${param.redirect}">
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
    <p class="text-center mt-3 small">Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
