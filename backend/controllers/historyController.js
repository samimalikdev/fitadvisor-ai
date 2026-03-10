const historyService = require('../services/historyService');

class HistoryController {
    async getHistory(req, res) {
        try {
            const userId = req.user.id;
            const logs = await historyService.getHistory(userId);
            res.json(logs);
        } catch (error) {
            console.error('Error fetching history:', error);
            res.status(500).json({ error: 'Server error fetching history' });
        }
    }

    async getDailyLog(req, res) {
        try {
            const { date } = req.params;
            const userId = req.user.id;
            const log = await historyService.getDailyLog(userId, date);
            res.json(log);
        } catch (error) {
            console.error('Error fetching daily log:', error);
            const status = error.message.includes('not found') ? 404 : 500;
            res.status(status).json({ error: error.message || 'Server error fetching daily log' });
        }
    }

    async logDay(req, res) {
        try {
            const userId = req.user.id;
            const updatedLog = await historyService.logDay(userId, req.body);
            res.json(updatedLog);
        } catch (error) {
            console.error('Error saving daily log:', error);
            res.status(500).json({ error: 'Server error saving daily log' });
        }
    }

    async addMeal(req, res) {
        try {
            const userId = req.user.id;
            const updatedLog = await historyService.addMeal(userId, req.body);
            res.json(updatedLog);
        } catch (error) {
            console.error('Error adding meal to daily log:', error);
            res.status(500).json({ error: 'Server error adding meal' });
        }
    }

    async removeMeal(req, res) {
        try {
            const userId = req.user.id;
            const updatedLog = await historyService.removeMeal(userId, req.body);
            res.json(updatedLog);
        } catch (error) {
            console.error('Error removing meal from daily log:', error);
            const status = error.message.includes('required') ? 400 : (error.message.includes('not found') ? 404 : 500);
            res.status(status).json({ error: error.message || 'Server error removing meal' });
        }
    }
}

module.exports = new HistoryController();
