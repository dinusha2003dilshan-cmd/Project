<%@ include file="/admin/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
  <h3><i class="fa-solid fa-shirt"></i> Product Management</h3>
  <a href="${pageContext.request.contextPath}/admin/products?action=new" class="btn btn-gold"><i class="fa-solid fa-plus"></i> Add Product</a>
</div>

<div class="card stat-card p-3">
  <table class="table align-middle">
    <thead><tr><th>Image</th><th>Name</th><th>Category</th><th>Price</th><th>Size</th><th>Stock</th><th>Status</th><th></th></tr></thead>
    <tbody>
      <c:forEach var="p" items="${products}">
        <tr class="${p.lowStock ? 'low-stock-row' : ''}">
          <td><img src="${pageContext.request.contextPath}/${p.imagePath}" width="50" height="50" style="object-fit:cover" class="rounded" onerror="this.src='https://via.placeholder.com/50'"></td>
          <td>${p.productName}</td>
          <td>${p.categoryName}</td>
          <td>Rs. <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
          <td>${p.sizeLabel}</td>
          <td>${p.stockQty} ${p.lowStock ? '<span class="badge badge-lowstock">LOW</span>' : ''}</td>
          <td>${p.active ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-secondary">Hidden</span>'}</td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" class="btn btn-sm btn-outline-secondary"><i class="fa-solid fa-pen"></i></a>
            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this product?')"><i class="fa-solid fa-trash"></i></a>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<%@ include file="/admin/footer.jsp" %>
