--CREATE USER flex_app WITH ENCRYPTED PASSWORD 'flex_app123'
CREATE USER flex_app with password 'flex_app_#123';
CREATE SCHEMA IF NOT EXISTS flex_app authorization flex_app;
CREATE USER flex_admin with password 'flex_admin_#987';
CREATE SCHEMA IF NOT EXISTS flex_admin authorization flex_admin;
GRANT ALL ON database postgres to flex_admin;
GRANT ALL ON database postgres to flex_app;
