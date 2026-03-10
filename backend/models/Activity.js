const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    date: { type: String, required: true }, 
    waterIntake: { type: Number, default: 0 }, 
}, { timestamps: true });


activitySchema.index({ userId: 1, date: 1 }, { unique: true });

module.exports = mongoose.model('Activity', activitySchema);
