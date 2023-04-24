import {dbCreds} from '../config/config.js';

import oracledb from 'oracledb';
oracledb.autoCommit = true;

/* GET books List page. READ */
export function displayEmployeeList(req, res, next) {

    var rslt = new Object();
    var employeeCollection = [];

    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');

        connection.execute("SELECT * FROM HR_employees ORDER BY employee_id DESC", function(err, result){
            if(err){ console.error(err.message); return; }
        
            rslt = JSON.stringify(result);
            // console.log(JSON.parse(rslt));

            for(let count = 0; count < JSON.parse(rslt).rows.length; count++){
                let employee = ({
                    employee_id:   JSON.parse(rslt).rows[count][0],
                    first_name:    JSON.parse(rslt).rows[count][1],
                    last_name:     JSON.parse(rslt).rows[count][2],
                    email:         JSON.parse(rslt).rows[count][3],
                    phone_number:  JSON.parse(rslt).rows[count][4],
                    date:          JSON.parse(rslt).rows[count][5].split('T')[0],
                    job_id:        JSON.parse(rslt).rows[count][6],
                    salary:        JSON.parse(rslt).rows[count][7],
                    commission:    JSON.parse(rslt).rows[count][8],
                    manager_id:    JSON.parse(rslt).rows[count][9],
                    department_id: JSON.parse(rslt).rows[count][10]
                });
                employeeCollection.push(employee);
                // console.log(employee.date);
            }
            // console.log(employeeCollection[1].date.toString());
            res.render('index', { title: 'Employee list', page: 'company/list', company: employeeCollection});
        });
        // console.log(employeeCollection);
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    
    });
}

//  GET the Book Details page in order to add a new Book
export function displayAddPage(req, res, next) {
    var rslt = new Object();
    var jobsCollection = [];
    let managersCollection = [];
    let departmentsCollection = [];

    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');

        connection.execute("SELECT job_id, job_title from hr_jobs", function(err, result){
            if(err){ console.error(err.message); return; }
        
            rslt = JSON.stringify(result);
            // console.log(JSON.parse(rslt));
            for(let count = 0; count < JSON.parse(rslt).rows.length; count++){
                let jobs = ({
                    job_id:     JSON.parse(rslt).rows[count][0],
                    job_title:  JSON.parse(rslt).rows[count][1]
                });
                jobsCollection.push(jobs);
                // console.log(employee.date);
            }
            // console.log(jobsCollection);
        });
        let sqlStatement = "SELECT employee_id, first_name, last_name from hr_employees where job_id like '%MAN' OR job_id like '%MGR'";
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        
            rslt = JSON.stringify(result);

            for(let count = 0; count < JSON.parse(rslt).rows.length; count++){
                let managers = ({
                    employee_id:   JSON.parse(rslt).rows[count][0],
                    first_name:    JSON.parse(rslt).rows[count][1],
                    last_name:     JSON.parse(rslt).rows[count][2]
                });
                managersCollection.push(managers);
            }
            // console.log(jobsCollection);
        });
        sqlStatement = "SELECT department_id, department_name FROM hr_departments"
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        
            rslt = JSON.stringify(result);

            for(let count = 0; count < JSON.parse(rslt).rows.length; count++){
                let departments = ({
                    department_id:    JSON.parse(rslt).rows[count][0],
                    department_name:  JSON.parse(rslt).rows[count][1]
                });
                departmentsCollection.push(departments);
            }
            res.render('index', { title: 'Company Hiring Form', page: 'company/add', jobs: jobsCollection, managers: managersCollection, departments: departmentsCollection});
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    });
}

// POST process the Book Details page and create a new Book - CREATE
export function processAddPage(req, res, next) {
    
    var rslt = new Object();

    let employeeDetails = {
        first_name:    req.body.first_name,
        last_name:     req.body.last_name,
        email:         req.body.email,
        phone:         req.body.phone,
        date:          req.body.date,
        salary:        req.body.salary,
        job_id:        req.body.jobs,
        manager_id:    req.body.managers,
        department_id: req.body.departments
    };
    
    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    (async function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');
        // console.log(employeeDetails.department_id);
        let sqlStatement = "BEGIN employee_hire_sp('" + employeeDetails.first_name + "','" + employeeDetails.last_name + "','" + 
                            employeeDetails.email + "'," + employeeDetails.salary + 
                            ",TO_DATE('" + employeeDetails.date + "', 'YYYY-MM-DD'),'" + employeeDetails.phone + "','" +
                            employeeDetails.job_id + "'," + employeeDetails.manager_id + "," + employeeDetails.department_id + "); END;";
        // console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/company/list');
    }));
}

// GET the Book Details page in order to edit an existing Book
export function displayEditPage(req, res, next) {

    let employeeID = req.params.id;
    var employeeCollection = [];
    var rslt = new Object();

    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    (async function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');
        
        let sqlStatement = "SELECT * FROM HR_EMPLOYEES WHERE employee_id = " + employeeID;
        // console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
            
            rslt = JSON.stringify(result);
            // console.log(JSON.parse(rslt));
            let data;

            let employee = ({
                employee_id:   JSON.parse(rslt).rows[0][0],
                first_name:    JSON.parse(rslt).rows[0][1],
                last_name:     JSON.parse(rslt).rows[0][2],
                email:         JSON.parse(rslt).rows[0][3],
                phone_number:  JSON.parse(rslt).rows[0][4],
                date:          JSON.parse(rslt).rows[0][5],
                job_id:        JSON.parse(rslt).rows[0][6],
                salary:        JSON.parse(rslt).rows[0][7],
                commission:    JSON.parse(rslt).rows[0][8],
                manager_id:    JSON.parse(rslt).rows[0][9],
                department_id: JSON.parse(rslt).rows[0][10]
            });
            if(JSON.parse(rslt).rows[5] > 12){
                employee.date = JSON.parse(rslt).rows[0][5].split('T')[0];
            }
            // console.log(JSON.parse(rslt).rows[0][1]);
            res.render('index', { title: 'Edit Employee', page: 'company/edit', company: employee});
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    }));
}

// POST - process the information passed from the details form and update the document
export function processEditPage(req, res, next) {

    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    (async function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');
            
        let sqlStatement = "BEGIN employee_edit_sp(" + req.params.id + ", '" + req.body.email + "'," + req.body.salary + ",'" + req.body.phone_number + "');" +
                                "END;";
        console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
                if(err){ console.error(err.message); return; }
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/company/list');
    }));
}

// GET - process the delete by user id
export function processDelete(req, res, next) {
    
    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    (async function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');
                
        let sqlStatement = "DELETE FROM HR_EMPLOYEES WHERE EMPLOYEE_ID =" + req.params.id;
        // console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/company/list');
    }));
}