import createError from 'http-errors';
import express from 'express';

// Fix for __dirname using ESM
import path,{dirname} from 'path';
import {fileURLToPath} from 'url';
const __dirname = dirname(fileURLToPath(import.meta.url));

import logger from 'morgan';

// import the router data
import indexRouter from '../routes/index.js';
import companyRouter from '../routes/company.js';
import jobsRouters from '../routes/jobs.js';
import departmentsRouters from '../routes/departments.js';

const app = new express();

// view engine setup
app.set('views', path.join(__dirname, '../views'));
app.set('view engine', 'ejs');


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
// app.use(cookieParser());
app.use(express.static(path.join(__dirname, '../../client')));
app.use(express.static(path.join(__dirname, '../../node_modules')));



// use routes
app.use('/', indexRouter);
app.use('/', companyRouter);
app.use('/', jobsRouters);
app.use('/', departmentsRouters);

// catch 404 and forward to error handler
app.use((req, res, next) => {
    next(createError(404));
});

// error handler
app.use((err, req, res, next) => {

     // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

      // render the error page
    res.status(err.status || 500);
    res.render('error');
});

export default app;