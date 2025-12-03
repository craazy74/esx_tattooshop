-- Tattoo System Database Schema
-- Created by ELBaron
-- Run this SQL in your ESX database

-- Create user_tattoos table
CREATE TABLE IF NOT EXISTS `user_tattoos` (
    `identifier` VARCHAR(60) NOT NULL,
    `tattoos` LONGTEXT NULL DEFAULT NULL,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verify installation
SELECT 'user_tattoos table created successfully!' AS Status;
SHOW TABLES LIKE 'user_tattoos';
