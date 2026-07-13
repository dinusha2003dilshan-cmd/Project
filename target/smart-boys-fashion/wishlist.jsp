<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <h3 class="mb-4"><i class="fa-solid fa-heart"></i> My Wishlist</h3>
  <div class="row g-4">
    <c:if test="${empty wishlist}">
      <div class="col-12"><div class="alert alert-info">Your wishlist is empty.</div></div>
    </c:if>
    <c:forEach var="p" items="${wishlist}">
      <div class="col-6 col-md-3">
        <div class="card product-card">
          <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
            <img src="${pageContext.request.contextPath}/${p.imagePath}" onerror="this.src='https://via.placeholder.com/300x210?text=No+Image'">
          </a>
          <div class="card-body">
            <h6>${p.productName}</h6>
            <span class="price-tag">Rs. <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></span>
            <a href="${pageContext.request.contextPath}/wishlist?action=remove&productId=${p.productId}" class="btn btn-sm btn-outline-danger float-end">
              <i class="fa-solid fa-trash"></i>
            </a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
