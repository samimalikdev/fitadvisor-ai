const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String }, 
    age: { type: Number },
    height: { type: Number },
    weight: { type: Number },
    gender: { type: String },
    activityLevel: { type: String },
    goal: { type: String, default: 'Maintenance' },
    weeklyTarget: { type: String, default: '' },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
