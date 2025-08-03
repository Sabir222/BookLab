begin
;

INSERT INTO users (email, username, hashed_password, credits, loyalty_points, role) VALUES
('admin@example.com', 'admin', '$2b$10$hashedpassword1', 1000, 500, 'admin'),
('user@example.com', 'testuser', '$2b$10$hashedpassword2', 100, 50, 'user'),
('premium@example.com', 'premium', '$2b$10$hashedpassword3', 500, 200, 'moderator');

commit
;

