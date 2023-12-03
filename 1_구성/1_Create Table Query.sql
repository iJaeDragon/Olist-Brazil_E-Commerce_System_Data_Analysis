CREATE TABLE olist_customers (
    customer_id VARCHAR2(255),
    customer_unique_id VARCHAR2(255),
    customer_zip_code_prefix NUMBER,
    customer_city VARCHAR2(255),
    customer_state VARCHAR2(255)
);

CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix NUMBER,
    geolocation_lat NUMBER,
    geolocation_lng NUMBER,
    geolocation_city VARCHAR2(255),
    geolocation_state VARCHAR2(255)
);

CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR2(255),
    order_item_id NUMBER,
    product_id VARCHAR2(255),
    seller_id VARCHAR2(255),
    shipping_limit_date VARCHAR2(255),
    price NUMBER,
    freight_value NUMBER
);

CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR2(255),
    payment_sequential NUMBER,
    payment_type VARCHAR2(255),
    payment_installments NUMBER,
    payment_value NUMBER
);

CREATE TABLE olist_order_reviews_dataset (
    review_id VARCHAR2(255),
    order_id VARCHAR2(255),
    review_score NUMBER,
    review_comment_title VARCHAR2(255),
    review_comment_message VARCHAR2(255),
    review_creation_date VARCHAR2(255),
    review_answer_timestamp VARCHAR2(255)
);

CREATE TABLE olist_orders_dataset (
    order_id VARCHAR2(255),
    customer_id VARCHAR2(255),
    order_status VARCHAR2(255),
    order_purchase_timestamp VARCHAR2(255),
    order_approved_at VARCHAR2(255),
    order_delivered_carrier_date VARCHAR2(255),
    order_delivered_customer_date VARCHAR2(255),
    order_estimated_delivery_date VARCHAR2(255)
);

CREATE TABLE olist_products_dataset (
    product_id VARCHAR2(255),
    product_category_name VARCHAR2(255),
    product_name_lenght NUMBER,
    product_description_lenght NUMBER,
    product_photos_qty NUMBER,
    product_weight_g NUMBER,
    product_length_cm NUMBER,
    product_height_cm NUMBER,
    product_width_cm NUMBER
);

CREATE TABLE olist_sellers_dataset (
    seller_id VARCHAR2(255),
    seller_zip_code_prefix NUMBER,
    seller_city VARCHAR2(255),
    seller_state VARCHAR2(255)
);

CREATE TABLE product_category_name_trans (
    product_category_name VARCHAR2(255),
    product_category_name_english VARCHAR2(255)
);