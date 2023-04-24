import {dbCreds} from '../config/config.js';

import oracledb from 'oracledb';
oracledb.autoCommit = true;


/* GET books List page. READ */
export function displayDepartmentsList(req, res, next) {
    res.render('index', { title: 'Departments list', page: 'departments/list'});
}

//  GET the Book Details page in order to add a new Book
export function displayAddPage(req, res, next) {
}

// POST process the Book Details page and create a new Book - CREATE
export function processAddPage(req, res, next) {
    
}

// GET the Book Details page in order to edit an existing Book
export function displayEditPage(req, res, next) {
}

// POST - process the information passed from the details form and update the document
export function processEditPage(req, res, next) {
}

// GET - process the delete by user id
export function processDelete(req, res, next) {
    
}