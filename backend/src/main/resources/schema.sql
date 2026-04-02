
-- ==========================================
-- TẦNG 1: CÁC BẢNG ĐỘC LẬP (CHA)
-- ==========================================

CREATE TABLE accounts (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          username VARCHAR(50) UNIQUE NOT NULL,
                          password VARCHAR(255) NOT NULL,
                          role VARCHAR(20) NOT NULL, -- AccountStatus Enum
                          status VARCHAR(20) NOT NULL, -- AccountStatus Enum
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE authors (
                         id BIGINT PRIMARY KEY AUTO_INCREMENT,
                         name VARCHAR(100) NOT NULL,
                         description TEXT
);

CREATE TABLE publishers (
                            id BIGINT PRIMARY KEY AUTO_INCREMENT,
                            name VARCHAR(100) NOT NULL,
                            description TEXT
);

CREATE TABLE categories (
                            id BIGINT PRIMARY KEY AUTO_INCREMENT,
                            name VARCHAR(100) NOT NULL,
                            description TEXT
);

-- ==========================================
-- TẦNG 2: PHỤ THUỘC CẤP 1
-- ==========================================

CREATE TABLE readers (
                         id BIGINT PRIMARY KEY AUTO_INCREMENT,
                         full_name VARCHAR(100) NOT NULL,
                         email VARCHAR(100) UNIQUE,
                         phone_number VARCHAR(20),
                         address VARCHAR(255),
                         gender VARCHAR(10),
                         date_of_birth DATE,
                         account_id BIGINT UNIQUE,
                         CONSTRAINT fk_reader_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL
);

CREATE TABLE books (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       title VARCHAR(255) NOT NULL,
                       isbn VARCHAR(20) UNIQUE,
                       publish_year INT,
                       status VARCHAR(20), -- BookStatus Enum
                       author_id BIGINT,
                       publisher_id BIGINT,
                       CONSTRAINT fk_book_author FOREIGN KEY (author_id) REFERENCES authors(id),
                       CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

-- ==========================================
-- TẦNG 3: PHỤ THUỘC CẤP 2 (BẢNG TRUNG GIAN & CHI TIẾT)
-- ==========================================

-- Bảng trung gian Nhiều-Nhiều giữa Book và Category
CREATE TABLE categories_books (
                                  category_id BIGINT,
                                  book_id BIGINT,
                                  PRIMARY KEY (category_id, book_id),
                                  CONSTRAINT fk_cb_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
                                  CONSTRAINT fk_cb_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

CREATE TABLE library_cards (
                               id BIGINT PRIMARY KEY AUTO_INCREMENT,
                               card_code VARCHAR(20) UNIQUE NOT NULL,
                               issue_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                               expiry_date DATETIME NOT NULL,
                               status VARCHAR(20), -- CardStatus Enum
                               reader_id BIGINT UNIQUE,
                               CONSTRAINT fk_card_reader FOREIGN KEY (reader_id) REFERENCES readers(id) ON DELETE CASCADE
);

CREATE TABLE editions (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          barcode VARCHAR(50) UNIQUE NOT NULL,
                          location VARCHAR(100),
                          status VARCHAR(20), -- EditionStatus Enum
                          book_id BIGINT,
                          CONSTRAINT fk_edition_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- ==========================================
-- TẦNG 4: GIAO DỊCH (TRANSACTIONS)
-- ==========================================

CREATE TABLE loan_slips (
                            id BIGINT PRIMARY KEY AUTO_INCREMENT,
                            borrow_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                            due_date DATETIME NOT NULL,
                            return_date DATETIME,
                            status VARCHAR(20), -- LoanStatus Enum
                            card_id BIGINT,
                            CONSTRAINT fk_loan_card FOREIGN KEY (card_id) REFERENCES library_cards(id)
);

-- Cập nhật bảng editions để liên kết với LoanSlip (N-1)
-- Theo sơ đồ, một Edition tại một thời điểm thuộc về một LoanSlip
ALTER TABLE editions ADD COLUMN loan_slip_id BIGINT;
ALTER TABLE editions ADD CONSTRAINT fk_edition_loan FOREIGN KEY (loan_slip_id) REFERENCES loan_slips(id);

-- ==========================================
-- TẦNG 5: PHỤ THUỘC GIAO DỊCH
-- ==========================================

CREATE TABLE renewals (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                          new_date DATETIME NOT NULL,
                          status VARCHAR(20), -- RenewalStatus Enum
                          loan_slip_id BIGINT,
                          CONSTRAINT fk_renewal_loan FOREIGN KEY (loan_slip_id) REFERENCES loan_slips(id) ON DELETE CASCADE
);

CREATE TABLE payments (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          transaction_code VARCHAR(100) UNIQUE,
                          payment_status VARCHAR(20), -- PaymentStatus Enum
                          amount DECIMAL(15, 2) NOT NULL,
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fines (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       amount DECIMAL(15, 2) NOT NULL,
                       reason TEXT,
                       status VARCHAR(20), -- FineStatus Enum
                       loan_slip_id BIGINT,
                       payment_id BIGINT, -- Theo quan hệ 1 Payment - Nhiều Fine
                       CONSTRAINT fk_fine_loan FOREIGN KEY (loan_slip_id) REFERENCES loan_slips(id),
                       CONSTRAINT fk_fine_payment FOREIGN KEY (payment_id) REFERENCES payments(id)
);