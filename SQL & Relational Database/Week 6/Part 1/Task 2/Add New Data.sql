-- Add New Data Customer
INSERT INTO public.customers (customer_id,customer_name,gender,age,home_address,zip_code,city,state,country)
	VALUES (1001,'Heni','Female',71,'1671 Lauren KnollSuite 945',9012,'Lake Audreyborough','Tasmania','Australia');
INSERT INTO public.customers (customer_id,customer_name,gender,age,home_address,zip_code,city,state,country)
	VALUES (1002,'Nur','Female',71,'1671 Lauren KnollSuite 945',9012,'Lake Audreyborough','Tasmania','Australia');
INSERT INTO public.customers (customer_id,customer_name,gender,age,home_address,zip_code,city,state,country)
	VALUES (1003,'Safitri','Female',71,'1671 Lauren KnollSuite 945',9012,'Lake Audreyborough','Tasmania','Australia');
INSERT INTO public.customers (customer_id,customer_name,gender,age,home_address,zip_code,city,state,country)
	VALUES (1004,'Vincent','Male',72,'997 Harrison KnollSuite 735',6621,'Boscoville','Victoria','Australia');
INSERT INTO public.customers (customer_id,customer_name,gender,age,home_address,zip_code,city,state,country)
	VALUES (1005,'Nober','Male',72,'997 Harrison KnollSuite 735',6621,'Boscoville','Victoria','Australia');


-- Add New Data Store
INSERT INTO public.stores (store_id,store_name,address)
	VALUES (1,'Victoria Mini Shop','Victoria');
INSERT INTO public.stores (store_id,store_name,address)
	VALUES (2,'Boscoville Mini Shop','Boscoville');

-- Add New Data Products
INSERT INTO public.products (product_id,product_type,product_name,"size",colour,price,quantity,description,store_id)
	VALUES (1260,'Trousers','Home Trousers','S','white',90,60,'A white coloured, S sized, Home Trousers',2);
INSERT INTO public.products (product_id,product_type,product_name,"size",colour,price,quantity,description,store_id)
	VALUES (1261,'Trousers','Home Trousers','S','black',90,60,'A black coloured, S sized, Home Trousers',2);

-- Add New Data wishlist
INSERT INTO public.wishlist (wishlist_id,customer_id,product_id)
	VALUES (1,1001,1260);
INSERT INTO public.wishlist (wishlist_id,customer_id,product_id)
	VALUES (2,1001,1261);


-- Add New Data cart
INSERT INTO public.cart (cart_id,customer_id,product_id,quantity)
	VALUES (1,1001,1260,2);
INSERT INTO public.cart (cart_id,customer_id,product_id,quantity)
	VALUES (2,1001,1260,1);

-- Add New Data Orders
INSERT INTO public.orders (order_id,customer_id,payment,order_date,delivery_date,payment_status)
	VALUES (1006,1002,900,'2023-02-10','2023-02-10','Paid');
INSERT INTO public.orders (order_id,customer_id,payment,order_date,delivery_date,payment_status)
	VALUES (1007,1005,900,'2023-02-15','2023-02-15','Paid');
INSERT INTO public.orders (order_id,customer_id,payment,order_date,delivery_date,payment_status)
	VALUES (1008,1002,900,'2023-02-20','2023-02-20','Paid');
INSERT INTO public.orders (order_id,customer_id,payment,order_date,delivery_date,payment_status)
	VALUES (1009,1003,900,'2023-02-25','2023-02-25','Paid');
INSERT INTO public.orders (order_id,customer_id,payment,order_date,delivery_date,payment_status)
	VALUES (1010,1004,900,'2023-02-25','2023-02-25','Paid');


-- Add New Data Sales
INSERT INTO public.sales (sales_id,order_id,product_id,price_per_unit,quantity,total_price)
	VALUES (5005,1006,1260,90,10,900);
INSERT INTO public.sales (sales_id,order_id,product_id,price_per_unit,quantity,total_price)
	VALUES (5006,1007,1260,90,10,900);
INSERT INTO public.sales (sales_id,order_id,product_id,price_per_unit,quantity,total_price)
	VALUES (5007,1008,1260,90,10,900);
INSERT INTO public.sales (sales_id,order_id,product_id,price_per_unit,quantity,total_price)
	VALUES (5008,1090,1260,90,10,900);		
INSERT INTO public.sales (sales_id,order_id,product_id,price_per_unit,quantity,total_price)
	VALUES (5009,1010,1260,90,10,900);


-- Add New Data payments
INSERT INTO public.payments (payment_id,order_id,payment_method,amount,payment_date)
	VALUES (1,1006,'CC',900,'2023-02-10');
INSERT INTO public.payments (payment_id,order_id,payment_method,amount,payment_date)
	VALUES (2,1007,'CC',900,'2023-02-15');
INSERT INTO public.payments (payment_id,order_id,payment_method,amount,payment_date)
	VALUES (3,1008,'CC',900,'2023-02-20');
INSERT INTO public.payments (payment_id,order_id,payment_method,amount,payment_date)
	VALUES (4,1009,'CC',900,'2023-02-25');
INSERT INTO public.payments (payment_id,order_id,payment_method,amount,payment_date)
	VALUES (5,1010,'CC',900,'2023-02-25');


