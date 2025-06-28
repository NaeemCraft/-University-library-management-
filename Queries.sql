-- =====================================================================
-- Part 2: Basic SQL Operations
-- =====================================================================

--[cite_start]-- Task 2.1: Data Retrieval [cite: 3]

-- 1. List all books with their available copies where available copies are less than total copies
SELECT title, author, total_copies, available_copies
FROM BOOKS
WHERE available_copies < total_copies;

-- 2. Find members who have overdue books (due_date < SYSDATE and status = 'Issued' or status = 'Overdue')
SELECT m.member_id, m.first_name, m.last_name, m.email
FROM MEMBERS m
JOIN TRANSACTIONS t ON m.member_id = t.member_id
WHERE t.due_date < SYSDATE AND t.status IN ('Issued', 'Overdue');

-- 3. Display the top 5 most borrowed books with their borrow count
SELECT b.title, COUNT(t.book_id) AS borrow_count
FROM BOOKS b
JOIN TRANSACTIONS t ON b.book_id = t.book_id
GROUP BY b.title
ORDER BY borrow_count DESC
FETCH FIRST 5 ROWS ONLY;

-- 4. Show members who have never returned a book on time
SELECT member_id, first_name, last_name
FROM MEMBERS
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM TRANSACTIONS
    WHERE return_date <= due_date
);

--[cite_start]-- Task 2.2: Data Manipulation [cite: 4]

-- 1. Update fine amounts for all overdue transactions (25 per day after due date)
-- Note: Assuming a rate of 25 per day. The assignment specifies "25 per day" but the function part says "5 per day". Using 25 here as per this task's instruction.
UPDATE TRANSACTIONS
SET fine_amount = CEIL(SYSDATE - due_date) * 25
WHERE due_date < SYSDATE AND status IN ('Issued', 'Overdue') AND return_date IS NULL;

-- 2. Insert a new member with membership validation
-- The validation is handled by the CHECK constraint on the MEMBERSHIP_TYPE column
INSERT INTO MEMBERS (member_id, first_name, last_name, email, phone, address, membership_date, membership_type)
VALUES (216, 'Wally', 'West', 'wally.w@example.com', '666-777-8888', 'Central City', SYSDATE, 'Student');
-- This would fail due to the constraint:
-- INSERT INTO MEMBERS VALUES (217, 'Invalid', 'User', 'invalid.u@example.com', '111', 'Addr', SYSDATE, 'Visitor');

-- 3. Archive completed transactions older than 2 years to a separate table
CREATE TABLE ARCHIVED_TRANSACTIONS AS
SELECT * FROM TRANSACTIONS WHERE 1=0; -- Create empty table with same structure

INSERT INTO ARCHIVED_TRANSACTIONS
SELECT * FROM TRANSACTIONS
WHERE return_date IS NOT NULL AND return_date < ADD_MONTHS(SYSDATE, -24);

DELETE FROM TRANSACTIONS
WHERE return_date IS NOT NULL AND return_date < ADD_MONTHS(SYSDATE, -24);

-- 4. Update book categories based on publication year ranges
UPDATE BOOKS
SET category = 'Modern Fiction'
WHERE publication_year >= 1900 AND publication_year <= 2000 AND category = 'Fiction';

UPDATE BOOKS
SET category = 'Contemporary Fiction'
WHERE publication_year > 2000 AND category = 'Fiction';

UPDATE BOOKS
SET category = 'Classic Literature'
WHERE publication_year < 1900;


-- =====================================================================
-- Part 3: Advanced SQL Queries
-- =====================================================================

--[cite_start]-- Task 3.1: Joins [cite: 4, 5]

-- 1. Display transaction history with member details and book information for all overdue books using INNER JOIN
SELECT
    t.transaction_id,
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    b.title,
    b.author,
    t.issue_date,
    t.due_date,
    CEIL(SYSDATE - t.due_date) AS overdue_days
FROM TRANSACTIONS t
INNER JOIN MEMBERS m ON t.member_id = m.member_id
INNER JOIN BOOKS b ON t.book_id = b.book_id
WHERE t.due_date < SYSDATE AND t.status IN ('Issued', 'Overdue');

-- 2. Show all books and their transaction count (including books never borrowed) using LEFT JOIN
SELECT b.title, b.author, COUNT(t.transaction_id) AS transaction_count
FROM BOOKS b
LEFT JOIN TRANSACTIONS t ON b.book_id = t.book_id
GROUP BY b.title, b.author
ORDER BY transaction_count DESC;

-- 3. Find members who have borrowed books from the same category as other members using SELF JOIN
-- This query finds pairs of members who have borrowed books from the same category.
SELECT DISTINCT
    m1.first_name || ' ' || m1.last_name AS member1,
    m2.first_name || ' ' || m2.last_name AS member2,
    b.category
FROM TRANSACTIONS t1
JOIN TRANSACTIONS t2 ON t1.book_id = t2.book_id AND t1.member_id < t2.member_id
JOIN MEMBERS m1 ON t1.member_id = m1.member_id
JOIN MEMBERS m2 ON t2.member_id = m2.member_id
JOIN BOOKS b ON t1.book_id = b.book_id;

-- 4. List all possible member-book combinations for recommendation system using CROSS JOIN (limit to 50 results)
SELECT m.first_name || ' ' || m.last_name AS member_name, b.title AS recommended_book
FROM MEMBERS m
CROSS JOIN BOOKS b
FETCH FIRST 50 ROWS ONLY;

--[cite_start]-- Task 3.2: Subqueries [cite: 5]

-- 1. Find all books that have been borrowed more times than the average borrowing rate across all books
SELECT title, author, borrow_count
FROM (
    SELECT b.title, b.author, COUNT(t.transaction_id) as borrow_count
    FROM BOOKS b
    JOIN TRANSACTIONS t ON b.book_id = t.book_id
    GROUP BY b.title, b.author
)
WHERE borrow_count > (
    SELECT AVG(borrow_count)
    FROM (
        SELECT COUNT(transaction_id) as borrow_count
        FROM TRANSACTIONS
        GROUP BY book_id
    )
);

-- 2. List members whose total fine amount is greater than the average fine paid by their membership type
SELECT m.first_name, m.last_name, m.membership_type, total_fines
FROM (
    SELECT member_id, SUM(fine_amount) AS total_fines
    FROM TRANSACTIONS
    GROUP BY member_id
) member_fines
JOIN MEMBERS m ON member_fines.member_id = m.member_id
WHERE total_fines > (
    SELECT AVG(fine_amount)
    FROM TRANSACTIONS t
    JOIN MEMBERS m2 ON t.member_id = m2.member_id
    WHERE m2.membership_type = m.membership_type AND t.fine_amount > 0
);

-- 3. Display books that are currently available but belong to the same category as the most borrowed book
SELECT title, author, category
FROM BOOKS
WHERE available_copies > 0 AND category = (
    SELECT category
    FROM BOOKS
    WHERE book_id = (
        SELECT book_id
        FROM (
            SELECT book_id, COUNT(*) as borrow_count
            FROM TRANSACTIONS
            GROUP BY book_id
            ORDER BY borrow_count DESC
            FETCH FIRST 1 ROW ONLY
        )
    )
);

-- 4. Find the second most active member (by transaction count) using subqueries
SELECT first_name, last_name, transaction_count
FROM (
    SELECT m.first_name, m.last_name, COUNT(t.transaction_id) AS transaction_count,
           DENSE_RANK() OVER (ORDER BY COUNT(t.transaction_id) DESC) as rn
    FROM MEMBERS m
    JOIN TRANSACTIONS t ON m.member_id = t.member_id
    GROUP BY m.member_id, m.first_name, m.last_name
)
WHERE rn = 2;

--[cite_start]-- Task 3.3: Aggregate Functions & Window Functions [cite: 5, 6]

-- 1. Calculate running total of fines collected by month using window functions
SELECT
    TO_CHAR(return_date, 'YYYY-MM') AS month,
    SUM(fine_amount) AS monthly_fines,
    SUM(SUM(fine_amount)) OVER (ORDER BY TO_CHAR(return_date, 'YYYY-MM')) AS running_total_fines
FROM TRANSACTIONS
WHERE fine_amount > 0 AND return_date IS NOT NULL
GROUP BY TO_CHAR(return_date, 'YYYY-MM')
ORDER BY month;

-- 2. Rank members by their borrowing activity within each membership type
SELECT
    first_name,
    last_name,
    membership_type,
    borrow_count,
    RANK() OVER (PARTITION BY membership_type ORDER BY borrow_count DESC) AS rank_in_type
FROM (
    SELECT
        m.first_name,
        m.last_name,
        m.membership_type,
        COUNT(t.transaction_id) AS borrow_count
    FROM MEMBERS m
    JOIN TRANSACTIONS t ON m.member_id = t.member_id
    GROUP BY m.member_id, m.first_name, m.last_name, m.membership_type
);

-- 3. Find percentage contribution of each book category to total library transactions
SELECT
    b.category,
    COUNT(t.transaction_id) AS category_transactions,
    ROUND((COUNT(t.transaction_id) * 100.0) / (SELECT COUNT(*) FROM TRANSACTIONS), 2) AS percentage_contribution
FROM TRANSACTIONS t
JOIN BOOKS b ON t.book_id = b.book_id
GROUP BY b.category
ORDER BY percentage_contribution DESC;

-- 4. Display member borrowing trends with LAG function to show previous transaction date
SELECT
    m.first_name || ' ' || m.last_name AS member_name,
    b.title,
    t.issue_date,
    LAG(t.issue_date, 1, NULL) OVER (PARTITION BY t.member_id ORDER BY t.issue_date) AS previous_issue_date
FROM TRANSACTIONS t
JOIN MEMBERS m ON t.member_id = m.member_id
JOIN BOOKS b ON t.book_id = b.book_id
ORDER BY m.member_id, t.issue_date;
