<%@ include file="/common/header.jsp" %>

<div class="hero">
  <div class="container text-center">
    <h1 class="display-5">Smart, Stylish, Stress-Free Shopping for Boys</h1>
    <p class="lead">Find the perfect fit every time with our AI-style Smart Size Assistant.</p>
    <a href="${pageContext.request.contextPath}/sizeAssistant" class="btn btn-gold btn-lg me-2">Try Size Assistant</a>
    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-light btn-lg">Shop Now</a>
  </div>
</div>

<div class="container mb-4">
  <h4 class="mb-3">Shop by Category</h4>
  <div class="row g-3">
    <c:forEach var="cat" items="${categories}">
      <div class="col-6 col-md-3">
        <a href="${pageContext.request.contextPath}/products?categoryId=${cat.categoryId}" class="text-decoration-none">
          <div class="p-4 text-center bg-white rounded-4 shadow-sm h-100">
            <i class="fa-solid fa-shirt fa-2x mb-2" style="color:var(--navy)"></i>
            <div class="fw-semibold text-dark">${cat.categoryName}</div>
          </div>
        </a>
      </div>
    </c:forEach>
  </div>
</div>

<div class="container mb-5">
  <h4 class="mb-3">Featured Products</h4>
  <div class="row g-4">
    <c:forEach var="p" items="${featuredProducts}">
      <div class="col-6 col-md-3">
        <div class="card product-card">
          <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
            <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.productName}"
                 onerror="this.src='https://via.placeholder.com/300x210?text=No+Image'">
          </a>
          <div class="card-body">
            <div class="small text-muted">${p.categoryName}</div>
            <h6 class="mb-1"><a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="text-decoration-none text-dark">${p.productName}</a></h6>
            <div class="d-flex justify-content-between align-items-center">
              <span class="price-tag">Rs. <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></span>
              <span class="badge ${p.lowStock ? 'badge-lowstock' : 'badge-instock'}">${p.lowStock ? 'Low Stock' : 'In Stock'}</span>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
