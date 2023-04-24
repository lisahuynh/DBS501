export function DisplayHomePage(req, res, next) {
    res.render('index', { title: 'Home', page: 'home' });
}