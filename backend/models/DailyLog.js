const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema({
    name: { type: String, required: true },
    calories: { type: Number, default: 0 },
    protein: { type: Number, default: 0 },
    carbs: { type: Number, default: 0 },
    fat: { type: Number, default: 0 },
    time: { type: Date, default: Date.now }
});

const dailyLogSchema = new mongoose.Schema({
    userId: { type: String, default: 'anonymous_user' }, 
    date: { type: String, required: true }, 
    targetMacros: {
        calories: { type: Number, default: 0 },
        protein: { type: Number, default: 0 },
        carbs: { type: Number, default: 0 },
        fat: { type: Number, default: 0 }
    },
    consumedMacros: {
        calories: { type: Number, default: 0 },
        protein: { type: Number, default: 0 },
        carbs: { type: Number, default: 0 },
        fat: { type: Number, default: 0 }
    },
    macrosHit: { type: Boolean, default: false },
    meals: [mealSchema]
});


dailyLogSchema.index({ userId: 1, date: 1 }, { unique: true });

module.exports = mongoose.model('DailyLog', dailyLogSchema);
