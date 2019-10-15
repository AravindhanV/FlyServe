DROP DATABASE IF EXISTS airline;
CREATE DATABASE airline;
USE airline;

DROP TABLE IF EXISTS login;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS costs;
DROP TABLE IF EXISTS bookings;

CREATE TABLE login(email varchar(50) primary key, password varchar(30));
CREATE TABLE user(email varchar(50) primary key, name varchar(30), age int, gender char(1));

ALTER TABLE user ADD CONSTRAINT FOREIGN KEY(email) REFERENCES login(email) on delete cascade;

CREATE TABLE airlines(airline_id varchar(10) primary key, airline_name varchar(25));

CREATE TABLE airports(airport_code varchar(25) primary key,airport_name varchar(25), country varchar(25));

CREATE TABLE flights(flight_no varchar(25) primary key, from_airport_code varchar(25), to_airport_code varchar(25), airline_id varchar(25), depature_time datetime, arrival_time datetime, seats_left_economy int(5), seats_left_business int(5));

ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(from_airport_code) REFERENCES airports(airport_code) on delete cascade;

ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(to_airport_code) REFERENCES airports(airport_code) on delete cascade;

ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;

CREATE TABLE costs(airline_id varchar(25), economy int(11), business int(11));

ALTER TABLE costs ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;

CREATE TABLE bookings(booking_id varchar(25) primary key, customer_email varchar(50), no_of_seats int(11), flight_no varchar(25), booking_date date);

ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(customer_email) REFERENCES login(email) on delete cascade;

ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(flight_no) REFERENCES flights(flight_no) on delete cascade;
