CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


create or replace function update_updated_at_column()
returns trigger
as $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$
language plpgsql
;

