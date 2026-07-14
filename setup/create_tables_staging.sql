-- ============================================================
-- ShopNest Philippines — Staging Schema
-- ============================================================
-- These are the STAGING tables (stg_ prefix).
-- They have no FK constraints, no UNIQUE constraints on business
-- columns, no CHECK constraints, and no NOT NULL on non-PK columns.
-- Purpose: accept the raw CSV data without rejecting dirty rows.
-- Students migrate from here into the production tables after cleaning.
-- See create_tables_production.sql for the full-constraint target schema.
-- ============================================================

CREATE TABLE stg_categories (
    category_id        VARCHAR(50)     PRIMARY KEY,
    category_name      VARCHAR(100),
    parent_category_id VARCHAR(50),
    description        TEXT,
    is_active          BOOLEAN,
    created_at         TIMESTAMP
);

CREATE TABLE stg_customers (
    customer_id         VARCHAR(50)     PRIMARY KEY,
    first_name          VARCHAR(100),
    last_name           VARCHAR(100),
    email               VARCHAR(255),
    phone               VARCHAR(50),
    date_of_birth       DATE,
    gender              VARCHAR(50),
    address_line_1      VARCHAR(255),
    address_line_2      VARCHAR(255),
    city                VARCHAR(100),
    state               VARCHAR(100),
    postcode            VARCHAR(20),
    country             VARCHAR(50),
    customer_segment    VARCHAR(50),
    loyalty_tier        VARCHAR(50),
    acquisition_channel VARCHAR(100),
    is_active           BOOLEAN,
    created_at          TIMESTAMP,
    updated_at          TIMESTAMP
);

CREATE TABLE stg_products (
    product_id   VARCHAR(50)     PRIMARY KEY,
    category_id  VARCHAR(50),
    sku          VARCHAR(100),
    product_name VARCHAR(255),
    description  TEXT,
    brand        VARCHAR(100),
    unit_price   NUMERIC(10,2),
    cost_price   NUMERIC(10,2),
    weight_kg    NUMERIC(8,3),
    is_active    BOOLEAN,
    created_at   TIMESTAMP,
    updated_at   TIMESTAMP
);

CREATE TABLE stg_orders (
    order_id                VARCHAR(50)     PRIMARY KEY,
    customer_id             VARCHAR(50),
    order_status            VARCHAR(50),
    order_date              TIMESTAMP,
    shipped_date            TIMESTAMP,
    delivered_date          TIMESTAMP,
    shipping_address_line_1 VARCHAR(255),
    shipping_city           VARCHAR(100),
    shipping_state          VARCHAR(100),
    shipping_postcode       VARCHAR(20),
    shipping_method         VARCHAR(50),
    subtotal_amount         NUMERIC(12,2),
    discount_amount         NUMERIC(12,2),
    tax_amount              NUMERIC(12,2),
    shipping_amount         NUMERIC(12,2),
    total_amount            NUMERIC(12,2),
    currency                VARCHAR(10),
    coupon_code             VARCHAR(50),
    notes                   TEXT,
    created_at              TIMESTAMP,
    updated_at              TIMESTAMP
);

CREATE TABLE stg_order_items (
    order_item_id VARCHAR(50)     PRIMARY KEY,
    order_id      VARCHAR(50),
    product_id    VARCHAR(50),
    quantity      INT,
    unit_price    NUMERIC(10,2),
    discount_pct  NUMERIC(5,2),
    line_total    NUMERIC(12,2),
    created_at    TIMESTAMP
);

CREATE TABLE stg_payments (
    payment_id            VARCHAR(50)     PRIMARY KEY,
    order_id              VARCHAR(50),
    payment_method        VARCHAR(100),
    payment_status        VARCHAR(50),
    amount                NUMERIC(12,2),
    currency              VARCHAR(10),
    transaction_reference VARCHAR(100),
    payment_date          TIMESTAMP,
    created_at            TIMESTAMP
);

CREATE TABLE stg_reviews (
    review_id            VARCHAR(50)     PRIMARY KEY,
    product_id           VARCHAR(50),
    customer_id          VARCHAR(50),
    order_id             VARCHAR(50),
    rating               INT,
    review_title         VARCHAR(255),
    review_body          TEXT,
    is_verified_purchase BOOLEAN,
    helpful_votes        INT,
    review_date          TIMESTAMP,
    created_at           TIMESTAMP
);

CREATE TABLE stg_returns (
    return_id           VARCHAR(50)     PRIMARY KEY,
    order_id            VARCHAR(50),
    order_item_id       VARCHAR(50),
    customer_id         VARCHAR(50),
    return_reason       VARCHAR(255),
    return_status       VARCHAR(50),
    refund_amount       NUMERIC(12,2),
    return_requested_at TIMESTAMP,
    return_completed_at TIMESTAMP,
    created_at          TIMESTAMP
);

CREATE TABLE stg_inventory (
    inventory_id       VARCHAR(50)     PRIMARY KEY,
    product_id         VARCHAR(50),
    warehouse_code     VARCHAR(50),
    quantity_on_hand   INT,
    quantity_reserved  INT,
    quantity_available INT,
    reorder_point      INT,
    reorder_quantity   INT,
    last_restocked_at  TIMESTAMP,
    updated_at         TIMESTAMP
);