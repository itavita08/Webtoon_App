const express = require('express');
const router = express.Router();
const webtoonController = require('../controllers/webtoonController');
const errorController = require('../controllers/errorController');
const jwt = require('../middlewares/jwt')

router.get('/:day', jwt.authenticateToken ,webtoonController.getWebtoonsByDay);
router.get('/detail/:id', jwt.authenticateToken, webtoonController.getWebtoonById);
router.get('/:id/episodes', jwt.authenticateToken, webtoonController.getWebtoonByEpisode);
router.use(errorController.handleServerError);

module.exports = router;