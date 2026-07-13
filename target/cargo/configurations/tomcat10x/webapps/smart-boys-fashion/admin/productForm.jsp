<%@ include file="/admin/header.jsp" %>

<h3 class="mb-4"><i class="fa-solid fa-shirt"></i> ${not empty product ? 'Edit' : 'Add'} Product</h3>

<div class="card stat-card p-4" style="max-width:700px">
  <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
    <c:if test="${not empty product}">
      <input type="hidden" name="productId" value="${product.productId}">
      <input type="hidden" name="existingImagePath" value="${product.imagePath}">
    </c:if>

    <div class="mb-3">
      <label class="form-label">Product Name</label>
      <input type="text" name="productName" class="form-control" value="${product.productName}" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Description</label>
      <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
    </div>
    <div class="row g-3 mb-3">
      <div class="col-md-6">
        <label class="form-label">Category</label>
        <select name="categoryId" class="form-select" required>
          <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}" ${cat.categoryId == product.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
          </c:forEach>
        </select>
      </div>
      <div class="col-md-6">
        <label class="form-label">Price (Rs.)</label>
        <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
      </div>
    </div>
    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <label class="form-label">Color</label>
        <input type="text" name="color" class="form-control" value="${product.color}">
      </div>
      <div class="col-md-4">
        <label class="form-label">Size Label</label>
        <input type="text" name="sizeLabel" class="form-control" value="${product.sizeLabel}" placeholder="e.g. 24, S, M" required>
      </div>
      <div class="col-md-4">
        <label class="form-label">Stock Quantity</label>
        <input type="number" name="stockQty" class="form-control" value="${product.stockQty}" required>
      </div>
    </div>
    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <label class="form-label">Min Age (fit)</label>
        <input type="number" name="minAge" class="form-control" value="${product.minAge}" required>
      </div>
      <div class="col-md-4">
        <label class="form-label">Max Age (fit)</label>
        <input type="number" name="maxAge" class="form-control" value="${product.maxAge}" required>
      </div>
      <div class="col-md-4">
        <label class="form-label">Low Stock Threshold</label>
        <input type="number" name="lowStockLimit" class="form-control" value="${not empty product ? product.lowStockLimit : 5}" required>
      </div>
    </div>
    <div class="mb-3">
      <label class="form-label">Product Image</label>
      <input type="file" name="imageFile" class="form-control" accept="image/*">
      <c:if test="${not empty product.imagePath}">
        <img src="${pageContext.request.contextPath}/${product.imagePath}" width="80" class="mt-2 rounded">
      </c:if>
    </div>
    <div class="form-check mb-3">
      <input type="checkbox" name="active" class="form-check-input" id="activeCheck" ${empty product || product.active ? 'checked' : ''}>
      <label class="form-check-label" for="activeCheck">Visible on storefront</label>
    </div>
    <button type="submit" class="btn btn-gold">Save Product</button>
    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">Cancel</a>
  </form>
</div>

<%@ include file="/admin/footer.jsp" %>
