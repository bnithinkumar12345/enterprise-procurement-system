# Enterprise Procurement System

## Overview
The Enterprise Procurement System is a full-stack web application designed to streamline internal procurement workflows. It handles everything from requisition creation and multi-level approvals to purchase order generation and warehouse receiving.

## Architecture
The system employs a standard 3-tier architecture with a React frontend, Spring Boot backend, and PostgreSQL database.

## Technology Stack
**Frontend:**
- React
- Vite
- JavaScript
- CSS

**Backend:**
- Java 17
- Spring Boot
- Maven
- Spring Security (JWT)

**Database:**
- PostgreSQL 15+

## Core Modules
- Authentication & JWT
- Requisition Management
- Approval Workflow (Manager, Finance, Admin)
- Supplier Management & Verification
- Purchase Orders
- Warehouse Receiving
- Approval History
- Notifications

## System Flow
1. **Requester** submits a requisition.
2. **Manager** approves.
3. **Finance** approves.
4. **Procurement Admin** reviews.
5. **Procurement Admin** assigns/verifies the Supplier.
6. System generates a **Purchase Order (PO)**.
7. **Warehouse Receiver** records goods received against the PO.
8. System marks order as **Completed**.

## Project Structure
`
enterprise-procurement-system/
├── backend/          # Spring Boot Application
├── frontend/         # React/Vite Application
└── database/         # PostgreSQL schema and migrations
    ├── migrations/
    └── schema/
`

## Prerequisites
- **Java**: 17+
- **Maven**: 3.8+
- **Node.js**: 18+
- **npm**: 9+
- **PostgreSQL**: 15+

## Database Setup
1. Create a PostgreSQL database named enterprise_procurement.
2. Apply the base schema:
   \psql -U postgres -d enterprise_procurement -f database/schema/enterprise_procurement_schema.sql\
3. Apply migrations in order:
   \psql -U postgres -d enterprise_procurement -f database/migrations/update_schema.sql\
   \psql -U postgres -d enterprise_procurement -f database/migrations/update_schema_1.sql\
   \psql -U postgres -d enterprise_procurement -f database/migrations/fix_po_receipts_columns.sql\
   \psql -U postgres -d enterprise_procurement -f database/migrations/fix_purchase_orders_schema.sql\

## Backend Setup
1. Navigate to the \ackend\ directory.
2. Copy \src/main/resources/application-example.properties\ to \pplication.properties\ and configure your database credentials.
3. Run:
   \mvn clean install\
   \mvn spring-boot:run\

## Frontend Setup
1. Navigate to the \rontend\ directory.
2. Copy \.env.example\ to \.env\.
3. Run:
   \
pm install\
   \
pm run dev\

## Development Workflow
To run this project locally, execute the database setup commands above, start the backend on port 8080, and run the frontend Vite server. 
