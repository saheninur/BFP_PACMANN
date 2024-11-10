-- Database: elibrary
-- DROP DATABASE IF EXISTS elibrary;

CREATE DATABASE elibrary
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Indonesia.1252'
    LC_CTYPE = 'English_Indonesia.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


-- public.libraries definition
-- Drop table
-- DROP TABLE public.libraries;

CREATE TABLE public.libraries (
	library_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	"location" varchar(255) NULL,
	CONSTRAINT libraries_pkey PRIMARY KEY (library_id)
);

-- public.categories definition
-- Drop table
-- DROP TABLE public.categories;

CREATE TABLE public.categories (
	category_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT categories_pkey PRIMARY KEY (category_id)
);

-- public.books definition
-- Drop table
-- DROP TABLE public.books;

CREATE TABLE public.books (
	book_id serial4 NOT NULL,
	title varchar(255) NOT NULL,
	author varchar(255) NOT NULL,
	category_id int4 NULL,
	description text NULL,
	CONSTRAINT books_pkey PRIMARY KEY (book_id)
);

-- public.books foreign keys
ALTER TABLE public.books ADD CONSTRAINT books_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


-- public.inventory definition
-- Drop table
-- DROP TABLE public.inventory;

CREATE TABLE public.inventory (
	inventory_id serial4 NOT NULL,
	book_id int4 NULL,
	library_id int4 NULL,
	quantity int4 NOT NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id),
	CONSTRAINT inventory_quantity_check CHECK ((quantity >= 0))
);

-- public.inventory foreign keys
ALTER TABLE public.inventory ADD CONSTRAINT inventory_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);
ALTER TABLE public.inventory ADD CONSTRAINT inventory_library_id_fkey FOREIGN KEY (library_id) REFERENCES public.libraries(library_id);


-- public.users definition
-- Drop table
-- DROP TABLE public.users;

CREATE TABLE public.users (
	user_id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	phone_number varchar(20) NULL,
	country varchar(100) NULL,
	city varchar(100) NULL,
	postal_code varchar(20) NULL,
	CONSTRAINT users_email_key UNIQUE (email),
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
);


-- public.loans definition
-- Drop table
-- DROP TABLE public.loans;

CREATE TABLE public.loans (
	loan_id serial4 NOT NULL,
	user_id int4 NULL,
	book_id int4 NULL,
	loan_date date NOT NULL,
	due_date date NOT NULL,
	return_date date NULL,
	CONSTRAINT loans_pkey PRIMARY KEY (loan_id)
);

-- public.loans foreign keys
ALTER TABLE public.loans ADD CONSTRAINT loans_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);
ALTER TABLE public.loans ADD CONSTRAINT loans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


-- public.holds definition
-- Drop table
-- DROP TABLE public.holds;

CREATE TABLE public.holds (
	hold_id serial4 NOT NULL,
	user_id int4 NULL,
	book_id int4 NULL,
	hold_date date NOT NULL,
	expiry_date date NOT NULL,
	CONSTRAINT holds_pkey PRIMARY KEY (hold_id)
);

-- public.holds foreign keys
ALTER TABLE public.holds ADD CONSTRAINT holds_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);
ALTER TABLE public.holds ADD CONSTRAINT holds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
