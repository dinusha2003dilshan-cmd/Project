<%@ include file="/admin/header.jsp" %>

<h3 class="mb-4"><i class="fa-solid fa-box"></i> Order #${order.orderId}</h3>

<div class="row g-4">
  <div class="col-md-7">
    <div class="card stat-card p-3">
      <table class="table">
        <thead><tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Total</th></tr></thead>
        <tbody>
          <c:forEach var="it" items="${items}">
            <tr><td>${it.productName}</td><td>${it.quantity}</td>
              <td>Rs. <fmt:formatNumber value="${it.unitPrice}" pattern="#,##0.00"/></td>
              <td>Rs. <fmt:formatNumber value="${it.lineTotal}" pattern="#,##0.00"/></td></tr>
          </c:forEach>
        </tbody>
      </table>
      <div class="text-end">
        <p class="mb-1">Subtotal: Rs. <fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></p>
        <p class="mb-1">Shipping: Rs. <fmt:formatNumber value="${order.shippingFee}" pattern="#,##0.00"/></p>
        <h5>Total: Rs. <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></h5>
      </div>
    </div>
  </div>
  <div class="col-md-5">
    <div class="card stat-card p-3 mb-3">
      <div class="fw-semibold mb-2">Customer &amp; Shipping</div>
      <p class="mb-1"><strong>${order.customerName}</strong></p>
      <p class="mb-0">${order.shippingAddress}</p>
      <p class="text-muted small mt-2">Payment: ${order.paymentMethod}</p>
    </div>
    <div class="card stat-card p-3">
      <div class="fw-semibold mb-2">Update Status</div>
      <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex gap-2">
        <input type="hidden" name="orderId" value="${order.orderId}">
        <select name="status" class="form-select">
          <option value="PROCESSING" ${order.status == 'PROCESSING' ? 'selected' : ''}>Processing</option>
          <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
          <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
          <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
        </select>
        <button class="btn btn-gold" type="submit">Update</button>
      </form>
    </div>
  </div>
</div>

<%@ include file="/admin/footer.jsp" %>
