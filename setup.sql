-- =====================================================================
-- Part 1: Database Design & Setup
-- Task 1.1: Database Schema Design
-- =====================================================================

-- Drop tables if they exist to ensure a clean setup
DROP TABLE TRANSACTIONS;
DROP TABLE MEMBERS;
DROP TABLE BOOKS;

-- Create BOOKS Table
CREATE TABLE BOOKS (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    author VARCHAR2(255) NOT NULL,
    publisher VARCHAR2(100),
    publication_year NUMBER(4),
    isbn VARCHAR2(20) UNIQUE NOT NULL,
    category VARCHAR2(50),
    total_copies NUMBER DEFAULT 1 NOT NULL,
    available_copies NUMBER DEFAULT 1 NOT NULL,
    price NUMBER(8, 2),
    CONSTRAINT chk_available_copies CHECK (available_copies <= total_copies)
[cite_start]); [cite: 2]

-- Create MEMBERS Table
CREATE TABLE MEMBERS (
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(255),
    membership_date DATE DEFAULT SYSDATE,
    membership_type VARCHAR2(10) NOT NULL,
    CONSTRAINT chk_membership_type CHECK (membership_type IN ('Student', 'Faculty', 'Staff'))
[cite_start]); [cite: 2, 3]

-- Create TRANSACTIONS Table
CREATE TABLE TRANSACTIONS (
    transaction_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount NUMBER(8, 2) DEFAULT 0,
    status VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_book_id FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
    CONSTRAINT fk_member_id FOREIGN KEY (member_id) REFERENCES MEMBERS(member_id),
    CONSTRAINT chk_status CHECK (status IN ('Issued', 'Returned', 'Overdue'))
[cite_start]); [cite: 3]

-- =====================================================================
-- Task 1.2: Create Sample Data
-- =====================================================================

-- Insert 20 Books
INSERT INTO BOOKS VALUES (101, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 1925, '978-0743273565', 'Fiction', 5, 3, 15.99);
INSERT INTO BOOKS VALUES (102, '1984', 'George Orwell', 'Secker & Warburg', 1949, '978-0451524935', 'Dystopian', 7, 7, 12.50);
INSERT INTO BOOKS VALUES (103, 'To Kill a Mockingbird', 'Harper Lee', 'J. B. Lippincott & Co.', 1960, '978-0061120084', 'Fiction', 4, 1, 14.00);
INSERT INTO BOOKS VALUES (104, 'The Catcher in the Rye', 'J. D. Salinger', 'Little, Brown', 1951, '978-0316769488', 'Fiction', 3, 3, 11.25);
INSERT INTO BOOKS VALUES (105, 'Pride and Prejudice', 'Jane Austen', 'T. Egerton', 1813, '978-1503290563', 'Romance', 6, 4, 9.99);
INSERT INTO BOOKS VALUES (106, 'A Brief History of Time', 'Stephen Hawking', 'Bantam Dell', 1988, '978-0553380163', 'Science', 8, 5, 22.00);
INSERT INTO BOOKS VALUES (107, 'The Hobbit', 'J.R.R. Tolkien', 'Allen & Unwin', 1937, '978-0345339683', 'Fantasy', 10, 8, 18.50);
INSERT INTO BOOKS VALUES (108, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 'Dvir Publishing House', 2011, '978-0062316097', 'History', 9, 6, 25.00);
INSERT INTO BOOKS VALUES (109, 'The Da Vinci Code', 'Dan Brown', 'Doubleday', 2003, '978-0385504201', 'Thriller', 12, 10, 16.75);
INSERT INTO BOOKS VALUES (110, 'Thinking, Fast and Slow', 'Daniel Kahneman', 'Farrar, Straus and Giroux', 2011, '978-0374533557', 'Psychology', 7, 7, 19.99);
INSERT INTO BOOKS VALUES (111, 'Cosmos', 'Carl Sagan', 'Random House', 1980, '978-0345539434', 'Science', 5, 2, 24.50);
INSERT INTO BOOKS VALUES (112, 'Dune', 'Frank Herbert', 'Chilton Books', 1965, '978-0441013593', 'Sci-Fi', 8, 8, 17.00);
INSERT INTO BOOKS VALUES (113, 'Moby Dick', 'Herman Melville', 'Richard Bentley', 1851, '978-1503280786', 'Adventure', 4, 1, 13.50);
INSERT INTO BOOKS VALUES (114, 'War and Peace', 'Leo Tolstoy', 'The Russian Messenger', 1869, '978-1420952138', 'Historical Fiction', 3, 3, 21.00);
INSERT INTO BOOKS VALUES (115, 'The Lord of the Rings', 'J.R.R. Tolkien', 'Allen & Unwin', 1954, '978-0618640157', 'Fantasy', 9, 9, 29.99);
INSERT INTO BOOKS VALUES (116, 'Database System Concepts', 'Silberschatz, Korth', 'McGraw-Hill', 2019, '978-0078022159', 'Technology', 15, 12, 85.00);
INSERT INTO BOOKS VALUES (117, 'Introduction to Algorithms', 'Cormen, Leiserson', 'MIT Press', 2009, '978-0262033848', 'Technology', 11, 11, 95.50);
INSERT INTO BOOKS VALUES (118, 'The Art of Computer Programming', 'Donald Knuth', 'Addison-Wesley', 1968, '978-0201896831', 'Technology', 6, 5, 120.00);
INSERT INTO BOOKS VALUES (119, 'Frankenstein', 'Mary Shelley', 'Lackington, Hughes', 1818, '978-0486282114', 'Gothic Fiction', 5, 0, 8.99);
INSERT INTO BOOKS VALUES (120, 'The Odyssey', 'Homer', 'N/A', -800, '978-0140268867', 'Epic Poetry', 7, 7, 10.50);

-- Insert 15 Members
INSERT INTO MEMBERS VALUES (201, 'Alice', 'Smith', 'alice.s@example.com', '123-456-7890', '123 Maple St', TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (202, 'Bob', 'Johnson', 'bob.j@example.com', '123-456-7891', '456 Oak Ave', TO_DATE('2021-09-01', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (203, 'Charlie', 'Brown', 'charlie.b@example.com', '123-456-7892', '789 Pine Ln', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Faculty');
INSERT INTO MEMBERS VALUES (204, 'Diana', 'Prince', 'diana.p@example.com', '123-456-7893', '101 Power Ct', TO_DATE('2020-05-10', 'YYYY-MM-DD'), 'Staff');
INSERT INTO MEMBERS VALUES (205, 'Ethan', 'Hunt', 'ethan.h@example.com', '123-456-7894', '202 Mission Rd', TO_DATE('2022-08-11', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (206, 'Fiona', 'Glenanne', 'fiona.g@example.com', '123-456-7895', '303 Spy St', TO_DATE('2021-11-25', 'YYYY-MM-DD'), 'Faculty');
INSERT INTO MEMBERS VALUES (207, 'George', 'Costanza', 'george.c@example.com', '123-456-7896', '404 Vandelay Dr', TO_DATE('2023-03-30', 'YYYY-MM-DD'), 'Staff');
INSERT INTO MEMBERS VALUES (208, 'Hannah', 'Montana', 'hannah.m@example.com', '123-456-7897', '505 Popstar Ave', TO_DATE('2022-04-18', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (209, 'Ian', 'Malcolm', 'ian.m@example.com', '123-456-7898', '606 Chaos Blvd', TO_DATE('2021-06-07', 'YYYY-MM-DD'), 'Faculty');
INSERT INTO MEMBERS VALUES (210, 'Jane', 'Eyre', 'jane.e@example.com', '123-456-7899', '707 Thornfield Rd', TO_DATE('2023-01-05', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (211, 'Clark', 'Kent', 'clark.k@example.com', '111-222-3333', 'Planet St', TO_DATE('2020-02-29', 'YYYY-MM-DD'), 'Staff');
INSERT INTO MEMBERS VALUES (212, 'Bruce', 'Wayne', 'bruce.w@example.com', '222-333-4444', 'Gotham Manor', TO_DATE('2021-07-19', 'YYYY-MM-DD'), 'Faculty');
INSERT INTO MEMBERS VALUES (213, 'Peter', 'Parker', 'peter.p@example.com', '333-444-5555', 'Queens Ave', TO_DATE('2022-10-01', 'YYYY-MM-DD'), 'Student');
INSERT INTO MEMBERS VALUES (214, 'Tony', 'Stark', 'tony.s@example.com', '444-555-6666', 'Stark Tower', TO_DATE('2020-11-12', 'YYYY-MM-DD'), 'Faculty');
INSERT INTO MEMBERS VALUES (215, 'Steve', 'Rogers', 'steve.r@example.com', '555-666-7777', 'Brooklyn Hts', TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Student');


-- Insert 25 Transactions
-- Returned on time
INSERT INTO TRANSACTIONS VALUES (301, 101, 201, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-02-14', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (302, 107, 202, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (303, 116, 203, TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (304, 109, 204, TO_DATE('2024-01-20', 'YYYY-MM-DD'), TO_DATE('2024-02-19', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (305, 105, 205, TO_DATE('2024-05-01', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (306, 111, 206, TO_DATE('2023-11-10', 'YYYY-MM-DD'), TO_DATE('2023-12-10', 'YYYY-MM-DD'), TO_DATE('2023-12-05', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (307, 108, 209, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (308, 117, 212, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (309, 102, 213, TO_DATE('2024-04-10', 'YYYY-MM-DD'), TO_DATE('2024-04-24', 'YYYY-MM-DD'), TO_DATE('2024-04-22', 'YYYY-MM-DD'), 0, 'Returned');

-- Returned late (with fine)
INSERT INTO TRANSACTIONS VALUES (310, 103, 201, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 25, 'Returned'); -- 5 days late
INSERT INTO TRANSACTIONS VALUES (311, 106, 204, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-30', 'YYYY-MM-DD'), TO_DATE('2024-05-10', 'YYYY-MM-DD'), 50, 'Returned'); -- 10 days late
INSERT INTO TRANSACTIONS VALUES (312, 113, 207, TO_DATE('2024-05-01', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), 50, 'Returned'); -- 10 days late
INSERT INTO TRANSACTIONS VALUES (313, 118, 214, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-02-20', 'YYYY-MM-DD'), 50, 'Returned'); -- 10 days late

-- Currently Issued (Pending)
INSERT INTO TRANSACTIONS VALUES (314, 101, 205, SYSDATE - 10, SYSDATE + 4, NULL, 0, 'Issued');
INSERT INTO TRANSACTIONS VALUES (315, 105, 206, SYSDATE - 5, SYSDATE + 25, NULL, 0, 'Issued');
INSERT INTO TRANSACTIONS VALUES (316, 108, 208, SYSDATE - 2, SYSDATE + 12, NULL, 0, 'Issued');
INSERT INTO TRANSACTIONS VALUES (317, 109, 210, SYSDATE - 20, SYSDATE + 10, NULL, 0, 'Issued');
INSERT INTO TRANSACTIONS VALUES (318, 116, 211, SYSDATE - 8, SYSDATE + 22, NULL, 0, 'Issued');

-- Overdue
INSERT INTO TRANSACTIONS VALUES (319, 103, 202, SYSDATE - 40, SYSDATE - 10, NULL, 0, 'Issued'); -- Set to Issued, query will find it as overdue
INSERT INTO TRANSACTIONS VALUES (320, 111, 203, SYSDATE - 50, SYSDATE - 20, NULL, 0, 'Issued');
INSERT INTO TRANSACTIONS VALUES (321, 101, 207, SYSDATE - 25, SYSDATE - 5, NULL, 0, 'Overdue');
INSERT INTO TRANSACTIONS VALUES (322, 106, 209, SYSDATE - 35, SYSDATE - 15, NULL, 0, 'Overdue');
INSERT INTO TRANSACTIONS VALUES (323, 113, 215, SYSDATE - 20, SYSDATE - 2, NULL, 0, 'Overdue');

-- Additional transactions for borrow counts
INSERT INTO TRANSACTIONS VALUES (324, 101, 212, TO_DATE('2023-10-01', 'YYYY-MM-DD'), TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_DATE('2023-10-14', 'YYYY-MM-DD'), 0, 'Returned');
INSERT INTO TRANSACTIONS VALUES (325, 103, 213, TO_DATE('2023-11-01', 'YYYY-MM-DD'), TO_DATE('2023-11-15', 'YYYY-MM-DD'), TO_DATE('2023-11-14', 'YYYY-MM-DD'), 0, 'Returned');


COMMIT;
