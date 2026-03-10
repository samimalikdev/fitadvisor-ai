const bcrypt = require('bcryptjs');
const User = require('../models/User');
const { generateToken } = require('../utils/token');
const { OAuth2Client } = require('google-auth-library');
const appleSignin = require('apple-signin-auth');

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID || 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com';
const googleClient = new OAuth2Client(GOOGLE_CLIENT_ID);

class AuthService {
    async register(name, email, password) {
        if (!name || !email || !password) {
            throw new Error('Please enter all required fields');
        }

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            throw new Error('A user with this email already exists');
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        const newUser = new User({
            name,
            email,
            password: hashedPassword,
        });

        const savedUser = await newUser.save();
        const token = generateToken(savedUser._id);

        return {
            token,
            user: {
                id: savedUser._id,
                name: savedUser.name,
                email: savedUser.email
            }
        };
    }

    async login(email, password) {
        if (!email || !password) {
            throw new Error('Please enter all fields');
        }

        const user = await User.findOne({ email });
        if (!user) {
            throw new Error('Invalid credentials');
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            throw new Error('Invalid credentials');
        }

        const token = generateToken(user._id);

        return {
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email
            }
        };
    }

    async googleLogin(idToken) {
        if (!idToken) throw new Error('idToken is required');

        const ticket = await googleClient.verifyIdToken({
            idToken: idToken,
            audience: GOOGLE_CLIENT_ID,
        });

        const payload = ticket.getPayload();
        const { email, name } = payload;

        let user = await User.findOne({ email });
        if (!user) {
            user = new User({
                name: name || 'Google User',
                email: email,
            });
            await user.save();
        }

        const token = generateToken(user._id);
        return {
            token,
            user: { id: user._id, name: user.name, email: user.email }
        };
    }

    async appleLogin(identityToken, fullName) {
        if (!identityToken) throw new Error('identityToken is required');

        const appleIdTokenClaims = await appleSignin.verifyIdToken(identityToken, {
            ignoreExpiration: true
        });

        const { email } = appleIdTokenClaims;

        let user = await User.findOne({ email });
        if (!user) {
            user = new User({
                name: fullName || 'Apple User',
                email: email,
            });
            await user.save();
        }

        const token = generateToken(user._id);
        return {
            token,
            user: { id: user._id, name: user.name, email: user.email }
        };
    }
}

module.exports = new AuthService();
