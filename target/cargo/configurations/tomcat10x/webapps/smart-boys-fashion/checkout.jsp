<%@ include file="/common/header.jsp" %>

<div class="container my-4" style="max-width:640px">
  <h3 class="mb-4"><i class="fa-solid fa-truck-fast"></i> Checkout</h3>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="bg-white rounded-4 shadow-sm p-4">
    <form action="${pageContext.request.contextPath}/checkout" method="post">
      <div class="mb-3">
        <label class="form-label">Shipping Address</label>
        <textarea name="address" class="form-control" rows="3" required></textarea>
      </div>
      <div class="mb-3">
        <label class="form-label">Payment Method</label>
        <select name="paymentMethod" class="form-select">
          <option value="COD">Cash on Delivery</option>
          <option value="CARD">Card Payment</option>
          <option value="BANK_TRANSFER">Bank Transfer</option>
        </select>
      </div>
      <div class="alert alert-light border small">
        A flat shipping fee of <strong>Rs. 350.00</strong> will be added at order placement.
      </div>
      <button type="submit" class="btn btn-gold w-100">Place Order</button>
    </form>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
