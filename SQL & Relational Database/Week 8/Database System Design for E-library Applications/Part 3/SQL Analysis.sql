--1. Is there any library that is lacking or has an excess of books compared to the ideal number of books?
--libraries are understocked
SELECT 
    i.library_id,
    l."name" AS library_name,
    SUM(quantity) AS total_books,
    AVG(SUM(quantity)) OVER () AS ideal_books
FROM inventory i
JOIN libraries l ON i.library_id = l.library_id 
GROUP BY i.library_id, l."name"
ORDER BY total_books ASC
LIMIT 10;

--libraries are excess of books
SELECT 
    i.library_id,
    l."name" AS library_name,
    SUM(quantity) AS total_books,
    AVG(SUM(quantity)) OVER () AS ideal_books
FROM inventory i
JOIN libraries l ON i.library_id = l.library_id 
GROUP BY i.library_id, l."name"
ORDER BY total_books DESC
LIMIT 10;


--2. What is the most frequently borrowed genre by each user in the past ten months (January to October), 
--and how many books did they borrow from that genre?
WITH UserGenreRank AS (
    SELECT 
        l.user_id,
        c.name AS genre,
        COUNT(l.book_id) AS genre_borrow_count,
        ROW_NUMBER() OVER (PARTITION BY l.user_id ORDER BY COUNT(l.book_id) DESC) AS rank
    FROM loans l
    JOIN books b ON l.book_id = b.book_id
    JOIN categories c ON b.category_id = c.category_id
    WHERE l.loan_date BETWEEN '2024-01-01' AND '2024-10-31'  -- Period from August to October
    GROUP BY l.user_id, c.name
)
SELECT user_id, genre, genre_borrow_count
FROM UserGenreRank
WHERE rank = 1  -- Select the most borrowed genre per user
ORDER BY user_id;

--3. What is the average book loan duration?
SELECT 
    ROUND(AVG(l.due_date - l.loan_date)) AS average_loan_duration
FROM loans l;

--4.What is the correlation between the number of holds and the number of loans per book?
SELECT 
    b.title AS book_title,
    COUNT(DISTINCT h.user_id) AS total_holds,
    COUNT(DISTINCT l.user_id) AS total_loans
FROM books b
LEFT JOIN holds h ON b.book_id = h.book_id
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id
ORDER BY total_holds DESC, total_loans DESC;

--5.What is the user retention rate based on the frequency of book loans?
WITH user_loans AS (
    SELECT user_id, COUNT(*) AS total_loans
    FROM loans
    GROUP BY user_id
)
SELECT 
    CASE 
        WHEN total_loans > 10 THEN 'Highly Engaged'
        WHEN total_loans BETWEEN 5 AND 10 THEN 'Moderately Engaged'
        ELSE 'Low Engagement'
    END AS engagement_level,
    COUNT(user_id) AS num_users
FROM user_loans
GROUP BY engagement_level
ORDER BY num_users DESC;
