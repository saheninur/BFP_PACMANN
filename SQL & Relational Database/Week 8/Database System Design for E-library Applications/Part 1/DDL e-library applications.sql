CREATE TABLE libraries (
    library_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    category_id INTEGER REFERENCES Categories(category_id),
    description TEXT
);


CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES Books(book_id),
    library_id INTEGER REFERENCES Libraries(library_id),
    quantity INTEGER NOT NULL CHECK (quantity >= 0)
);


CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20)
);


CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    book_id INTEGER REFERENCES Books(book_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE
);

CREATE TABLE holds (
    hold_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    book_id INTEGER REFERENCES Books(book_id),
    hold_date DATE NOT NULL,
    expiry_date DATE NOT NULL
);
