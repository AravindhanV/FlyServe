// var x = document.forms["myForm"]["fname"].value;
// if (x == "") {
//     alert("Name must be filled out");
//     return false;
// }                

var form = document.forms[0];

function validateForm(){
    // var name = form['name'].value;
    // if(name == ""){
    //     alert("Please Fill All Fields");
    //     return false;
    // }

    // var email = form['email'].value;
    // if(email == ""){
    //     alert("Please Fill All Fields");
    //     return false;
    // }

    var pass = form['pass'].value;
    if(pass == ""){
        alert("Please Fill All Fields");
        return false;
    }

    var cpass = form['cpass'].value;
    if(cpass != pass){
        alert("Passwords Don't Match");
        return false;
    }

    var age = form['age'].value;
    console.log("Age: "+age);
    if(age == ""){
        alert("Please Fill All Fields");
        return false;
    }
}