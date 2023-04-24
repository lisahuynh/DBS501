// modules required for routing
import { Router } from "express";

import { displayAddPage, processAddPage, displayJobsList, displayEditPage, processJobsPage, processDelete, processEditPage } from "../controllers/jobs.js";

const router = Router();

/* GET books List page. READ */
router.get('/jobs/list', displayJobsList);

//  GET jobs add page
router.get('/jobs/add', displayAddPage);

router.post('/jobs/add', processAddPage);

// POST process jobid information to get job title - CREATE
router.post('/jobs/list', processJobsPage);

// GET the Book Details page in order to edit an existing Book
router.get('/jobs/edit/:id', displayEditPage);

// POST - process the information passed from the details form and update the document
router.post('/jobs/edit/:id', processEditPage);

// GET - process the delete by user id
router.get('/jobs/delete/:id', processDelete);


export default router;