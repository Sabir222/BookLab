CREATE TABLE categories (
  category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_name VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  parent_category_id UUID,
  is_active BOOL DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

