const authService = require('../services/authService');

class AuthController {
    async register(req, res) {
        try {
            const { name, email, password } = req.body;
            const result = await authService.register(name, email, password);
            res.status(201).json(result);
        } catch (error) {
            console.error('Registration error:', error);
            const status = error.message.includes('required') || error.message.includes('exists') ? 400 : 500;
            res.status(status).json({ error: error.message || 'Server error during registration' });
        }
    }

    async login(req, res) {
        try {
            const { email, password } = req.body;
            const result = await authService.login(email, password);
            res.json(result);
        } catch (error) {
            console.error('Login error:', error);
            const status = error.message.includes('fields') || error.message.includes('Invalid credentials') ? 400 : 500;
            res.status(status).json({ error: error.message || 'Server error during login' });
        }
    }

    async googleLogin(req, res) {
        try {
            const { idToken } = req.body;
            const result = await authService.googleLogin(idToken);
            res.json(result);
        } catch (error) {
            console.error('Google Auth Error:', error);
            res.status(500).json({ error: error.message || 'Invalid or Expired Google Token' });
        }
    }

    async appleLogin(req, res) {
        try {
            const { identityToken, fullName } = req.body;
            const result = await authService.appleLogin(identityToken, fullName);
            res.json(result);
        } catch (error) {
            console.error('Apple Auth Error:', error);
            res.status(500).json({ error: error.message || 'Invalid or Expired Apple Token' });
        }
    }
}

module.exports = new AuthController();
