<%@ include file="/common/header.jsp" %>

<div class="container my-5" style="max-width:480px">
  <div class="bg-white rounded-4 shadow-sm p-4">
    <h4 class="mb-3 text-center">Create an Account</h4>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/register" method="post">
      <div class="mb-3">
        <label class="form-label">Full Name</label>
        <input type="text" name="fullName" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-control" minlength="6" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Phone</label>
        <input type="text" name="phone" class="form-control">
      </div>
      <div class="mb-3">
        <label class="form-label">Address</label>
        <textarea name="address" class="form-control" rows="2"></textarea>
      </div>
      <button type="submit" class="btn btn-gold w-100">Register</button>
    </form>
    <p class="text-center mt-3 small">Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
