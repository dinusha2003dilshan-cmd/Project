<%@ include file="/admin/header.jsp" %>

<h3 class="mb-4"><i class="fa-solid fa-triangle-exclamation text-danger"></i> Automated Inventory Alerts</h3>

<div class="card stat-card p-3">
  <table class="table align-middle">
    <thead><tr><th>Product</th><th>Category</th><th>Stock</th><th>Threshold</th><th></th></tr></thead>
    <tbody>
      <c:forEach var="p" items="${lowStockProducts}">
        <tr class="low-stock-row">
          <td>${p.productName}</td>
          <td>${p.categoryName}</td>
          <td><span class="fw-bold text-danger">${p.stockQty}</span></td>
          <td>${p.lowStockLimit}</td>
          <td><a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" class="btn btn-sm btn-gold">Restock</a></td>
        </tr>
      </c:forEach>
      <c:if test="${empty lowStockProducts}">
        <tr><td colspan="5" class="text-center text-muted">No low-stock items. Everything looks healthy!</td></tr>
      </c:if>
    </tbody>
  </table>
</div>

<%@ include file="/admin/footer.jsp" %>
