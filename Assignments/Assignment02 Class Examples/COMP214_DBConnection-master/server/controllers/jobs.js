import {dbCreds} from '../config/config.js';

import oracledb from 'oracledb';
oracledb.autoCommit = true;

/* GET books List page. READ */
export function displayJobsList(req, res, next) {

    var rslt = new Object();
    var jobsCollection = [];

    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');

        connection.execute("SELECT * FROM HR_jobs", function(err, result){
            if(err){ console.error(err.message); return; }
        
            rslt = JSON.stringify(result);
            // console.log(JSON.parse(rslt));

            for(let count = 0; count < JSON.parse(rslt).rows.length; count++){
                let job = ({
                    job_id:       JSON.parse(rslt).rows[count][0],
                    job_title:    JSON.parse(rslt).rows[count][1],
                    min_salary:   JSON.parse(rslt).rows[count][2],
                    max_salary:   JSON.parse(rslt).rows[count][3],
                });
                jobsCollection.push(job);
                // console.log(employee.date);
            }
            res.render('index', { title: 'Employee list', page: 'jobs/list', jobs: jobsCollection});
        });
        // console.log(employeeCollection);
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    
    });
}

export function displayAddPage(req, res, next){
   res.render('index', { title: 'New Job Form', page: '/jobs/add'});
}

export function processAddPage(req, res, next){
    oracledb.getConnection(
    { 
        user: dbCreds.user,
        password: dbCreds.password,
        connectString: dbCreds.connectString
    },
    function(err, connection) {
        if (err) { console.error(err.message); return; } 
        console.log('Connection was successful!');


        let sqlStatement = "BEGIN new_job('" + req.body.job_id + "','" + req.body.job_title + "'," + 
        req.body.min_salary + "," + req.body.max_salary + "); END;";
        console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, results){
            if(err){ console.error(err.message); return; }
        });
        // console.log(employeeCollection);
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/jobs/list');
    });
}

// POST process the find job request and display to new page - CREATE
export function processJobsPage(req, res, next) {
    // console.log("Find job");
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
        // console.log(employeeDetails.department_id);
        let sqlStatement = "SELECT job_title from hr_jobs where job_id = '" + req.body.job_id + "'";
        // console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }

            rslt = JSON.stringify(result);
            //console.log(rslt);
            let title = JSON.parse(rslt).rows[0][0];
            //console.log(title);
            
            // document.getElementById("jobTitleTextField").value = title;
            res.render('index', { title: 'Job Title', page: 'jobs/title', job: title});
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    }));
}

// GET the Book Details page in order to edit an existing Book
export function displayEditPage(req, res, next) {

    let job;
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
        // console.log(employeeDetails.department_id);
        let sqlStatement = "SELECT * from hr_jobs where job_id = '" + req.params.id + "'";
        // console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }

            rslt = JSON.stringify(result);
            console.log(rslt);
            job = {
                job_id:     JSON.parse(rslt).rows[0][0],
                job_title:  JSON.parse(rslt).rows[0][1],
                min_salary: JSON.parse(rslt).rows[0][2],
                max_salary: JSON.parse(rslt).rows[0][3]
            };
            res.render('index', {title: 'Edit Job', page: 'jobs/edit', jobs: job});
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
    }));
}

// POST - process the information passed from the details form and update the document
export function processEditPage(req, res, next) {
    let editID = req.params.id;
    console.log(editID);
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
        
        let sqlStatement = "BEGIN edit_job('" + editID + "','" + req.body.job_title +
                           "'," + req.body.min_salary + "," + req.body.max_salary + "); END;";
        console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/jobs/list');
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
                    
        let sqlStatement = "DELETE FROM HR_JOBS WHERE JOB_ID ='" + req.params.id + "'";
        console.log(sqlStatement);
        connection.execute(sqlStatement, function(err, result){
            if(err){ console.error(err.message); return; }
        });
        connection.close(function(err) {
            if (err) { console.error(err.message); return; }
        });
        res.redirect('/jobs/list');
    }));
}