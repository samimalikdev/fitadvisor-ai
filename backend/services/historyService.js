const DailyLog = require('../models/DailyLog');

class HistoryService {
    async getHistory(userId) {
        console.log("User requesting history:", userId);
        const logs = await DailyLog.find({ userId }).sort({ date: -1 });
        console.log("Found", logs.length, "logs in database for this user.");
        return logs;
    }

    async getDailyLog(userId, date) {
        console.log("User requesting date:", date, "userId:", userId);

        const log = await DailyLog.findOne({ userId, date });
        if (!log) {
            console.log("Log not found for date:", date);
            throw new Error('Log not found for this date');
        }
        console.log("SENDING log for date:", date, "with", log.meals.length, "meals.");
        return log;
    }

    async logDay(userId, data) {
        const { date, targetMacros, consumedMacros, macrosHit, meals } = data;

        const updatedLog = await DailyLog.findOneAndUpdate(
            { userId, date },
            {
                $set: { targetMacros, consumedMacros, macrosHit, meals }
            },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );

        return updatedLog;
    }

    async addMeal(userId, data) {
        const { date, meal, targetMacros } = data;

        let updateQuery = {
            $push: { meals: meal },
            $inc: {
                'consumedMacros.calories': meal.calories || 0,
                'consumedMacros.protein': meal.protein || 0,
                'consumedMacros.carbs': meal.carbs || 0,
                'consumedMacros.fat': meal.fat || 0
            }
        };

        if (targetMacros) {
            updateQuery.$set = { targetMacros };
        }

        let updatedLog = await DailyLog.findOneAndUpdate(
            { userId, date },
            updateQuery,
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );

        const targetCalories = updatedLog.targetMacros.calories || 0;
        const targetProtein = updatedLog.targetMacros.protein || 0;
        const consumedCals = updatedLog.consumedMacros.calories || 0;
        const consumedProtein = updatedLog.consumedMacros.protein || 0;

        const calsHit = targetCalories > 0 && consumedCals >= targetCalories;
        const isHit = calsHit;

        if (updatedLog.macrosHit !== isHit) {
            updatedLog.macrosHit = isHit;
            await updatedLog.save();
        }

        return updatedLog;
    }

    async removeMeal(userId, data) {
        const { date, meal, targetMacros } = data;

        if (!meal || !meal.time) {
            throw new Error('Meal time string is required as unique ID');
        }

        let updateQuery = {
            $pull: { meals: { time: meal.time } },
            $inc: {
                'consumedMacros.calories': -(meal.calories || 0),
                'consumedMacros.protein': -(meal.protein || 0),
                'consumedMacros.carbs': -(meal.carbs || 0),
                'consumedMacros.fat': -(meal.fat || 0)
            }
        };

        if (targetMacros) {
            updateQuery.$set = { targetMacros };
        }

        let updatedLog = await DailyLog.findOneAndUpdate(
            { userId, date },
            updateQuery,
            { new: true }
        );

        if (!updatedLog) {
            throw new Error('Log not found for updating');
        }

        const targetCalories = updatedLog.targetMacros.calories || 0;
        const targetProtein = updatedLog.targetMacros.protein || 0;
        const consumedCals = updatedLog.consumedMacros.calories || 0;
        const consumedProtein = updatedLog.consumedMacros.protein || 0;

        const calsHit = targetCalories > 0 && consumedCals >= targetCalories;
        const isHit = calsHit;

        if (updatedLog.macrosHit !== isHit) {
            updatedLog.macrosHit = isHit;
            await updatedLog.save();
        }

        return updatedLog;
    }
}

module.exports = new HistoryService();
