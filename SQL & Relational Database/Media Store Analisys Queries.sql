-- 1 Determine which countries have the most number of invoices (top 10)
SELECT 
	"BillingCountry", 
	COUNT("InvoiceId") AS number_of_invoice
FROM "Invoice"
GROUP BY "BillingCountry"
ORDER BY COUNT("InvoiceId") DESC, "BillingCountry" ASC
LIMIT 10;

-- 2 The top 10 genres by total sales
SELECT
	a."Name" AS genre_name,
	SUM(c."UnitPrice" * c."Quantity") AS total_sales
FROM "Genre" a
INNER JOIN "Track" b ON a."GenreId" = b."GenreId"
INNER JOIN "InvoiceLine" c ON c."TrackId" = b."TrackId"
GROUP BY a."Name"
ORDER BY total_sales DESC, genre_name ASC
LIMIT 10;

-- 3 Top 10 customers by total spending
SELECT 
	CONCAT(a."FirstName",' ', a."LastName") AS customer_name,
	a."Email",
	SUM(b."Total") AS total_spending
FROM "Customer" a 
LEFT JOIN "Invoice" b ON a."CustomerId" = b."CustomerId"
GROUP BY customer_name, "Email" 
ORDER BY total_spending DESC,  customer_name DESC
LIMIT 10;

-- 4 Determine city has the most number of invoices
SELECT
	"BillingCountry" AS country_name,
	"BillingCity" AS city_name,
	COUNT("InvoiceId") AS total_number_of_invoice
FROM "Invoice"
WHERE "BillingCountry" IN(
	SELECT 
		"BillingCountry"
	FROM "Invoice"
	GROUP BY "BillingCountry"
	ORDER BY COUNT("InvoiceId") DESC, "BillingCountry" ASC
	LIMIT 10
)
GROUP BY "BillingCountry", "BillingCity"
ORDER BY total_number_of_invoice DESC
LIMIT 10

-- 5 Select songs for the United Kingdom market
SELECT
	a."Name" AS genre_name,
	SUM(c."Quantity") AS number_of_purchase,
	CASE
		WHEN a."Name" = 'R&B/Soul' THEN 'Lalaland' 
		WHEN a."Name" = 'Pop' THEN 'Soul Sister'
		WHEN a."Name" = 'Rock' THEN 'Good to See You'
		WHEN a."Name" = 'Jazz' THEN 'Nothing On You'
		WHEN a."Name" = 'Reggae' THEN 'Get Ya Before Sunrise'
		WHEN a."Name" = 'Hip Hop/Rap' THEN 'Before The Coffee Gets Cold'
	END AS songs
FROM "Genre" a
INNER JOIN "Track" b ON a."GenreId" = b."GenreId"
INNER JOIN "InvoiceLine" c ON c."TrackId" = b."TrackId"
INNER JOIN "Invoice" d ON d."InvoiceId" = c."InvoiceId" 
WHERE d."BillingCountry" = 'United Kingdom'
GROUP BY a."Name"
ORDER BY number_of_purchase DESC;

-- Songs recommendation
WITH 
data AS (
    SELECT
        a."Name" AS genre_name,
        SUM(c."Quantity") AS number_of_purchase,
        CASE
        WHEN a."Name" = 'R&B/Soul' THEN 'Lalaland' 
        WHEN a."Name" = 'Pop' THEN 'Soul Sister'
        WHEN a."Name" = 'Rock' THEN 'Good to See You'
        WHEN a."Name" = 'Jazz' THEN 'Nothing On You'
        WHEN a."Name" = 'Reggae' THEN 'Get Ya Before Sunrise'
        WHEN a."Name" = 'Hip Hop/Rap' THEN 'Before The Coffee Gets Cold'
        END AS songs
    FROM "Genre" a
    INNER JOIN "Track" b ON a."GenreId" = b."GenreId"
    INNER JOIN "InvoiceLine" c ON c."TrackId" = b."TrackId"
    INNER JOIN "Invoice" d ON d."InvoiceId" = c."InvoiceId" 
    WHERE d."BillingCountry" = 'United Kingdom'
    GROUP BY a."Name"
    ORDER BY number_of_purchase desc
), 
fin AS(
    SELECT 
        *, 
        ROW_NUMBER() OVER(ORDER BY number_of_purchase DESC) AS row_number
    FROM data
    WHERE songs IS NOT NULL
)
SELECT 
    *, 
    CASE 
        WHEN row_number BETWEEN 1 AND 4 THEN TRUE 
        ELSE FALSE 
    END AS is_recommended
FROM fin

-- 6 Top 10 most popular albums in the USA
SELECT
	a."Title",
	SUM(c."Quantity") AS album_units_sold
FROM "Album" a 
INNER JOIN "Track" b on a."AlbumId" = b."AlbumId" 
INNER JOIN "InvoiceLine" c ON c."TrackId" = b."TrackId"
INNER JOIN "Invoice" d ON d."InvoiceId" = c."InvoiceId" 
WHERE d."BillingCountry" = 'USA'
GROUP BY a."Title"
ORDER BY album_units_sold desc, "Title" ASC
LIMIT 10;

-- 7 Aggregate purchase data by country
-- SubQuery version
SELECT
	BillingCountry,
	SUM(total_number_of_customer) AS total_number_of_customer,
	SUM(Total) AS total_value_of_sales,
	ROUND(SUM(Total) / SUM(CustomerId),3) AS  avg_value_of_sales_per_customer,
	AVG(SUM(Total) / SUM(InvoiceId)) OVER(PARTITION BY BillingCountry) AS avg_order_value
FROM
	(
	SELECT
		COUNT(DISTINCT "CustomerId") AS CustomerId,
		CASE 
			WHEN count(DISTINCT "CustomerId") = 1 THEN 'Other'
			ELSE "BillingCountry"
		END AS BillingCountry ,
		COUNT(DISTINCT "CustomerId") AS total_number_of_customer,
		SUM("Total") AS Total,
		COUNT("InvoiceId") InvoiceId
	FROM "Invoice"
	GROUP BY "BillingCountry"
	)
GROUP BY BillingCountry
ORDER BY total_value_of_sales DESC 
LIMIT 10;

-- CTE version
WITH summary AS (
    SELECT 
        COUNT(DISTINCT "CustomerId") AS CustomerId,
        CASE 
            WHEN COUNT(DISTINCT "CustomerId") = 1 THEN 'Other' 
            ELSE "BillingCountry" 
        END AS BillingCountry,
        COUNT(DISTINCT "CustomerId") AS total_number_of_customer,
        SUM("Total") AS Total,
        COUNT("InvoiceId") AS InvoiceId
    FROM "Invoice"
    GROUP BY "BillingCountry"
)
SELECT 
    BillingCountry,
    SUM(total_number_of_customer) AS total_number_of_customer,
    SUM(Total) AS total_value_of_sales,
    ROUND(SUM(Total) / SUM(CustomerId), 3) AS avg_value_of_sales_per_customer,
    AVG(SUM(Total) / SUM(InvoiceId)) OVER (PARTITION BY BillingCountry) AS avg_order_value
FROM summary
GROUP BY BillingCountry
ORDER BY total_value_of_sales DESC 
LIMIT 10;

-- 8 Genres with low sales in the USA
SELECT
    a."Name" AS genre_name,
    SUM(c."Quantity" * c."UnitPrice") AS total_sales,
    case when SUM(c."Quantity" * c."UnitPrice") < 6 then true end as add_promotion
FROM "Genre" a
INNER JOIN "Track" b ON a."GenreId" = b."GenreId"
INNER JOIN "InvoiceLine" c ON c."TrackId" = b."TrackId"
INNER JOIN "Invoice" d ON d."InvoiceId" = c."InvoiceId" 
WHERE d."BillingCountry" = 'USA'
GROUP BY a."Name"
ORDER BY total_sales ASC, genre_name ASC



-- 9 Top genre for each customer based on their spending
WITH data AS (
    SELECT
        b."CustomerId",
        CONCAT(c."FirstName", ' ', c."LastName") AS customer_name,
        e."Name" AS genre,
        SUM(a."Quantity" * a."UnitPrice") AS total_spent,
        RANK() OVER(PARTITION BY b."CustomerId" ORDER BY SUM(a."Quantity" * a."UnitPrice") DESC) AS rank
    FROM "InvoiceLine" a
    JOIN "Invoice" b ON a."InvoiceId" = b."InvoiceId" 
    JOIN "Customer" c ON b."CustomerId" = c."CustomerId" 
    JOIN "Track" d ON a."TrackId" = d."TrackId" 
    JOIN "Genre" e ON d."GenreId" = e."GenreId"
    GROUP BY b."CustomerId", customer_name, genre
    ORDER BY b."CustomerId"
)
SELECT * FROM data
WHERE rank = 1;

-- 10 Top 10 countries with the highest-spending customers
SELECT
	"BillingCountry",
	SUM("Total") AS TotalSpending
FROM "Invoice"
GROUP BY "BillingCountry" 
ORDER BY TotalSpending DESC
LIMIT 10