const User = require('../models/User');

class ProfileService {
    async getProfile(userId) {
        let user = await User.findById(userId);
        if (!user) {
            throw new Error('User not found');
        }
        return user;
    }

    async updateProfile(userId, data) {
        const { age, height, weight, gender, activityLevel, goal, weeklyTarget, name } = data;

        const updatedUser = await User.findByIdAndUpdate(
            userId,
            { $set: { age, height, weight, gender, activityLevel, goal, weeklyTarget, name } },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );
        return updatedUser;
    }
}

module.exports = new ProfileService();
