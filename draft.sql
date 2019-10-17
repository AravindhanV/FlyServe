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
CREATE TABLE airlines(airline_id varchar(10) primary key, airline_name varchar(25));
CREATE TABLE airports(airport_code varchar(25) primary key,airport_name varchar(50), country varchar(25));
CREATE TABLE flights(flight_no varchar(25) primary key, from_airport_code varchar(25), to_airport_code varchar(25), airline_id varchar(25), departure_time datetime, arrival_time datetime, seats_left_economy int(5), seats_left_business int(5));
CREATE TABLE costs(airline_id varchar(25), economy int(11), business int(11));
CREATE TABLE bookings(booking_id varchar(25) primary key, customer_email varchar(50), no_of_seats int(11), flight_no varchar(25), booking_date date);

ALTER TABLE user ADD CONSTRAINT FOREIGN KEY(email) REFERENCES login(email) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(from_airport_code) REFERENCES airports(airport_code) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(to_airport_code) REFERENCES airports(airport_code) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;
ALTER TABLE costs ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;
ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(customer_email) REFERENCES login(email) on delete cascade;
ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(flight_no) REFERENCES flights(flight_no) on delete cascade;

INSERT INTO airports values("BLR","Bengaluru International Airport","India");
INSERT INTO airports values("MAA","Chennai International Airport","India");
INSERT INTO airports values("BOM","Chhatrapati Shivaji International Airport","India");
INSERT INTO airlines values("AIR001","Jet Airways");
INSERT INTO airlines values("AIR002","SpiceJet");
INSERT INTO flights values("JA1234","BLR","MAA","AIR001","2019-10-21 06:00:00","2019-10-21 08:00:00",50,20);
INSERT INTO flights values("SJ1234","BLR","BOM","AIR001","2019-10-23 10:00:00","2019-10-23 16:00:00",100,250);
INSERT INTO costs values("AIR001", 4500, 9000);
INSERT INTO costs values("AIR002", 3000, 6000);

COMMIT;

-- Comment All after this
-- select a1.airport_code as from_code,a1.airport_name as from_name,a2.airport_code as to_code,a2.airport_name as to_name,l.airline_name,f.flight_no,f.depature_time,f.arrival_time from airports as a1, airports as a2, airlines as l, flights as f,costs as c where l.airline_id=f.airline_id and f.from_airport_code=a1.airport_code and f.to_airport_code=a2.airport_code and l.airline_id = c.airline_id;
