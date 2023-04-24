// modules required for routing
import { Router } from "express";

import { displayAddPage, displayDepartmentsList, displayEditPage, processAddPage, processDelete, processEditPage } from "../controllers/departments.js";

const router = Router();

/* GET books List page. READ */
router.get('/departments/list', displayDepartmentsList);

//  GET the Book Details page in order to add a new Book
router.get('/company/add', displayAddPage);
// POST process the Book Details page and create a new Book - CREATE
router.post('/company/add', processAddPage);

// GET the Book Details page in order to edit an existing Book
router.get('/company/edit/:id', displayEditPage);

// POST - process the information passed from the details form and update the document
router.post('/company/edit/:id', processEditPage);

// GET - process the delete by user id
router.get('/company/delete/:id', processDelete);


export default router;