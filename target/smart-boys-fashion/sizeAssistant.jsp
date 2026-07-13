<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="bg-white rounded-4 shadow-sm p-4 mb-4">
        <h4 class="mb-1"><i class="fa-solid fa-ruler-combined"></i> Smart Size Assistant</h4>
        <p class="text-muted">Enter your child's details to get an instant size recommendation.</p>

        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <form action="${pageContext.request.contextPath}/sizeAssistant" method="post">
          <div class="mb-3">
            <label class="form-label">Age (years)</label>
            <input type="number" name="age" class="form-control" min="1" max="16" value="${age}" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Height (cm)</label>
            <input type="number" name="height" class="form-control" min="50" max="200" value="${height}" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Weight (kg)</label>
            <input type="number" name="weight" class="form-control" min="5" max="90" value="${weight}" required>
          </div>
          <button type="submit" class="btn btn-gold w-100">Get Size Recommendation</button>
        </form>
      </div>

      <c:if test="${not empty recommendedSize}">
        <div class="text-center bg-white rounded-4 shadow-sm p-4">
          <div class="text-muted">Recommended Size</div>
          <div class="display-4 fw-bold" style="color:var(--navy)">${recommendedSize}</div>
        </div>
      </c:if>
    </div>
  </div>

  <c:if test="${not empty matchingProducts}">
    <h5 class="mt-4 mb-3">Products in Size ${recommendedSize}</h5>
    <div class="row g-4">
      <c:forEach var="p" items="${matchingProducts}">
        <div class="col-6 col-md-3">
          <div class="card product-card">
            <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
              <img src="${pageContext.request.contextPath}/${p.imagePath}" onerror="this.src='https://via.placeholder.com/300x210?text=No+Image'">
            </a>
            <div class="card-body">
              <h6 class="mb-1">${p.productName}</h6>
              <span class="price-tag">Rs. <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></span>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>
</div>

<%@ include file="/common/footer.jsp" %>
