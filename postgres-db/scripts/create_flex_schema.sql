--CREATE USER flex_app WITH ENCRYPTED PASSWORD 'flex_app123'
create user flex_app with password 'flex_app_#123';
CREATE SCHEMA IF NOT EXISTS flex_app authorization flex_app;
create user flex_admin with password 'flex_admin_#987';
CREATE SCHEMA IF NOT EXISTS flex_admin authorization flex_admin;
grant all on database postgres to flex_admin;
grant all on database postgres to flex_app;
