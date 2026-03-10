const aiService = require('../services/aiService');

class AiController {
    async calculateIntake(req, res) {
        try {
            const data = await aiService.calculateIntake(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in calculate_intake:', err);
            res.status(500).json({ error: 'Server error calculating intake' });
        }
    }

    async generateRecipes(req, res) {
        try {
            const data = await aiService.generateRecipes(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in generate_recipes:', err);
            res.status(500).json({ error: 'Server error generating recipes' });
        }
    }

    async analyzeMealName(req, res) {
        try {
            const data = await aiService.analyzeMealName(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in analyze_meal_name:', err);
            res.status(500).json({ error: 'Server error analyzing meal name' });
        }
    }

    async analyzeFoodImage(req, res) {
        try {
            const data = await aiService.analyzeFoodImage(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in analyze_food_image:', err);
            res.status(500).json({ error: 'Server error analyzing food image' });
        }
    }

    async healthImpact(req, res) {
        try {
            const data = await aiService.getHealthImpact(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in health_impact:', err);
            res.status(500).json({ error: 'Server error generating health impact' });
        }
    }

    async recommendFoods(req, res) {
        try {
            const data = await aiService.recommendFoods(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in recommend_foods:', err);
            res.status(500).json({ error: 'Server error recommending foods' });
        }
    }

    async chat(req, res) {
        try {
            const data = await aiService.chat(req.body);
            res.json(data);
        } catch (err) {
            console.error('Error in chat:', err);
            res.status(500).json({ error: 'Server error in chat' });
        }
    }
}

module.exports = new AiController();
