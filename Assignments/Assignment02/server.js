/* DBS501 - Assignment 2 
Students: Lisa Huynh and Brenda Yu
Date: March 19, 2023 */

var HTTP_PORT = process.env.PORT || 3000;

const express = require("express");
const exphbs = require('express-handlebars');
const path = require("path");
const app = express();
var fs = require("fs");
var bodyParser = require("express");
const oracledb = require('oracledb');
//oracledb.initOracleClient({ libDir: '/Users/lisahuynhkapur/Downloads/instantclient10_1' });

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.engine(".hbs", exphbs.engine({
    extname: ".hbs",
    defaultLayout: false,
    layoutsDir: path.join(__dirname, "/views")
}));

app.set("view engine", ".hbs");
app.use(express.static(path.join(__dirname, './public')));

// Set database connection details
const dbConfig = {
    user: 'Dbs501_231v1a04',
    password: '19376128',
    connectString: '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=myoracle12c.senecacollege.ca)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=oracle12c)))'
  };

// Async function to connect to the database
async function connectToDatabase() {
    let connection;
  
    try {
      connection = await oracledb.getConnection(dbConfig);
      console.log("Connection to Oracle DB successful!")
  
      // Connection succeeded, do something with the connection here
  
    } catch (err) {
      console.error(err.message);
    } finally {
      // Release the connection when done
      if (connection) {
        try {
          await connection.release();
        } catch (err) {
          console.error(err.message);
        }
      }
    }
  }

//HR application screen
app.get("/", (req, res) => {
    res.render('home');
});

app.post("/", (req, res) => {
    const btnrequest = req.body.btnsubmit;
    if (btnrequest === 'employee') {
        res.render('hiringForm');
    } else if (btnrequest === 'job') {
        res.render('jobForm');
    } else if (btnrequest === 'department') {
        res.render('deptForm');
    }
})
app.post("/employee", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    const fname = req.body.fname;
    const lname = req.body.lname;
    const email = req.body.email;
    const salary = req.body.salary;
    //const hiredate = req.body.hiredate;
    const phone = req.body.phone;

    const result = await connectToDatabase();
    console.log(connectToDatabase);
    if (btnrequest === 'hire') {
        const inputParams = {
            p_first_name: fname,
            p_last_name: lname,
            p_email: email,
            p_salary: salary,
            //p_hire_date: hiredate,
            p_phone: phone,
            //p_job_id:
            //p_manager_id:
            //p_department_id:
        }
        res.render('home');
    }

    if (btnrequest === 'cancel') {
        res.render('home');
    }
});

app.post("/job", (req, res) => {
    const btnrequest = req.body.btnsubmit

    if (btnrequest === 'save') {
        res.render('home');
    } else {
        res.render('home');
    }
});

app.post("/department", (req, res) => {
});

var server = app.listen(HTTP_PORT, function () {
    console.log("Listening on port " + HTTP_PORT);
});