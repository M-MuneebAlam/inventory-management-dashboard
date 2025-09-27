# Inventory & Supply Chain Management Dashboard

A comprehensive web-based inventory management system built with **Streamlit** and **MySQL**, designed to streamline inventory operations, supplier management, and sales analytics for small to medium-sized businesses.

## 🚀 Live Demo

[View Dashboard](link-to-deployed-app) | [Video Walkthrough](link-to-demo-video)

## 📋 Table of Contents

- [Features](#-features)
- [Database Architecture](#-database-architecture)
- [SQL Concepts & Implementation](#-sql-concepts--implementation)
- [Technology Stack](#-technology-stack)
- [Installation & Setup](#-installation--setup)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Learning Outcomes](#-learning-outcomes)

## ✨ Features

### Dashboard Analytics

- **Real-time KPI Metrics**: Total suppliers, products, categories, and financial summaries
- **Time-based Analytics**: Sales and restock values for the last 3 months
- **Low-stock Alerts**: Products below reorder levels with no pending orders

### Operational Management

- **Product Management**: Add new products with category and supplier assignment
- **Inventory Tracking**: Complete product history with stock movements
- **Automated Reordering**: Place and track reorder requests
- **Supplier Management**: Comprehensive supplier contact database

### Data Visualization

- **Interactive Tables**: Sortable and filterable data displays
- **Metric Cards**: Key performance indicators at a glance
- **Historical Views**: Product-specific inventory movement tracking

## 🗄️ Database Architecture

### Entity Relationship Design

```
suppliers (1) ──→ (M) products (1) ──→ (M) stock_entries
    │                    │                      │
    │                    └──→ (1:M) reorders    │
    │                                           │
    └──────────── (1:M) shipments ──────────────┘
```

### Core Tables

- **`suppliers`**: Supplier contact information and business details
- **`products`**: Product catalog with pricing, stock levels, and reorder thresholds
- **`stock_entries`**: Transaction log for all inventory movements (sales/restocks)
- **`reorders`**: Purchase order tracking with status management
- **`shipments`**: Logistics and delivery tracking

## 💾 SQL Concepts & Implementation

### 1. Complex JOIN Operations

**Multi-table Joins for Sales Analytics**

```sql
SELECT ROUND(SUM(ABS(se.change_quantity) * p.price), 2) AS total_sales
FROM stock_entries se
JOIN products p ON se.product_id = p.product_id
WHERE se.change_type = 'Sale'
AND se.entry_date >= (
    SELECT DATE_SUB(MAX(entry_date), INTERVAL 3 MONTH)
    FROM stock_entries
);
```

**Key Concepts**: INNER JOIN, aggregate functions, subqueries

### 2. Subqueries & Date Functions

**Dynamic Date Filtering**

```sql
-- Calculates 3-month window from the latest entry
WHERE se.entry_date >= (
    SELECT DATE_SUB(MAX(entry_date), INTERVAL 3 MONTH)
    FROM stock_entries
)
```

**Key Concepts**: Correlated subqueries, DATE_SUB(), MAX(), INTERVAL

### 3. Advanced WHERE Clauses

**Conditional Logic with NOT IN**

```sql
SELECT COUNT(*)
FROM products p
WHERE p.stock_quantity < p.reorder_level
AND p.product_id NOT IN (
    SELECT DISTINCT product_id
    FROM reorders
    WHERE status = 'Pending'
);
```

**Key Concepts**: NOT IN, DISTINCT, conditional filtering

### 4. Stored Procedures

**Product Creation with Auto-ID Generation**

```sql
CALL AddNewProductManualID(name, category, price, stock, level, supplier_id);
```

**Reorder Status Management**

```sql
CALL MarkReorderAsReceived(reorder_id);
```

**Key Concepts**: Stored procedures, parameter passing, transaction management

### 5. Aggregate Functions & Mathematical Operations

```sql
-- Financial calculations with absolute values
SELECT ROUND(SUM(ABS(se.change_quantity) * p.price), 2)
-- Category analysis
SELECT COUNT(DISTINCT category) FROM products;
```

**Key Concepts**: SUM(), COUNT(), DISTINCT, ABS(), ROUND(), mathematical expressions

### 6. Data Integrity & Constraints

- **Foreign Key Relationships**: Maintains referential integrity across tables
- **Check Constraints**: Validates stock quantities and pricing
- **Enum Values**: Status fields with predefined options ('Pending', 'Received', etc.)

## 🛠️ Technology Stack

| Component                 | Technology             | Purpose                            |
| ------------------------- | ---------------------- | ---------------------------------- |
| **Frontend**              | Streamlit              | Interactive web dashboard          |
| **Backend**               | Python                 | Business logic and data processing |
| **Database**              | MySQL                  | Data storage and retrieval         |
| **Data Processing**       | Pandas                 | Data manipulation and analysis     |
| **Database Connectivity** | mysql-connector-python | Python-MySQL integration           |

## 🚀 Installation & Setup

### Prerequisites

- Python 3.8+
- MySQL Server 8.0+
- Git

### Database Setup

1. **Create Database**

```sql
CREATE DATABASE inventory_management;
USE inventory_management;
```

2. **Import Schema & Sample Data**

```bash
mysql -u root -p inventory_management < database_schema.sql
```

### Application Setup

1. **Clone Repository**

```bash
git clone https://github.com/yourusername/inventory-management-dashboard.git
cd inventory-management-dashboard
```

2. **Create Virtual Environment**

```bash
python -m venv myenv
# Windows
myenv\Scripts\activate
# Linux/Mac
source myenv/bin/activate
```

3. **Install Dependencies**

```bash
pip install -r requirements.txt
```

4. **Configure Database Connection**
   Update database credentials in `db_functions.py`:

```python
def connect_to_db():
    return mysql.connector.connect(
        host="localhost",
        user="your_username",
        password="your_password",
        database="inventory_management"
    )
```

5. **Launch Application**

```bash
streamlit run app.py
```

## 📖 Usage

### Basic Information Dashboard

- View real-time inventory metrics
- Monitor sales and restock performance
- Identify products requiring immediate attention

### Operational Tasks

1. **Add New Product**: Complete product registration with supplier assignment
2. **Product History**: Track individual product inventory movements
3. **Place Reorder**: Generate purchase orders for low-stock items
4. **Receive Reorder**: Update inventory upon order fulfillment

## 📂 Project Structure

```
inventory-management-dashboard/
├── app.py                 # Main Streamlit application
├── db_functions.py        # Database connection and query functions
├── raw-sql-code.sql       # SQL queries and analysis scripts
├── requirements.txt       # Python dependencies
├── data/                  # Sample CSV data files
│   ├── products.csv
│   ├── suppliers.csv
│   ├── stock_entries.csv
│   ├── reorders.csv
│   └── shipments.csv
└── README.md             # Project documentation
```

## 📚 Learning Outcomes

### SQL Mastery

- **Query Optimization**: Efficient JOIN operations and subquery usage
- **Date Manipulation**: Advanced date functions for time-based analytics
- **Stored Procedures**: Automated business logic implementation
- **Data Aggregation**: Complex mathematical operations and grouping

### Python Integration

- **Database Connectivity**: Seamless MySQL-Python integration
- **Error Handling**: Robust exception management for database operations
- **Data Processing**: Pandas integration for data manipulation

### Full-Stack Development

- **User Interface Design**: Intuitive dashboard creation with Streamlit
- **Business Logic**: Real-world inventory management workflows
- **Data Visualization**: Interactive tables and metric displays

### Business Intelligence

- **KPI Development**: Meaningful metrics for inventory management
- **Operational Efficiency**: Automated reordering and stock tracking
- **Supplier Management**: Comprehensive vendor relationship tracking

---

## 📞 Contact

**Muhammad Muneeb Alam**  
📧 Email: [mmuneeb.alam09@gmail.com](mailto:mmuneeb.alam09@gmail.com)  
💼 LinkedIn: [https://www.linkedin.com/in/muneeb-alam-203014161/](https://www.linkedin.com/in/muneeb-alam-203014161/)  
🐙 GitHub: [github.com/M-MuneebAlam](https://github.com/M-MuneebAlam)

---

⭐ **Star this repository if you found it helpful!**
