-- ### 1. ORDERS TABLE PARTITIONED

-- a. Create new table for orders table
    CREATE TABLE public.orders_new (
        order_id INT NOT NULL,
        customer_id INT,
        payment INT,
        order_date DATE,
        delivery_date DATE,
        payment_status VARCHAR(20) DEFAULT 'Pending',
        CONSTRAINT pk_order_new PRIMARY KEY (order_id, order_date), -- Menambahkan order_date ke dalam primary key
        CONSTRAINT fk_customer_new FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id)
    ) PARTITION BY RANGE (order_date);

--b. Create table partition
    -- Partisi untuk Kuartal 1 (1 Jan - 31 Mar 2021)
    CREATE TABLE orders_new_2021_q1 PARTITION OF orders_new
        FOR VALUES FROM ('2021-01-01') TO ('2021-04-01');

    -- Partisi untuk Kuartal 2 (1 Apr - 30 Jun 2021)
    CREATE TABLE orders_new_2021_q2 PARTITION OF orders_new
        FOR VALUES FROM ('2021-04-01') TO ('2021-07-01');

    -- Partisi untuk Kuartal 3 (1 Jul - 30 Sep 2021)
    CREATE TABLE orders_new_2021_q3 PARTITION OF orders_new
        FOR VALUES FROM ('2021-07-01') TO ('2021-10-01');

    -- Partisi untuk Kuartal 4 (1 Okt - 31 Des 2021)
    CREATE TABLE orders_new_2021_q4 PARTITION OF orders_new
        FOR VALUES FROM ('2021-10-01') TO ('2022-01-01');
   
-- c. Insert data to new table
    INSERT INTO orders_new (order_id, customer_id, payment, order_date, delivery_date, payment_status)
    SELECT order_id, customer_id, payment, order_date::DATE, delivery_date::DATE, payment_status
    FROM orders
    WHERE order_date >= '2021-01-01' AND order_date < '2022-01-01';

--d. Select data
    SELECT * FROM public.orders_new_2021_q1;
    SELECT * FROM public.orders_new_2021_q2;
    SELECT * FROM public.orders_new_2021_q3;
    SELECT * FROM public.orders_new_2021_q4;


--============================================================================--

-- ### 2. PRODUCTS TABLE PARTITIONED

-- a. Create new table for products table
    CREATE TABLE products_new (
        product_id INT NOT NULL,
        product_type VARCHAR(100) NULL,
        product_name VARCHAR(100) NULL,
        "size" VARCHAR(100) NULL,
        colour VARCHAR(100) NULL,
        price INT NULL,
        quantity INT NULL,
        description VARCHAR(100) NULL,
        store_id INT NULL,
        CONSTRAINT pk_product_new PRIMARY KEY (product_id, product_type),
        CONSTRAINT fk_store_new FOREIGN KEY (store_id) REFERENCES public.stores(store_id)
    ) PARTITION BY LIST (product_type);


--b. Create table partition
    -- Partisi untuk jenis produk Trousers
    CREATE TABLE products_new_trousers PARTITION OF products_new
        FOR VALUES IN ('Trousers');

    -- Partisi untuk jenis produk Shirt
    CREATE TABLE products_new_shirt PARTITION OF products_new
        FOR VALUES IN ('Shirt');

    -- Partisi untuk jenis produk Jacket
    CREATE TABLE products_new_jacket PARTITION OF products_new
        FOR VALUES IN ('Jacket');

-- c. Insert data to new table
    INSERT INTO products_new (product_id, product_type, product_name, "size", colour, price, quantity, description, store_id)
    SELECT product_id, product_type, product_name, "size", colour, price, quantity, description, store_id
    FROM products;

--d. Select data
    SELECT * FROM public.products_new_jacket;
    SELECT * FROM public.products_new_shirt;
    SELECT * FROM public.products_new_trousers;