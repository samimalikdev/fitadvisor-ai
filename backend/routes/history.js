const express = require('express');
const router = express.Router();
const historyController = require('../controllers/historyController');
const authMiddleware = require('../middleware/auth');


router.get('/', authMiddleware, historyController.getHistory);


router.get('/:date', authMiddleware, historyController.getDailyLog);


router.post('/log_day', authMiddleware, historyController.logDay);


router.post('/add_meal', authMiddleware, historyController.addMeal);


router.post('/remove_meal', authMiddleware, historyController.removeMeal);

module.exports = router;
