-- ============================================================
-- ShopNest Philippines — Production Schema
-- ============================================================
-- These are the PRODUCTION tables (no prefix).
-- They have full constraints: FK references, UNIQUE on business
-- columns, CHECK conditions, and NOT NULL on required fields.
-- Purpose: enforce data quality. These tables start empty.
-- Students migrate cleaned data here from the stg_ staging tables.
-- See create_tables_staging.sql for the constraint-free landing zone.
-- ============================================================

CREATE TABLE categories (
    category_id        VARCHAR(50)     PRIMARY KEY,
    category_name      VARCHAR(100)    NOT NULL,
    parent_category_id VARCHAR(50)     REFERENCES categories(category_id),
    description        TEXT,
    is_active          BOOLEAN         NOT NULL,
    created_at         TIMESTAMP       NOT NULL
);

CREATE TABLE customers (
    customer_id         VARCHAR(50)     PRIMARY KEY,
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    email               VARCHAR(255)    NOT NULL UNIQUE,
    phone               VARCHAR(50),
    date_of_birth       DATE,
    gender              VARCHAR(50),
    address_line_1      VARCHAR(255)    NOT NULL,
    address_line_2      VARCHAR(255),
    city                VARCHAR(100)    NOT NULL,
    state               VARCHAR(100)    NOT NULL,
    postcode            VARCHAR(20)     NOT NULL,
    country             VARCHAR(50)     NOT NULL,
    customer_segment    VARCHAR(50)     NOT NULL,
    loyalty_tier        VARCHAR(50),
    acquisition_channel VARCHAR(100)    NOT NULL,
    is_active           BOOLEAN         NOT NULL,
    created_at          TIMESTAMP       NOT NULL,
    updated_at          TIMESTAMP       NOT NULL
);

CREATE TABLE products (
    product_id   VARCHAR(50)     PRIMARY KEY,
    category_id  VARCHAR(50)     REFERENCES categories(category_id),
    sku          VARCHAR(100)    NOT NULL UNIQUE,
    product_name VARCHAR(255)    NOT NULL,
    description  TEXT,
    brand        VARCHAR(100),
    unit_price   NUMERIC(10,2)   NOT NULL,
    cost_price   NUMERIC(10,2),
    weight_kg    NUMERIC(8,3),
    is_active    BOOLEAN         NOT NULL,
    created_at   TIMESTAMP       NOT NULL,
    updated_at   TIMESTAMP       NOT NULL
);

CREATE TABLE orders (
    order_id                VARCHAR(50)     PRIMARY KEY,
    customer_id             VARCHAR(50)     REFERENCES customers(customer_id),
    order_status            VARCHAR(50)     NOT NULL,
    order_date              TIMESTAMP       NOT NULL,
    shipped_date            TIMESTAMP,
    delivered_date          TIMESTAMP,
    shipping_address_line_1 VARCHAR(255)    NOT NULL,
    shipping_city           VARCHAR(100)    NOT NULL,
    shipping_state          VARCHAR(100)    NOT NULL,
    shipping_postcode       VARCHAR(20)     NOT NULL,
    shipping_method         VARCHAR(50)     NOT NULL,
    subtotal_amount         NUMERIC(12,2)   NOT NULL,
    discount_amount         NUMERIC(12,2),
    tax_amount              NUMERIC(12,2)   NOT NULL,
    shipping_amount         NUMERIC(12,2)   NOT NULL,
    total_amount            NUMERIC(12,2)   NOT NULL,
    currency                VARCHAR(10)     NOT NULL,
    coupon_code             VARCHAR(50),
    notes                   TEXT,
    created_at              TIMESTAMP       NOT NULL,
    updated_at              TIMESTAMP       NOT NULL
);

CREATE TABLE order_items (
    order_item_id VARCHAR(50)     PRIMARY KEY,
    order_id      VARCHAR(50)     REFERENCES orders(order_id),
    product_id    VARCHAR(50)     REFERENCES products(product_id),
    quantity      INT             NOT NULL,
    unit_price    NUMERIC(10,2)   NOT NULL,
    discount_pct  NUMERIC(5,2),
    line_total    NUMERIC(12,2)   NOT NULL,
    created_at    TIMESTAMP       NOT NULL
);

CREATE TABLE payments (
    payment_id            VARCHAR(50)     PRIMARY KEY,
    order_id              VARCHAR(50)     REFERENCES orders(order_id),
    payment_method        VARCHAR(100)    NOT NULL,
    payment_status        VARCHAR(50)     NOT NULL,
    amount                NUMERIC(12,2)   NOT NULL,
    currency              VARCHAR(10)     NOT NULL,
    transaction_reference VARCHAR(100),
    payment_date          TIMESTAMP       NOT NULL,
    created_at            TIMESTAMP       NOT NULL
);

CREATE TABLE reviews (
    review_id            VARCHAR(50)     PRIMARY KEY,
    product_id           VARCHAR(50)     REFERENCES products(product_id),
    customer_id          VARCHAR(50)     REFERENCES customers(customer_id),
    order_id             VARCHAR(50)     REFERENCES orders(order_id),
    rating               INT             NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_title         VARCHAR(255),
    review_body          TEXT,
    is_verified_purchase BOOLEAN         NOT NULL,
    helpful_votes        INT             NOT NULL,
    review_date          TIMESTAMP       NOT NULL,
    created_at           TIMESTAMP       NOT NULL
);

CREATE TABLE returns (
    return_id           VARCHAR(50)     PRIMARY KEY,
    order_id            VARCHAR(50)     REFERENCES orders(order_id),
    order_item_id       VARCHAR(50)     REFERENCES order_items(order_item_id),
    customer_id         VARCHAR(50)     REFERENCES customers(customer_id),
    return_reason       VARCHAR(255)    NOT NULL,
    return_status       VARCHAR(50)     NOT NULL,
    refund_amount       NUMERIC(12,2),
    return_requested_at TIMESTAMP       NOT NULL,
    return_completed_at TIMESTAMP,
    created_at          TIMESTAMP       NOT NULL
);

CREATE TABLE inventory (
    inventory_id       VARCHAR(50)     PRIMARY KEY,
    product_id         VARCHAR(50)     REFERENCES products(product_id),
    warehouse_code     VARCHAR(50)     NOT NULL,
    quantity_on_hand   INT             NOT NULL,
    quantity_reserved  INT             NOT NULL,
    quantity_available INT             NOT NULL,
    reorder_point      INT             NOT NULL,
    reorder_quantity   INT             NOT NULL,
    last_restocked_at  TIMESTAMP,
    updated_at         TIMESTAMP       NOT NULL
);