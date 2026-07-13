<%@ include file="/common/header.jsp" %>

<div class="container my-4">
  <div class="row g-4">
    <div class="col-md-5">
      <img src="${pageContext.request.contextPath}/${product.imagePath}" class="img-fluid rounded-4 shadow-sm"
           onerror="this.src='https://via.placeholder.com/500x400?text=No+Image'">
    </div>
    <div class="col-md-7">
      <div class="small text-muted mb-1">${product.categoryName}</div>
      <h2>${product.productName}</h2>
      <h4 class="price-tag my-3">Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></h4>
      <p>${product.description}</p>
      <ul class="list-unstyled">
        <li><strong>Size:</strong> ${product.sizeLabel}</li>
        <li><strong>Color:</strong> ${product.color}</li>
        <li><strong>Best Fit Age:</strong> ${product.minAge} - ${product.maxAge} years</li>
        <li><strong>Availability:</strong>
          <span class="badge ${product.lowStock ? 'badge-lowstock' : 'badge-instock'}">
            <c:choose>
              <c:when test="${product.stockQty > 0}">${product.stockQty} in stock</c:when>
              <c:otherwise>Out of stock</c:otherwise>
            </c:choose>
          </span>
        </li>
      </ul>

      <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center gap-2 mt-3">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="productId" value="${product.productId}">
        <input type="number" name="qty" value="1" min="1" max="${product.stockQty}" class="form-control" style="width:90px" ${product.stockQty == 0 ? 'disabled' : ''}>
        <button type="submit" class="btn btn-gold" ${product.stockQty == 0 ? 'disabled' : ''}><i class="fa-solid fa-cart-plus"></i> Add to Cart</button>
      </form>

      <a href="${pageContext.request.contextPath}/wishlist?action=add&productId=${product.productId}" class="btn btn-outline-secondary mt-2">
        <i class="fa-regular fa-heart"></i> Add to Wishlist
      </a>

      <div class="alert alert-light border mt-4">
        <i class="fa-solid fa-ruler"></i> Not sure about the size?
        <a href="${pageContext.request.contextPath}/sizeAssistant">Try our Smart Size Assistant &rarr;</a>
      </div>
    </div>
  </div>
</div>

<%@ include file="/common/footer.jsp" %>
