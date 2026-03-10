const profileService = require('../services/profileService');

class ProfileController {
    async getProfile(req, res) {
        try {
            const userId = req.user.id;
            const user = await profileService.getProfile(userId);
            res.json(user);
        } catch (err) {
            console.error('Error fetching profile:', err);
            const status = err.message === 'User not found' ? 404 : 500;
            res.status(status).json({ error: err.message || 'Server error fetching profile' });
        }
    }

    async updateProfile(req, res) {
        try {
            const userId = req.user.id;
            const updatedUser = await profileService.updateProfile(userId, req.body);
            res.json(updatedUser);
        } catch (err) {
            console.error('Error updating profile:', err);
            res.status(500).json({ error: 'Server error updating profile' });
        }
    }
}

module.exports = new ProfileController();
