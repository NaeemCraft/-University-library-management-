-- =====================================================================
-- Part 5: Database Administration
-- =====================================================================

--[cite_start]-- Task 5.1: User Management [cite: 9]
-- Note: These commands should be run by a user with administrative privileges (e.g., SYSTEM or SYS).

-- 1. Create two users: librarian and student_user
CREATE USER librarian IDENTIFIED BY YourSecurePassword1;
CREATE USER student_user IDENTIFIED BY AnotherSecurePassword1;

-- 2. Grant appropriate privileges
-- Grant privileges to Librarian (Full access to all tables created by the main user)
-- Assuming the tables were created by a user named 'DB_OWNER'. Replace with the actual schema name if different.
GRANT ALL PRIVILEGES ON BOOKS TO librarian;
GRANT ALL PRIVILEGES ON MEMBERS TO librarian;
GRANT ALL PRIVILEGES ON TRANSACTIONS TO librarian;
GRANT CREATE SESSION TO librarian;

-- Grant privileges to Student (SELECT only on BOOKS table)
GRANT SELECT ON BOOKS TO student_user;
GRANT CREATE SESSION TO student_user;


--[cite_start]-- Task 5.2: Performance Optimization [cite: 9]

-- 1. Create indexes on frequently queried columns
-- Foreign keys in TRANSACTIONS table are good candidates as they are used in joins.
CREATE INDEX idx_trans_book_id ON TRANSACTIONS(book_id);
CREATE INDEX idx_trans_member_id ON TRANSACTIONS(member_id);

-- Columns used in WHERE clauses frequently are also good candidates.
CREATE INDEX idx_books_author ON BOOKS(author);
CREATE INDEX idx_books_category ON BOOKS(category);
CREATE INDEX idx_trans_status ON TRANSACTIONS(status);
CREATE INDEX idx_trans_due_date ON TRANSACTIONS(due_date);

-- 2. Write a query to show execution plan for finding books by author
EXPLAIN PLAN FOR
SELECT * FROM BOOKS WHERE author = 'J.R.R. Tolkien';

-- Display the plan
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

