# Smart Boys' Fashion Shop & Management System

Full-stack Java web application (Servlet + JSP + MySQL) implementing the proposal:
customer storefront (Smart Size Assistant, filtering, cart, checkout, order tracking,
wishlist) plus an admin panel (product CRUD, inventory alerts, order management,
sales dashboard with charts, role-based login).

## Tech Stack
- Java 17, Jakarta Servlet/JSP (Servlet API 6.0)
- MySQL 8
- Bootstrap 5 (frontend), Chart.js (dashboard graphs)
- Maven (build), JSTL, MySQL Connector/J, jBCrypt (password hashing), org.json

## Prerequisites
1. **JDK 17+**
2. **Apache Tomcat 10.x** (needed for the `jakarta.*` Servlet API used here — Tomcat 9
   uses the older `javax.*` namespace and will NOT work without extra changes)
3. **MySQL 8.0+**
4. **Maven 3.8+**
5. An IDE such as Eclipse (with the "Eclipse IDE for Enterprise Java and Web
   Developers" package) or IntelliJ IDEA Ultimate — both can run this as a
   Maven-based Dynamic Web Project against a local Tomcat server.

## 1. Database Setup
```bash
mysql -u root -p < database/schema.sql
```
This creates the `smart_boys_fashion` database, all tables, and seed data:
- 4 categories, 8 sample products, a size chart, one sample customer, and two
  admin accounts.

**Default logins (created by the seed data):**
| Role     | Email                    | Password     |
|----------|--------------------------|---------------|
| Owner    | owner@smartboys.lk       | admin123      |
| Manager  | manager@smartboys.lk     | admin123      |
| Customer | parent@example.com       | customer123   |

## 2. Configure the Database Connection
Edit `src/main/java/com/smartboys/dao/DBConnection.java` and set your own
MySQL username/password if they differ from `root` / `root`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/smart_boys_fashion?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "root";
```

## 3. Build & Run
### Option A — Eclipse
1. `File > Import > Maven > Existing Maven Projects`, select this folder.
2. Right-click the project → `Properties > Project Facets` → ensure
   **Dynamic Web Module 6.0** and Tomcat 10 runtime are set.
3. Add a Tomcat 10 server (`Window > Preferences > Server > Runtime Environments`).
4. Right-click project → `Run As > Run on Server`.
5. Visit `http://localhost:8080/smart-boys-fashion/`.

### Option B — Command line (Maven + standalone Tomcat)
```bash
mvn clean package
cp target/smart-boys-fashion.war $TOMCAT_HOME/webapps/
$TOMCAT_HOME/bin/startup.sh   # or startup.bat on Windows
```
Then open `http://localhost:8080/smart-boys-fashion/`.

## Project Structure
```
smart-boys-fashion/
├── pom.xml
├── database/
│   └── schema.sql                 # full DB schema + seed data
├── src/main/java/com/smartboys/
│   ├── model/                     # POJOs: Product, Order, Customer, Admin ...
│   ├── dao/                       # JDBC data access layer
│   ├── servlet/                   # controllers (customer + /admin/*)
│   └── util/                      # password hashing, validation
└── src/main/webapp/
    ├── *.jsp                      # customer-facing pages
    ├── admin/                     # admin panel pages
    ├── common/                    # shared header/footer fragments
    ├── css/style.css
    └── WEB-INF/web.xml
```

## Feature Map (proposal → implementation)
| Proposal Feature                  | Where it lives |
|-----------------------------------|----------------|
| Smart Size Assistant              | `SizeAssistantServlet`, `SizeChartDAO.recommendSize()`, `sizeAssistant.jsp` |
| Advanced Filtering Engine         | `ProductListServlet`, `ProductDAO.searchProducts()`, `products.jsp` |
| Interactive Shopping Cart         | `CartServlet` (session-based cart), `cart.jsp` |
| Live Order Tracking               | `OrderTrackingServlet`, `orderTracking.jsp` |
| Wishlist Registry                 | `WishlistServlet`, `WishlistDAO`, `wishlist.jsp` |
| Dynamic Product CRUD + images     | `AdminProductServlet` (multipart upload), `admin/productForm.jsp` |
| Automated Inventory Alerts        | `AdminInventoryServlet`, `ProductDAO.getLowStockProducts()` |
| Sales Dashboard Analytics         | `AdminDashboardServlet` (JSON for Chart.js), `admin/dashboard.jsp` |
| Role-Based Access Control (RBAC)  | `AdminAuthFilter`, `admins.role` column (OWNER/MANAGER/WAREHOUSE) |

## Notes & Possible Extensions
- The cart is session-based (not persisted across devices) — could be upgraded to
  a `cart_items` DB table tied to `customer_id` for a logged-in, multi-device cart.
- Checkout stock decrement is done inside a single JDBC transaction
  (`OrderDAO.placeOrder`) so two customers can never oversell the last unit.
- Product images upload to `webapp/images/products/`; make sure this folder is
  writable by the Tomcat process.
- For production, move DB credentials out of source code into an environment
  variable or a `context.xml` JNDI DataSource.
- The `role` field on `admins` is stored and available in the session
  (`adminRole`) — you can extend `AdminAuthFilter` or individual servlets to
  restrict specific actions (e.g. only OWNER can view revenue) per the
  `RBAC` feature.
