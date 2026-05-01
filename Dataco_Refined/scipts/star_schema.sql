-- ============================================
-- DataCo Supply Chain Analysis
-- Script: star_schema
-- Purpose: Creates star schema tables with 
--          proper relationships and constraints
-- Date: May 2026
-- ============================================


-- =============================================
-- DIMENSION TABLES
-- =============================================
CREATE TABLE dim_date (
    date_key        INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    full_date       DATE         NOT NULL,
    year            INT          NOT NULL,
    quarter         INT          NOT NULL,
    month           INT          NOT NULL,
    month_name      NVARCHAR(20) NOT NULL,
    week            INT          NOT NULL,
    day             INT          NOT NULL,
    day_name        NVARCHAR(20) NOT NULL,
    is_weekend      BIT          NOT NULL,
    year_month      NVARCHAR(7)  NOT NULL  -- format: '2015-01'
);

CREATE TABLE dim_customer (
    customer_key      INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    customer_id       INT           NOT NULL,  -- natural key from source
    first_name        NVARCHAR(100) NOT NULL,
    last_name         NVARCHAR(100) NULL,
    customer_segment  NVARCHAR(50)  NOT NULL,
    customer_city     NVARCHAR(100) NULL,
    customer_state    NVARCHAR(100) NULL,
    customer_country  NVARCHAR(100) NULL,
    customer_street   NVARCHAR(255) NULL,
    customer_zipcode  NVARCHAR(20)  NULL
);

CREATE TABLE dim_product (
    product_key      INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    product_card_id  INT           NOT NULL,  -- natural key from source
    product_name     NVARCHAR(200) NOT NULL,
    category_id      INT           NOT NULL,
    category_name    NVARCHAR(100) NOT NULL,
    department_id    INT           NOT NULL,
    department_name  NVARCHAR(100) NOT NULL,
    product_price    FLOAT         NOT NULL,
    launch_year      INT           NOT NULL,
    launch_date      DATE          NOT NULL,
    cohort_label     NVARCHAR(20)  NOT NULL   -- 'Established' / 'New'
);

CREATE TABLE dim_shipping (
    shipping_mode_key  INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    shipping_mode      NVARCHAR(50) NOT NULL
);

-- =============================================
-- FACT TABLE
-- =============================================


CREATE TABLE fact_orders (
    order_item_id          INT          NOT NULL PRIMARY KEY,
    order_id               INT          NOT NULL,
    customer_key           INT          NOT NULL,
    product_key            INT          NOT NULL,
    date_key               INT          NOT NULL,
    shipping_mode_key      INT          NOT NULL,
    time_key               INT          NOT NULL, -- New Column
    -- measures
    sales                  FLOAT        NULL,
    product_profit         FLOAT        NULL,
    order_item_quantity    INT          NULL,
    order_item_discount    FLOAT        NULL,
    order_item_discount_rate FLOAT      NULL,
    order_item_total       FLOAT        NULL,
    order_item_profit_ratio FLOAT       NULL,
    days_shipping_scheduled INT         NULL,
    days_shipping_actual   INT          NULL,
    days_of_delay          INT          NULL,
    severity_score         FLOAT        NULL,
    -- indicators
    is_late                TINYINT      NULL,
    non_revenue_flag       TINYINT      NULL,
    profit_segment         NVARCHAR(20) NULL,
    order_status           NVARCHAR(50) NULL,
    -- geographic columns
    order_city     NVARCHAR(100)        NULL,
    order_state    NVARCHAR(100)        NULL,
    order_country  NVARCHAR(100)        NULL,
    order_region   NVARCHAR(100)        NULL,
    market         NVARCHAR(50)         NULL,
    state_segment  NVARCHAR(20)         NULL,
    latitude       FLOAT                NULL,
    longitude      FLOAT                NULL,
    -- foreign keys
    CONSTRAINT fk_customer  FOREIGN KEY (customer_key)      REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_product   FOREIGN KEY (product_key)       REFERENCES dim_product(product_key),
    CONSTRAINT fk_date      FOREIGN KEY (date_key)          REFERENCES dim_date(date_key),
    CONSTRAINT fk_shipping  FOREIGN KEY (shipping_mode_key) REFERENCES dim_shipping(shipping_mode_key),
);
