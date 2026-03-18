-- ============================================
-- NOTES SHARING APP - COMPLETE DATABASE SCHEMA
-- ============================================
-- Run this in MySQL Workbench to create all tables
-- ============================================

-- Use the database
USE notesharingapp_python;

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE KEY,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. CATEGORIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE KEY,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. NOTES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content LONGTEXT NOT NULL,
    user_id INT NOT NULL,
    category_id INT,
    is_public BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_category_id (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. NOTE FILES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS note_files (
    id INT PRIMARY KEY AUTO_INCREMENT,
    note_id INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    file_size INT,
    file_path VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    INDEX idx_note_id (note_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. FAVORITES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    note_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_note (user_id, note_id),
    INDEX idx_user_id (user_id),
    INDEX idx_note_id (note_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 6. TWO FACTOR CODES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS two_factor_codes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    code VARCHAR(6) NOT NULL,
    code_type VARCHAR(50) DEFAULT 'login',
    expires_at DATETIME NOT NULL,
    attempts_used INT DEFAULT 0,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 7. REMEMBER TOKENS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS remember_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE KEY,
    expires_at DATETIME NOT NULL,
    device_info VARCHAR(255),
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Insert Admin User
INSERT INTO users (full_name, email, password, is_active) 
VALUES (
    'Admin User',
    'admin12@gmail.com',
    '$2b$12$R9h/cIPz0gi.URNNGU3X.OPST9/PgBkqquzi.Ss7KIUgO2t0jKMm2',
    TRUE
) ON DUPLICATE KEY UPDATE email=email;

-- Insert Test User
INSERT INTO users (full_name, email, password, is_active) 
VALUES (
    'Test User',
    'testuser@gmail.com',
    '$2b$12$R9h/cIPz0gi.URNNGU3X.OPST9/PgBkqquzi.Ss7KIUgO2t0jKMm2',
    TRUE
) ON DUPLICATE KEY UPDATE email=email;

-- Insert Categories
INSERT INTO categories (name, description) VALUES
('Technology', 'Tech-related notes'),
('Personal', 'Personal notes'),
('Business', 'Business notes'),
('Education', 'Educational notes'),
('Other', 'Miscellaneous notes')
ON DUPLICATE KEY UPDATE name=name;

-- ============================================
-- VERIFY TABLES CREATED
-- ============================================
SHOW TABLES;

-- ============================================
-- COUNT RECORDS
-- ============================================
SELECT 
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM categories) as total_categories,
    (SELECT COUNT(*) FROM notes) as total_notes,
    (SELECT COUNT(*) FROM favorites) as total_favorites,
    (SELECT COUNT(*) FROM two_factor_codes) as total_2fa_codes,
    (SELECT COUNT(*) FROM remember_tokens) as total_tokens,
    (SELECT COUNT(*) FROM note_files) as total_files;
