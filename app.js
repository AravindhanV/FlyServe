var express = require("express");
var app = express();
var mysql = require("mysql");
var bodyParser = require("body-parser");
var session = require("express-session");

var connection = mysql.createConnection({
  host: "localhost",
  user: "name",
  password: "MistakenFoe-6",
  database: "airline"
});

// var connection = mysql.createConnection({
//   host: "localhost",
//   user: "dbms",
//   password: "dbms",
//   database: "airline"
// });

connection.connect(function(err) {
  if (err) throw err;
  console.log("Connected to MYSQL!");
});

app.use(express.static("assets"));
app.use(express.static("css"));
app.use(express.static("js"));
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(
  session({ secret: "dbmsProject", resave: false, saveUninitialized: false })
);

app.get("/", function(req, res) {
  res.render("home");
});

app.get("/login", function(req, res) {
  res.render("home");
});

app.get("/register", function(req, res) {
  res.render("register");
});

app.get("/home", function(req, res) {
  res.render("search");
});

app.get("/search", function(req, res) {
  var r = (req.session.search = req.query);
  var from = r.from;
  var to = r.to;
  var date = r.date;
  var class_type = r.class;
  var noofppl = r.noofppl;
  req.session.noofppl = noofppl;
  var sql =
    "select l.logo," +
    noofppl +
    "*c." +
    class_type +
    " as price,a1.airport_code as from_code,a1.airport_name as from_name,a2.airport_code as to_code,a2.airport_name as to_name,l.airline_name,f.flight_no,TIME(f.departure_time) as departure_time,TIME(f.arrival_time) as arrival_time from airports as a1, airports as a2, airlines as l, flights as f,costs as c where l.airline_id=f.airline_id and f.from_airport_code=a1.airport_code and f.to_airport_code=a2.airport_code and c.airline_id = l.airline_id and from_airport_code='" +
    from +
    "' and to_airport_code = '" +
    to +
    "' and DATE(departure_time)='" +
    date +
    "' and f.seats_left_" +
    class_type +
    ">=" +
    noofppl;
  // console.log(sql);
  connection.query(sql, function(err, result) {
    if (err) {
      console.log(err);
    } else {
      req.session.message = result;
      res.redirect("/flights");
    }
  });
});

app.get("/flights", function(req, res) {
  var flights = req.session.message;
  // console.log(flights);
  res.render("results", { flights: flights });
});

app.get("/test", function(req, res) {
  // var bookingsql = "INSERT INTO bookings( customer_email,no_of_seats,flight_no, booking_date ) values('" +customer_email +"' , '" + no_of_seats +"' , '" + flight_no +"' , '"+ booking_date + "')";
  // var bookingsql = "INSERT INTO bookings(customer_email,no_of_seats,flight_no, booking_date ) values('varavindhan2010@gmail.com' , '5' , 'SJ1234' , '2019-10-15')";
  // connection.query(bookingsql,function(err,result){
  //   console.log(err);
  //   console.log(result);
  // });
  // console.log(req.session.search);
  var sql = "CALL checkbookings('Aravindh')";
  connection.query(sql, function(err, result) {
    if (err) {
      console.log(err);
    } else {
      console.log(result[0][0].len);
    }
  });
  res.send("Hello World!");
});

app.get("/book/:flight_id", function(req, res) {
  req.session.fid = req.params.flight_id;
  req.session.f = 1;
  req.session.passengers = [];
  res.redirect("/passenger");
});

app.get("/passenger", function(req, res) {
  var n = req.session.noofppl;
  var f = req.session.f;
  if (f <= n) {
    res.render("passenger", { n: f });
  } else {
    res.redirect("/confirmbooking");
  }
});

app.get("/confirmbooking", function(req, res) {
  var id;
  var search = req.session.search;
  var d = new Date();
  var date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
  var bookingsql =
    "INSERT INTO bookings(customer_email,no_of_seats,flight_no,booking_date,class_type) values ('" +
    req.session.email +
    "' , '" +
    search.noofppl +
    "' , '" +
    req.session.fid +
    "' , '" +
    date +
    "', '" +
    search.class + 
    "')";
  connection.query(bookingsql, function(err, result) {
    if (err) {
      console.log(err);
    } else {
      id = result.insertId;
      ps = [];
      req.session.passengers.forEach(async function(p) {
        var checksql = "CALL checkbookings('" + p.name + "')";
        await connection.query(checksql, function(err, flagres) {
          if (err) {
            console.log(err);
          } else {
            var flag = flagres[0][0].len;
            console.log(flag);
            if (flag == 0) {
              var ip =
                "INSERT INTO passenger values(" +
                id +
                ",'" +
                p.name +
                "','" +
                p.gender +
                "'," +
                p.age +
                ")";
              console.log(ip);
              connection.query(ip);
            } 
          }
        });
      });
      res.send("Booking Confirmed");
      // res.send("Booking Confirmed with " + conflicts + " conflicts");
    }
  });
});

app.post("/passenger", function(req, res) {
  req.session.f++;
  req.session.passengers.push(req.body);
  res.redirect("/passenger");
});

app.post("/login", function(req, res) {
  var body = req.body;
  var email = body.email;
  var pass = body.pass;
  req.session.email = email;
  var getPass = "SELECT password FROM login WHERE email='" + email + "'";

  connection.query(getPass, function(err, result, fields) {
    if (err) {
      console.log(err);
    } else {
      var dbpass = result[0].password;
      if (pass == dbpass) {
        res.redirect("/home");
      } else {
        res.redirect("/login");
      }
    }
  });
});

app.post("/register", function(req, res) {
  var body = req.body;
  var email = body.email;
  var pass = body.pass;
  var name = body.name;
  var age = body.age;
  var gender = body.gender;

  var sql = "INSERT INTO login VALUES('" + email + "','" + pass + "')";
  var datasql =
    "INSERT INTO user VALUES('" +
    email +
    "','" +
    name +
    "'," +
    age +
    ",'" +
    gender +
    "')";
  connection.query(sql, function(err, result) {
    connection.query(datasql, function(ierr, iresult) {
      if (ierr) throw ierr;
      console.log(iresult);
      res.redirect("/login");
    });
  });
});

app.listen(8080, function() {
  console.log("Server has started at http://localhost:8080");
});

async function checkBookings(p) {}
