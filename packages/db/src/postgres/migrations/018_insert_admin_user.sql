-- Description: Insert initial admin user with nil UUID
begin
;

-- Insert admin user with the nil UUID
INSERT INTO users (
    user_id,
    username,
    email,
    hashed_password,
    profile_image_url,
    credits,
    loyalty_points,
    is_verified,
    role,
    last_login,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    'admin',
    'admin@yourapp.com',
    '$2a$10$xut/KtRSzMPWqtJzKtuW6OPEi/pZ0/kYViJv6viuQvi0RkMCYHHiS',
    NULL,
    1000000, -- Give admin plenty of credits
    0,
    TRUE, -- Admin is verified
    'admin', -- Assuming 'admin' is a valid role in your user_role enum
    NULL,
    NOW(),
    NOW()
);

-- Record this migration
INSERT INTO schema_migrations (version) VALUES ('018_insert_admin_user');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;
-- Remove admin user
DELETE FROM users WHERE user_id = '00000000-0000-0000-0000-000000000000';
-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '003_insert_admin_user';
COMMIT;
*/


