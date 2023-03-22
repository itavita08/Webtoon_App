const express = require('express');
const router = express.Router();
const webtoonController = require('../controllers/webtoonController');
const errorController = require('../controllers/errorController');

router.get('/webtoon/:day', webtoonController.getWebtoonsByDay);
router.get('/webtoon/detail/:id', webtoonController.getWebtoonById);
router.get('/webtoon/:id/episodes', webtoonController.getWebtoonByEpisode);
router.use(errorController.handleServerError);

module.exports = router;