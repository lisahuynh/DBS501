/* DBS501 - Assignment 2 
Students: Lisa Huynh and Brenda Yu
Date: March 31, 2023 */

var HTTP_PORT = process.env.PORT || 3000;

const express = require("express");
const exphbs = require('express-handlebars');
const path = require("path");
const app = express();
var bodyParser = require("express");
const oracledb = require('oracledb');
//oracledb.initOracleClient({ libDir: '/Users/lisahuynhkapur/Downloads/instantclient'});

const options = {
    libDir: '/Users/lisahuynhkapur/Downloads/instantclient',
  };
  
  try {
    oracledb.initOracleClient(options);
    console.log('Oracle client initialized successfully');
  } catch (err) {
    console.error('Error initializing Oracle client:', err);
  }

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

//HR application screen
app.get("/", (req, res) => {
    res.render('home');
});

app.post("/", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        //SQL query for employee list
        const empresult = await connection.execute(
            `SELECT employee_id, first_name, last_name, email, phone_number, TO_CHAR(hire_date, 'DD-MON-RR'), job_id, salary, TO_CHAR(commission_pct, '0.99'), manager_id, department_id FROM hr_employees ORDER BY employee_id DESC`
        );
        const employees = empresult.rows;

        //SQL query for job list
        const jobresult = await connection.execute(
            `SELECT * FROM hr_jobs ORDER BY job_id`
        );
        const jobs = jobresult.rows;

        //SQL query for department list
        const deptresult = await connection.execute(
            `SELECT * FROM hr_departments ORDER BY department_id`
        )
        const depts = deptresult.rows;

        if (btnrequest === 'employee') {
            res.render('employeeList', { employees });
        } else if (btnrequest === 'job') {
            res.render('jobList', {jobs });
        } else if (btnrequest === 'department') {
            res.render('deptList', { depts });
        };
    } catch (err) {
            console.error(err);
            res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//employee list
app.post("/employee", async (req,res) => {
    const btnrequest = req.body.btnsubmit;
    const editEmployee = req.body.empID
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        //SQL query for job_id and job_title
        const jobs = await connection.execute(
        `SELECT job_id || ' - ' || job_title FROM hr_jobs ORDER BY job_id`
        );
        const jobList = jobs.rows;

        //SQL query for manager_id, first_name, and last_name
        const manager = await connection.execute(
        `SELECT m.manager_id || ' - ' || e.first_name || ' ' || e.last_name FROM hr_employees e, hr_employees m WHERE m.manager_id = e.employee_id GROUP BY m.manager_id, e.first_name, e.last_name ORDER BY m.manager_id`
        );
        const managerList = manager.rows;

        //SQL query for department_id and department_name
        const dept = await connection.execute(
        `SELECT department_id || ' - ' || department_name FROM hr_departments ORDER BY department_id`
        );
        const deptList = dept.rows;

        //SQL query for employee list
        const result = await connection.execute(
        `SELECT employee_id, first_name, last_name, email, phone_number, TO_CHAR(hire_date, 'DD-MON-RR'), job_id, salary, TO_CHAR(commission_pct, '0.99'), manager_id, department_id FROM hr_employees WHERE employee_id = :id`, [editEmployee]
        );
        const employeeRecord = result.rows;
        
        if (btnrequest === 'hireForm') {
            res.render('hiringForm', { jobList, managerList, deptList });
        } else if (btnrequest === 'editEmp') {
            res.render('employee', { employeeRecord });
        } else {
            res.render('home');
        }
    } catch (err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//new hire form
app.post("/hireForm", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    const fname = req.body.fname;
    const lname = req.body.lname;
    const email = req.body.email;
    const salary = req.body.salary;
    const phone = req.body.phone;
    const job_id = req.body.jobId;
    const manager_id = req.body.managerId;
    const dept_id = req.body.deptId;
    const hire_date = new Date();

    const jobId = job_id.substring(0, job_id.indexOf(' '));
    const managerId = manager_id.substring(0, manager_id.indexOf(' '));
    const departmentId = dept_id.substring(0, dept_id.indexOf(' '));

    const inputParams = {
        p_first_name: fname,
        p_last_name: lname,
        p_email: email,
        p_salary: salary,
        p_hire_date: hire_date,
        p_phone: phone,
        p_job_id:jobId,
        p_manager_id: managerId,
        p_department_id: departmentId
    };

    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        if (btnrequest === 'hire') {
            //Call prc_employee_hire_sp and update database with new parameters
            await connection.execute(
                'BEGIN prc_employee_hire_sp(:p_first_name, :p_last_name, :p_email, :p_salary, :p_hire_date, :p_phone, :p_job_id, :p_manager_id, :p_department_id); END;',
                inputParams
            );
        }

        //SQL query for employee list
        const empresult = await connection.execute(
            `SELECT employee_id, first_name, last_name, email, phone_number, TO_CHAR(hire_date, 'DD-MON-RR'), job_id, salary, TO_CHAR(commission_pct, '0.99'), manager_id, department_id FROM hr_employees ORDER BY employee_id DESC`
        );
        const employees = empresult.rows;

        res.render('employeeList', { employees });
    } catch (err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//edit employee
app.post("/employeedetail", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    const empId = parseInt(req.body.empId);
    const email = req.body.email;
    const phone = req.body.phone;
    const salary = req.body.salary;

    const inputParams = {
        p_emp_id: empId,
        p_salary: salary,
        p_phone: phone,
        p_email: email,
    };

    let connection;
    
    try {
        connection = await oracledb.getConnection(dbConfig);

        //call procedure for editing employee record
        await connection.execute(
        'BEGIN prc_employee_edit(:p_emp_id, :p_salary, :p_phone, :p_email); END;',
        inputParams
        );

        //SQL query for employee list
        const empresult = await connection.execute(
        `SELECT employee_id, first_name, last_name, email, phone_number, TO_CHAR(hire_date, 'DD-MON-RR'), job_id, salary, TO_CHAR(commission_pct, '0.99'), manager_id, department_id FROM hr_employees ORDER BY employee_id DESC`
        );
        const employees = empresult.rows;

        if (btnrequest === 'submit' || btnrequest === 'cancel') {
            res.render('employeeList', { employees });
        } 
    } catch (err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//job list
app.post("/job", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    const editJob = req.body.jobId.toUpperCase();

    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        //SQL query for one job_id detail
        const result = await connection.execute(
        `SELECT * FROM hr_jobs WHERE job_id = '${editJob}'`
        );
        const jobRecord = result.rows;

        if (btnrequest === 'jobForm') {
            res.render('jobForm')
        } else if (btnrequest === 'editJob') {
            res.render('job', { jobRecord });
        } else if (btnrequest === 'jobdesc') {
            res.render('jobDesc', { jobRecord });
        } else {
            res.render('home');
        }
    } catch (err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//new job 
app.post("/jobForm", async (req,res) => {
    const btnrequest = req.body.btnsubmit;
    const jobId = req.body.jobId;
    const title = req.body.title;
    const minSal = parseInt(req.body.minsalary);
    const maxSal = req.body.maxsalary;

    const inputParams = {
            p_jobid: jobId,
            p_title: title,
            v_minsal: minSal,
            v_maxsal: maxSal
        };

    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        if (btnrequest === 'save') {

            //call procedure for creating new job
            await connection.execute(
                'BEGIN prc_new_job(:p_jobid, :p_title, :v_minsal, :v_maxsal); END;',
                inputParams
            )
        }

        //SQL query for job list
        const jobresult = await connection.execute(
            `SELECT * FROM hr_jobs ORDER BY job_id`
        );
        const jobs = jobresult.rows;

        res.render('jobList', { jobs });
    } catch(err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//job detail
app.post("/jobdetail", async (req, res) => {
    const btnrequest = req.body.btnsubmit;
    const jobId = req.body.jobId;
    const title = req.body.title;
    const minSal = parseInt(req.body.minsal);
    const maxSal = parseInt(req.body.maxsal);

    const inputParams = {
        p_job_id: jobId,
        p_job_title: title,
        p_min_salary: minSal,
        p_max_salary: maxSal
    };

    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        if (btnrequest === 'submit') {
            //Call prc_employee_hire_sp and update database with new parameters
            await connection.execute(
                'BEGIN prc_job_desc(:p_job_id, :p_job_title, :p_min_salary, :p_max_salary); END;',
                inputParams
            );
        }

        //SQL query for job list
        const jobresult = await connection.execute(
            `SELECT * FROM hr_jobs ORDER BY job_id`
        );
        const jobs = jobresult.rows;

        res.render('jobList', { jobs });
    } catch(err) {
        console.error(err);
        res.send("Error fetching data");
    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

//job description
app.post("/jobdesc", (req, res) => {
    res.render('home');
});

//department
app.post("/department", (req, res) => {
    res.render('home');
});

var server = app.listen(HTTP_PORT, function () {
    console.log("Listening on port " + HTTP_PORT);
});