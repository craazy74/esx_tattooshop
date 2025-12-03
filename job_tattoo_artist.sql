-- Tattoo Artist Job Setup SQL
-- Run this SQL in your ESX database to create the tattoo_artist job

-- Insert job
INSERT INTO `jobs` (name, label) VALUES
('tattoo_artist', 'Tattoo Studio')
ON DUPLICATE KEY UPDATE label = VALUES(label);

-- Insert job grades
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
('tattoo_artist', 0, 'apprentice', 'Lehrling', 200, '{}', '{}'),
('tattoo_artist', 1, 'artist', 'Tätowierer', 400, '{}', '{}'),
('tattoo_artist', 2, 'master', 'Meister', 600, '{}', '{}'),
('tattoo_artist', 3, 'boss', 'Chef', 800, '{}', '{}')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    label = VALUES(label),
    salary = VALUES(salary);

-- Verify installation
SELECT 'Job created successfully!' AS Status;
SELECT * FROM jobs WHERE name = 'tattoo_artist';
SELECT * FROM job_grades WHERE job_name = 'tattoo_artist' ORDER BY grade;
