from faker import Faker
import random
import csv
import psycopg2
from datetime import timedelta

# Initialize Faker and set connection
fake = Faker()

# Membuat koneksi ke PostgreSQL
try:
    conn = psycopg2.connect(
        dbname="elibrary", 
        user="postgres", 
        password="password", 
        host="localhost", 
        port="5432"
    )
    cursor = conn.cursor()
    print("Koneksi ke database berhasil!")
except Exception as e:
    print(f"Error koneksi ke database: {e}")
    exit()

cur = conn.cursor()

# Data volume settings
num_libraries = 50
num_categories = 10  # Genres for categories
num_books = 200
num_users = 500
num_loans = 1000  # Total number of loans will increase with multiple loans per user
num_holds = 200

# Helper function to write CSV files
def write_to_csv(file_name, data, headers):
    with open(file_name, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        writer.writerows(data)

# Libraries data
libraries_data = [(fake.company(), fake.address()) for _ in range(num_libraries)]
write_to_csv("C:/Users/Simian/Downloads/libraries.csv", libraries_data, ["name", "location"])

try:
    cur.executemany("INSERT INTO libraries (name, location) VALUES (%s, %s);", libraries_data)
    conn.commit()  # Commit setelah memasukkan data library
    print("Libraries data inserted successfully.")
except Exception as e:
    print(f"Error inserting libraries: {e}")
    conn.rollback()  # Rollback jika terjadi error

# Categories data (updated genres)
category_names = ["Science", "Fiction", "History", "Technology", "Arts", "Philosophy", "Biography", "Children", "Mystery", "Cookbook"]
categories_data = [(name,) for name in category_names]
write_to_csv("C:/Users/Simian/Downloads/categories.csv", categories_data, ["name"])

try:
    cur.executemany("INSERT INTO categories (name) VALUES (%s);", categories_data)
    conn.commit()  # Commit setelah memasukkan data kategori
    print("Categories data inserted successfully.")
except Exception as e:
    print(f"Error inserting categories: {e}")
    conn.rollback()  # Rollback jika terjadi error

# Ambil category_id yang valid dari tabel categories setelah insert
cur.execute("SELECT category_id FROM categories;")
category_ids = [result[0] for result in cur.fetchall()]  # Ambil category_id yang ada di tabel

# Books data using updated category_ids
books_data = [
    (fake.catch_phrase(), fake.name(), fake.random_element(category_ids), fake.text(max_nb_chars=200))
    for _ in range(num_books)
]
write_to_csv("C:/Users/Simian/Downloads/books.csv", books_data, ["title", "author", "category_id", "description"])

try:
    cur.executemany("INSERT INTO books (title, author, category_id, description) VALUES (%s, %s, %s, %s);", books_data)
    conn.commit()  # Commit setelah memasukkan data books
    print("Books data inserted successfully.")
except Exception as e:
    print(f"Error inserting books: {e}")
    conn.rollback()  # Rollback jika terjadi error

# Inventory data
inventory_data = [
    (fake.random_element(range(1, num_books + 1)), fake.random_element(range(1, num_libraries + 1)), fake.random_int(min=1, max=20))
    for _ in range(num_books)
]
write_to_csv("C:/Users/Simian/Downloads/inventory.csv", inventory_data, ["book_id", "library_id", "quantity"])

try:
    cur.executemany("INSERT INTO inventory (book_id, library_id, quantity) VALUES (%s, %s, %s);", inventory_data)
    conn.commit()  # Commit setelah memasukkan data inventory
    print("Inventory data inserted successfully.")
except Exception as e:
    print(f"Error inserting inventory: {e}")
    conn.rollback()  # Rollback jika terjadi error

# Users data
users_data = [
    (fake.name(), fake.unique.email(), fake.phone_number()[:12], fake.country(), fake.city(), fake.postcode())  # Membatasi phone_number hingga 12 karakter
    for _ in range(num_users)
]
write_to_csv("C:/Users/Simian/Downloads/users.csv", users_data, ["name", "email", "phone_number", "country", "city", "postal_code"])

try:
    cur.executemany("INSERT INTO users (name, email, phone_number, country, city, postal_code) VALUES (%s, %s, %s, %s, %s, %s);", users_data)
    conn.commit()  # Commit setelah memasukkan data users
    print("Users data inserted successfully.")
except Exception as e:
    print(f"Error inserting users: {e}")
    conn.rollback()  # Rollback jika terjadi error

# Number of loan transactions per user
num_loans_per_user = 10  # Adjust this number to your preference (e.g., 10 loans per user)

# Loans data: Create more loans for each user
# Loans data generation: loan_date < due_date, and due_date is max 2 weeks after loan_date
loans_data = []
for _ in range(num_loans):
    user_id = fake.random_element(range(1, num_users + 1))
    book_id = fake.random_element(range(1, num_books + 1))
    loan_date = fake.date_this_year(before_today=True, after_today=False)
    due_date = loan_date + timedelta(days=random.randint(1, 14))  # Ensure due_date is within 2 weeks
    loans_data.append((user_id, book_id, loan_date, due_date))

write_to_csv("C:/Users/Simian/Downloads/loans.csv", loans_data, ["user_id", "book_id", "loan_date", "due_date"])

try:
    cur.executemany("INSERT INTO loans (user_id, book_id, loan_date, due_date) VALUES (%s, %s, %s, %s);", loans_data)
    conn.commit()  # Commit after inserting loan data
    print("Loans data inserted successfully.")
except Exception as e:
    print(f"Error inserting loans: {e}")
    conn.rollback()  # Rollback if there's an error

# Holds data
# Holds data generation: hold_date < expiry_date, and expiry_date is max 1 week after hold_date
holds_data = []
for _ in range(num_holds):
    user_id = fake.random_element(range(1, num_users + 1))
    book_id = fake.random_element(range(1, num_books + 1))
    hold_date = fake.date_this_year(before_today=True, after_today=False)
    expiry_date = hold_date + timedelta(days=random.randint(1, 7))  # Ensure expiry_date is within 1 week
    holds_data.append((user_id, book_id, hold_date, expiry_date))

write_to_csv("C:/Users/Simian/Downloads/holds.csv", holds_data, ["user_id", "book_id", "hold_date", "expiry_date"])

try:
    cur.executemany("INSERT INTO holds (user_id, book_id, hold_date, expiry_date) VALUES (%s, %s, %s, %s);", holds_data)
    conn.commit()  # Commit after inserting holds data
    print("Holds data inserted successfully.")
except Exception as e:
    print(f"Error inserting holds: {e}")
    conn.rollback()  # Rollback if there's an error

# Close the cursor and connection
cur.close()
conn.close()

print("Data berhasil dimasukkan ke database dan CSV.")
