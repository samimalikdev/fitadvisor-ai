const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');


router.post('/calculate_intake', aiController.calculateIntake);


router.post('/generate_recipes', aiController.generateRecipes);


router.post('/analyze_meal_name', aiController.analyzeMealName);


router.post('/analyze_food_image', aiController.analyzeFoodImage);


router.post('/health_impact', aiController.healthImpact);


router.post('/recommend_foods', aiController.recommendFoods);


router.post('/chat', aiController.chat);

module.exports = router;

