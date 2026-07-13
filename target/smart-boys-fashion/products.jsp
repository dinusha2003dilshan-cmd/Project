<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <div class="row">
    <div class="col-md-3 mb-4">
      <div class="filter-panel">
        <h6 class="fw-bold mb-3"><i class="fa-solid fa-filter"></i> Filter Products</h6>
        <form action="${pageContext.request.contextPath}/products" method="get">
          <div class="mb-3">
            <label class="form-label small">Keyword</label>
            <input type="text" name="keyword" class="form-control form-control-sm" value="${keyword}">
          </div>
          <div class="mb-3">
            <label class="form-label small">Category</label>
            <select name="categoryId" class="form-select form-select-sm">
              <option value="">All Categories</option>
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryId}" ${cat.categoryId == selectedCategoryId ? 'selected' : ''}>${cat.categoryName}</option>
              </c:forEach>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label small">Child's Age</label>
            <input type="number" name="age" min="1" max="16" class="form-control form-control-sm" value="${selectedAge}">
          </div>
          <div class="mb-3">
            <label class="form-label small">Color</label>
            <input type="text" name="color" class="form-control form-control-sm" value="${selectedColor}" placeholder="e.g. Blue">
          </div>
          <div class="row g-2 mb-3">
            <div class="col">
              <label class="form-label small">Min Price</label>
              <input type="number" name="minPrice" class="form-control form-control-sm">
            </div>
            <div class="col">
              <label class="form-label small">Max Price</label>
              <input type="number" name="maxPrice" class="form-control form-control-sm">
            </div>
          </div>
          <button type="submit" class="btn btn-gold btn-sm w-100">Apply Filters</button>
          <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm w-100 mt-2">Clear</a>
        </form>
      </div>
    </div>

    <div class="col-md-9">
      <h4 class="mb-3">Shop All Products <span class="text-muted fs-6">(${products.size()} items)</span></h4>
      <div class="row g-4">
        <c:if test="${empty products}">
          <div class="col-12"><div class="alert alert-info">No products match your filters. Try adjusting them.</div></div>
        </c:if>
        <c:forEach var="p" items="${products}">
          <div class="col-6 col-lg-4">
            <div class="card product-card">
              <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                <img src="${pageContext.request.contextPath}/${p.imagePath}" alt="${p.productName}"
                     onerror="this.src='https://via.placeholder.com/300x210?text=No+Image'">
              </a>
              <div class="card-body">
                <div class="small text-muted">${p.categoryName} &bull; Size ${p.sizeLabel}</div>
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
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
