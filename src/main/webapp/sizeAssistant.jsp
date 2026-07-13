<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card border-0 rounded-4 shadow-lg mb-4 overflow-hidden">
        <div class="card-header bg-primary text-white p-4 border-0" style="background: linear-gradient(135deg, var(--navy, #0f172a), var(--bs-primary, #3b82f6)) !important;">
          <h4 class="mb-1 text-white fw-bold"><i class="fa-solid fa-ruler-combined me-2"></i> Smart Size Assistant</h4>
          <p class="mb-0 text-white-50">Enter the details to get an instant, accurate size recommendation.</p>
        </div>
        <div class="card-body p-4 p-md-5 bg-white">
          <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center rounded-3 shadow-sm border-0" role="alert">
              <i class="fa-solid fa-circle-exclamation me-3 fs-5"></i>
              <div>${error}</div>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/sizeAssistant" method="post">
            <div class="row g-4 mb-4">
              <div class="col-12 col-md-4">
                <div class="form-floating">
                  <input type="number" name="age" class="form-control rounded-3" id="ageInput" min="1" max="100" value="${age}" placeholder="Age" required>
                  <label for="ageInput" class="text-muted"><i class="fa-regular fa-calendar me-1"></i> Age (years)</label>
                </div>
              </div>
              <div class="col-12 col-md-4">
                <div class="form-floating">
                  <input type="number" name="height" class="form-control rounded-3" id="heightInput" min="50" max="250" value="${height}" placeholder="Height" required>
                  <label for="heightInput" class="text-muted"><i class="fa-solid fa-arrows-up-down me-1"></i> Height (cm)</label>
                </div>
              </div>
              <div class="col-12 col-md-4">
                <div class="form-floating">
                  <input type="number" name="weight" class="form-control rounded-3" id="weightInput" min="5" max="200" value="${weight}" placeholder="Weight" required>
                  <label for="weightInput" class="text-muted"><i class="fa-solid fa-weight-scale me-1"></i> Weight (kg)</label>
                </div>
              </div>
            </div>
            
            <button type="submit" class="btn btn-gold w-100 py-3 fw-bold rounded-3 shadow-sm" style="font-size: 1.1rem; letter-spacing: 0.5px;">
              <i class="fa-solid fa-wand-magic-sparkles me-2"></i> Get Size Recommendation
            </button>
          </form>
        </div>
      </div>

      <c:if test="${not empty recommendedSize}">
        <div class="text-center rounded-4 shadow-lg p-5 mb-5 position-relative overflow-hidden" style="background: linear-gradient(135deg, #ffffff, #f8f9fa); border: 1px solid rgba(0,0,0,0.08);">
          <div class="position-absolute top-0 start-0 w-100 h-100" style="background: radial-gradient(circle at top right, rgba(15, 23, 42, 0.03), transparent 60%); pointer-events: none;"></div>
          <p class="text-uppercase text-muted fw-bold mb-2" style="letter-spacing: 2px; font-size: 0.85rem;">Your Recommended Size</p>
          <div class="display-1 fw-bolder mb-0" style="color: var(--navy, #0f172a); text-shadow: 2px 2px 4px rgba(0,0,0,0.05);">${recommendedSize}</div>
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
