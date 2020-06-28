-- Django MySQL database setup for application tier 

-- Create the database
CREATE DATABASE clus20_database CHARACTER SET utf8;

-- Create user
CREATE USER mysql IDENTIFIED BY 'mysql';

-- Grant ADMIN privileges to user
GRANT ALL PRIVILEGES ON mysql.* to 'mysql'@'%';
