<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <h3 class="mb-4"><i class="fa-solid fa-cart-shopping"></i> Your Shopping Cart</h3>

  <c:if test="${empty cartItems}">
    <div class="alert alert-info">Your cart is empty. <a href="${pageContext.request.contextPath}/products">Browse products &rarr;</a></div>
  </c:if>

  <c:if test="${not empty cartItems}">
    <div class="table-responsive bg-white rounded-4 shadow-sm p-3">
      <table class="table align-middle">
        <thead>
          <tr><th>Product</th><th>Unit Price</th><th style="width:140px">Quantity</th><th>Subtotal</th><th></th></tr>
        </thead>
        <tbody>
          <c:forEach var="item" items="${cartItems}">
            <tr>
              <td>
                <div class="d-flex align-items-center gap-2">
                  <img src="${pageContext.request.contextPath}/${item.imagePath}" width="60" height="60" style="object-fit:cover" class="rounded"
                       onerror="this.src='https://via.placeholder.com/60'">
                  <span>${item.productName}</span>
                </div>
              </td>
              <td>Rs. <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
              <td>
                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex gap-1">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="productId" value="${item.productId}">
                  <input type="number" name="qty" value="${item.quantity}" min="0" class="form-control form-control-sm">
                  <button class="btn btn-sm btn-outline-secondary" type="submit"><i class="fa-solid fa-rotate"></i></button>
                </form>
              </td>
              <td>Rs. <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></td>
              <td>
                <a href="${pageContext.request.contextPath}/cart?action=remove&productId=${item.productId}" class="btn btn-sm btn-outline-danger">
                  <i class="fa-solid fa-trash"></i>
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      <div class="text-end">
        <h5>Subtotal: Rs. <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></h5>
        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-gold btn-lg mt-2">Proceed to Checkout <i class="fa-solid fa-arrow-right"></i></a>
      </div>
    </div>
  </c:if>
</div>

<%@ include file="/common/footer.jsp" %>
