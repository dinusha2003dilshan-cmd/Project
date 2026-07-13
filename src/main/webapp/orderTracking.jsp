<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <h3 class="mb-4"><i class="fa-solid fa-truck"></i> Order Tracking</h3>

  <c:if test="${not empty order}">
    <div class="bg-white rounded-4 shadow-sm p-4 mb-4">
      <div class="d-flex justify-content-between flex-wrap">
        <div>
          <h5>Order #${order.orderId}</h5>
          <div class="text-muted small">Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></div>
        </div>
        <div class="text-end">
          <h5>Rs. <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></h5>
        </div>
      </div>

      <div class="step-tracker">
        <c:set var="statuses" value="PROCESSING,SHIPPED,DELIVERED"/>
        <div class="step ${order.status == 'PROCESSING' ? 'active' : (order.status == 'SHIPPED' || order.status == 'DELIVERED' ? 'done' : '')}">
          <div class="circle"><i class="fa-solid fa-box"></i></div><div class="small">Processing</div>
        </div>
        <div class="step ${order.status == 'SHIPPED' ? 'active' : (order.status == 'DELIVERED' ? 'done' : '')}">
          <div class="circle"><i class="fa-solid fa-truck"></i></div><div class="small">Shipped</div>
        </div>
        <div class="step ${order.status == 'DELIVERED' ? 'done' : ''}">
          <div class="circle"><i class="fa-solid fa-house"></i></div><div class="small">Delivered</div>
        </div>
      </div>

      <table class="table mt-3">
        <thead><tr><th>Product</th><th>Qty</th><th>Line Total</th></tr></thead>
        <tbody>
          <c:forEach var="it" items="${items}">
            <tr><td>${it.productName}</td><td>${it.quantity}</td><td>Rs. <fmt:formatNumber value="${it.lineTotal}" pattern="#,##0.00"/></td></tr>
          </c:forEach>
        </tbody>
      </table>
      <p class="small text-muted mb-0"><strong>Shipping to:</strong> ${order.shippingAddress}</p>
    </div>
  </c:if>

  <h5 class="mb-3">My Order History</h5>
  <div class="bg-white rounded-4 shadow-sm p-3">
    <table class="table align-middle mb-0">
      <thead><tr><th>Order #</th><th>Date</th><th>Status</th><th>Total</th><th></th></tr></thead>
      <tbody>
        <c:forEach var="o" items="${myOrders}">
          <tr>
            <td>#${o.orderId}</td>
            <td><fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy"/></td>
            <td><span class="badge bg-secondary">${o.status}</span></td>
            <td>Rs. <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></td>
            <td><a href="${pageContext.request.contextPath}/orderTracking?orderId=${o.orderId}" class="btn btn-sm btn-outline-secondary">View</a></td>
          </tr>
        </c:forEach>
        <c:if test="${empty myOrders}">
          <tr><td colspan="5" class="text-center text-muted">No orders yet.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
