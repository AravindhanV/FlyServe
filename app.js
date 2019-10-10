var express = require('express');
var app = express();
var mysql  = require('mysql');
var bodyParser =  require('body-parser');
var bcrypt = require('bcrypt');

var connection = mysql.createConnection({
    host: 'localhost',
    user: 'dbms',
    password: 'dbms',
    database: 'airline'
});

app.use(express.static("assets"));
app.use(express.static("css"));
app.set("view engine","ejs");
app.use(bodyParser.urlencoded({extended: true}));

const saltRounds = 10;
// const myPlaintextPassword = 's0/\/\P4$$w0rD';
// const someOtherPlaintextPassword = 'not_bacon';

app.get('/',function(req,res){
    res.render("home");
});

app.get("/register",function(req,res){
    res.render("register");
});

app.post("/register",function(req,res){
    console.log(req.body);
    res.redirect('/register');
});

app.listen(8080,function(){
    console.log("Server has started");
});