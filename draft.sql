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
CREATE TABLE airlines(airline_id varchar(10) primary key, airline_name varchar(25), logo varchar(100));
CREATE TABLE airports(airport_code varchar(25) primary key,airport_name varchar(50), country varchar(25));
CREATE TABLE flights(flight_no varchar(25) primary key, from_airport_code varchar(25), to_airport_code varchar(25), airline_id varchar(25), departure_time datetime, arrival_time datetime, seats_left_economy int(5), seats_left_business int(5));
CREATE TABLE costs(airline_id varchar(25), economy int(11), business int(11));
CREATE TABLE bookings(booking_id int(25) auto_increment, customer_email varchar(50),no_of_seats int(11), flight_no varchar(25), booking_date date , class_type varchar(25), primary key(booking_id));
CREATE TABLE passenger(booking_id int(25), customer_name varchar(25), gender char(1),age int(11));

ALTER TABLE user ADD CONSTRAINT FOREIGN KEY(email) REFERENCES login(email) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(from_airport_code) REFERENCES airports(airport_code) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(to_airport_code) REFERENCES airports(airport_code) on delete cascade;
ALTER TABLE flights ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;
ALTER TABLE costs ADD CONSTRAINT FOREIGN KEY(airline_id) REFERENCES airlines(airline_id) on delete cascade;
ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(customer_email) REFERENCES login(email) on delete cascade;
ALTER TABLE bookings ADD CONSTRAINT FOREIGN KEY(flight_no) REFERENCES flights(flight_no) on delete cascade;
ALTER TABLE passenger ADD CONSTRAINT FOREIGN KEY(booking_id) REFERENCES bookings(booking_id) on delete cascade;

-- INSERT INTO login values("atulkuchil@gmail.com", "aa");
-- INSERT INTO user values("atulkuchil@gmail.com","Atul",20,"M");
INSERT INTO airports values("BLR","Bengaluru International Airport","India");
INSERT INTO airports values("MAA","Chennai International Airport","India");
INSERT INTO airports values("BOM","Chhatrapati Shivaji International Airport","India");
INSERT INTO airlines values("AIR001","Jet Airways","https://pbs.twimg.com/profile_images/876775499799736321/1nFK_O5O_400x400.jpg");
INSERT INTO airlines values("AIR002","SpiceJet","https://i.pinimg.com/originals/9f/41/91/9f4191ace7a83b42d468322d5668fefb.png");
INSERT INTO flights values("JA1234","BLR","MAA","AIR001","2019-10-21 06:00:00","2019-10-21 08:00:00",50,20);
INSERT INTO flights values("SJ3021","BLR","MAA","AIR002","2019-10-21 06:00:00","2019-10-21 08:00:00",50,20);
INSERT INTO flights values("JA1111","BLR","MAA","AIR001","2019-10-22 06:00:00","2019-10-22 08:00:00",50,20);
INSERT INTO flights values("SJ1234","BLR","BOM","AIR002","2019-10-23 10:00:00","2019-10-23 16:00:00",100,250);
INSERT INTO costs values("AIR001", 4500, 9000);
INSERT INTO costs values("AIR002", 3000, 6000);
-- INSERT INTO bookings values(0,"atulkuchil@gmail.com",1,"JA1234","2019-10-14 07:00:00","business");
-- INSERT INTO bookings values("0","atulkuchil@gmail.com",1,"SJ3021","2019-10-14 07:00:00");
-- INSERT INTO bookings values("0","atulkuchil@gmail.com",1,"JA1111","2019-10-14 07:00:00");
-- INSERT INTO bookings values("0","atulkuchil@gmail.com",1,"SJ1234","2019-10-14 07:00:00");
-- INSERT INTO passenger values(0,"Atul K", "M", 20);

DELIMITER //
CREATE PROCEDURE checkbookings(in name varchar(40))
BEGIN
select count(*) as len from passenger where customer_name=name;
END // 
DELIMITER ;

DELIMITER $$

CREATE TRIGGER bookdup after insert on bookings for each row 
BEGIN
DECLARE type_of_seat varchar(25);
DECLARE nos int(11);
DECLARE bk_id int(11);
select class_type into type_of_seat from bookings order by booking_id DESC LIMIT 1;
select no_of_seats into nos from bookings order by booking_id DESC LIMIT 1;
select booking_id into bk_id from bookings order by booking_id DESC LIMIT 1;

IF type_of_seat = 'business' THEN
UPDATE flights,bookings set seats_left_business = seats_left_business - nos where bookings.flight_no = flights.flight_no and bookings.booking_id = bk_id;
ELSE
UPDATE flights,bookings set seats_left_economy = seats_left_economy - nos where bookings.flight_no = flights.flight_no and bookings.booking_id = bk_id;
END IF;

END $$

DELIMITER ;

COMMIT;


-- Comment All after this
-- select l.logo,6*c.business as price,a1.airport_code as from_code,a1.airport_name as from_name,a2.airport_code as to_code,a2.airport_name as to_name,l.airline_name,f.flight_no,TIME(f.departure_time) as departure_time,TIME(f.arrival_time) as arrival_time from airports as a1, airports as a2, airlines as l, flights as f,costs as c where l.airline_id=f.airline_id and f.from_airport_code=a1.airport_code and f.to_airport_code=a2.airport_code and c.airline_id = l.airline_id and from_airport_code='BLR' and to_airport_code = 'MAA' and DATE(departure_time)='2019-10-21' and f.seats_left_business>=5;