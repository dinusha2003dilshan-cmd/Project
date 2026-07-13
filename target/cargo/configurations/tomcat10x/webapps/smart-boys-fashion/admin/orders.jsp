<%@ include file="/admin/header.jsp" %>

<h3 class="mb-4"><i class="fa-solid fa-box"></i> Order Management</h3>

<div class="card stat-card p-3">
  <table class="table align-middle">
    <thead><tr><th>Order #</th><th>Customer</th><th>Date</th><th>Status</th><th>Total</th><th></th></tr></thead>
    <tbody>
      <c:forEach var="o" items="${orders}">
        <tr>
          <td>#${o.orderId}</td>
          <td>${o.customerName}</td>
          <td><fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></td>
          <td>
            <span class="badge
              ${o.status == 'PROCESSING' ? 'bg-warning text-dark' :
               (o.status == 'SHIPPED' ? 'bg-info text-dark' :
               (o.status == 'DELIVERED' ? 'bg-success' : 'bg-secondary'))}">
              ${o.status}
            </span>
          </td>
          <td>Rs. <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></td>
          <td><a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${o.orderId}" class="btn btn-sm btn-outline-secondary">View</a></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<%@ include file="/admin/footer.jsp" %>
