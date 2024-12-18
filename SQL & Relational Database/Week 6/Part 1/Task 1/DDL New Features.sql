-- Membuat tabel stores
CREATE TABLE public.stores (
    store_id int4 NOT NULL,
    store_name varchar(100) NULL,
    address varchar(255) NULL,
    CONSTRAINT stores_pk PRIMARY KEY (store_id)
);

-- Membuat tabel cart
CREATE TABLE public.cart (
    cart_id int4 NOT NULL,
    customer_id int4 NOT NULL,
    product_id int4 NOT NULL,
    quantity int4 CHECK (quantity > 0),
    CONSTRAINT cart_pk PRIMARY KEY (cart_id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES public.products(product_id)
);

-- Membuat tabel wishlist
CREATE TABLE public.wishlist (
    wishlist_id int4 NOT NULL,
    customer_id int4 NOT NULL,
    product_id int4 NOT NULL,
    CONSTRAINT wishlist_pk PRIMARY KEY (wishlist_id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES public.products(product_id)
);

-- Membuat tabel payments
CREATE TABLE public.payments (
    payment_id int4 NOT NULL,
    order_id int4 NOT NULL,
    payment_method varchar(50) NOT NULL,
    amount numeric NOT NULL CHECK (amount > 0),
    payment_date timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT payments_pk PRIMARY KEY (payment_id),
    FOREIGN KEY (order_id) REFERENCES public.orders(order_id)
);

-- Membuat tabel product_reviews
CREATE TABLE public.product_reviews (
    review_id int4 NOT NULL,
    customer_id int4 NOT NULL,
    product_id int4 NOT NULL,
    rating int4 CHECK (rating BETWEEN 1 AND 5),
    review_text text,
    review_date timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT review_pk PRIMARY KEY (review_id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES public.products(product_id)
);

-- Menambahkan kolom store_id ke tabel products
ALTER TABLE public.products
ADD COLUMN store_id int4,
ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES public.stores(store_id);

-- Menambahkan kolom payment_status dan total_amount ke tabel orders
ALTER TABLE public.orders
ADD COLUMN payment_status varchar(20) DEFAULT 'Pending';



