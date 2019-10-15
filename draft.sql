DROP DATABASE IF EXISTS airline;
CREATE DATABASE airline;
USE airline;

DROP TABLE IF EXISTS login;
DROP TABLE IF EXISTS user;

CREATE TABLE login(email varchar(50) primary key, password varchar(30));
CREATE TABLE user(email varchar(50) primary key, name varchar(30), age int, gender char(1));

ALTER TABLE user ADD CONSTRAINT FOREIGN KEY(email) REFERENCES login(email);