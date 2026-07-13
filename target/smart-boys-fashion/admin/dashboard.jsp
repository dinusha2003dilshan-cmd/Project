<%@ include file="/admin/header.jsp" %>

<h3 class="mb-4"><i class="fa-solid fa-gauge"></i> Sales Dashboard</h3>

<div class="row g-4 mb-4">
  <div class="col-md-4">
    <div class="card stat-card p-3">
      <div class="text-muted small">Total Revenue</div>
      <div class="fs-3 fw-bold" style="color:var(--navy)">Rs. <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
    </div>
  </div>
  <div class="col-md-4">
    <div class="card stat-card p-3">
      <div class="text-muted small">Total Orders</div>
      <div class="fs-3 fw-bold" style="color:var(--navy)">${orderCount}</div>
    </div>
  </div>
  <div class="col-md-4">
    <div class="card stat-card p-3 ${lowStockCount > 0 ? 'low-stock-row' : ''}">
      <div class="text-muted small">Low Stock Alerts</div>
      <div class="fs-3 fw-bold text-danger">${lowStockCount}</div>
    </div>
  </div>
</div>

<div class="row g-4 mb-4">
  <div class="col-md-7">
    <div class="card stat-card p-3">
      <div class="fw-semibold mb-2">Revenue - Last 14 Days</div>
      <canvas id="dailyChart" height="120"></canvas>
    </div>
  </div>
  <div class="col-md-5">
    <div class="card stat-card p-3">
      <div class="fw-semibold mb-2">Revenue by Category</div>
      <canvas id="categoryChart" height="120"></canvas>
    </div>
  </div>
</div>

<div class="card stat-card p-3">
  <div class="fw-semibold mb-2"><i class="fa-solid fa-triangle-exclamation text-danger"></i> Low Stock Products</div>
  <table class="table mb-0">
    <thead><tr><th>Product</th><th>Stock</th><th>Threshold</th></tr></thead>
    <tbody>
      <c:forEach var="p" items="${lowStockProducts}">
        <tr class="low-stock-row"><td>${p.productName}</td><td>${p.stockQty}</td><td>${p.lowStockLimit}</td></tr>
      </c:forEach>
      <c:if test="${empty lowStockProducts}"><tr><td colspan="3" class="text-muted text-center">All stock levels healthy.</td></tr></c:if>
    </tbody>
  </table>
</div>

<script>
const dailyData = ${dailyChartJson};
new Chart(document.getElementById('dailyChart'), {
  type: 'bar',
  data: {
    labels: dailyData.labels,
    datasets: [{ label: 'Revenue (Rs.)', data: dailyData.values, backgroundColor: '#f2a900' }]
  },
  options: { plugins: { legend: { display: false } } }
});

const catData = ${categoryChartJson};
new Chart(document.getElementById('categoryChart'), {
  type: 'pie',
  data: {
    labels: catData.labels,
    datasets: [{ data: catData.values, backgroundColor: ['#1b2a4a','#f2a900','#2e9e5b','#d9455f'] }]
  }
});
</script>

<%@ include file="/admin/footer.jsp" %>
