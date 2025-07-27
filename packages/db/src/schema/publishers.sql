CREATE TABLE publishers (
  publisher_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  publisher_name varchar(255) UNIQUE NOT NULL,
  description TEXT,
  founded_year INT,
  country varchar(100),
  website_url TEXT,
  is_active BOOL DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON publishers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

