const { GoogleGenAI } = require('@google/genai');
const stringSimilarity = require('string-similarity');
const promptsData = require('../data/ai_training_prompts.json');

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
const MODEL_NAME = 'gemini-3.1-flash-lite-preview';

class AiService {
    
    extractJson(text) {
        const match = text.match(/\{[\s\S]*\}|\[[\s\S]*\]/);
        if (match) {
            return JSON.parse(match[0]);
        }
        throw new Error("No JSON found in response");
    }

    async calculateIntake({ age, gender, height, weight, activityLevel }) {
        const prompt = `
=== TASK ===
Execute Request Type: Calculate Base Daily Macro Intake (Mifflin-St Jeor)

=== USER PROFILE ===
{"age_years":"${age}","gender":"${gender}","height_cm":"${height}","weight_kg":"${weight}","activity_level":"${activityLevel}"}

=== GOALS ===
{"goal":"Calculate exact maintenance calories and macro split"}

=== OUTPUT SCHEMA & STRICT RULES ===
Analyze the User Profile and calculate their exact daily calorie and macro intake.

MATHEMATICAL CALCULATIONS:
1. BMR Formula: Use the Mifflin-St Jeor equation explicitly.
   - Men: (10 × weight in kg) + (6.25 × height in cm) - (5 × age in yrs) + 5
   - Women: (10 × weight in kg) + (6.25 × height in cm) - (5 × age in yrs) - 161
2. Activity Multiplier:
   - Sedentary: BMR × 1.2
   - Light: BMR × 1.375
   - Moderate: BMR × 1.55
   - Active: BMR × 1.725
   - Very Active: BMR × 1.9
3. Macro Split Logic (based on total TDEE calories):
   - Protein: 30% of Total Calories (Protein = Calories * 0.30 / 4)
   - Fat: 30% of Total Calories (Fat = Calories * 0.30 / 9)
   - Carbohydrates: 40% of Total Calories (Carbs = Calories * 0.40 / 4)
4. Rounding Rules: Round ALL final values (calories and macros) mathematically strictly to the nearest whole integer.
5. Mathematical Validation Layer: Ensure (Protein x 4) + (Carbs x 4) + (Fat x 9) equals Total Calories (±2% tolerance).

Respond strictly in JSON format without markdown wraps:
{
  "dailyIntake": {
    "calories": <Exact Integer>,
    "carbohydrates": <Exact Integer>,
    "fat": <Exact Integer>,
    "protein": <Exact Integer>
  }
}
Do not include any other text, reasoning, or markdown blocks in the response. Just the pure JSON.
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: prompt,
        });

        return this.extractJson(response.text);
    }

    async generateRecipes({ remainingCalories, remainingProtein, remainingCarbs, remainingFat, cuisinePreference, dietaryPreference, halalPreference }) {
        const prompt = `
=== TASK ===
Execute Request Type: Generate 3 Recipes based on Remaining Daily Macros

=== CALCULATION DATA ===
{"remaining_macros_to_fill":{"calories":${remainingCalories},"protein_g":${remainingProtein},"carbohydrates_g":${remainingCarbs},"fat_g":${remainingFat}},"cuisine_preference":"${cuisinePreference}","dietary_preference":"${dietaryPreference}","halal_preference":"${halalPreference}"}

=== OUTPUT SCHEMA & STRICT RULES ===
RULES:
1. If the remaining macros are very low (e.g., < 200 calories), suggest small snacks. If they are large (e.g., > 600 calories), suggest full meals.
2. The nutritional values of each recipe MUST mathematically align as closely as physically possible with the remaining macros provided in the query.
3. If cuisine_preference is not 'Any', all recipes MUST strictly belong to the specified cuisine style.
4. If dietary_preference is 'Vegetarian', NO meat, poultry, or seafood is allowed.
5. If halal_preference is 'Halal', NO pork, alcohol, or non-halal meat byproducts are allowed.
6. Keep instructions concise (max 3-4 steps).
7. Keep ingredients to accessible, whole foods.
8. Mathematical Validation: For each recipe, (protein x 4) + (carbs x 4) + (fat x 9) MUST roughly equal its total calories.

Respond strictly in JSON array format:
[
  {
     "recipeName": "Creative Recipe Name",
     "description": "Short matching description of the meal.",
     "ingredients": ["100g Chicken Breast", "1 tbsp Olive Oil"],
     "instructions": ["Step 1: Prep", "Step 2: Cook"],
     "nutrition": {
         "calories": <Exact int>,
         "protein": <Exact int g>,
         "carbohydrates": <Exact int g>,
         "fat": <Exact int g>
     }
  },
  ... (2 more recipes)
]
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: prompt,
        });

        const data = this.extractJson(response.text);
        return { recipes: data };
    }

    async analyzeMealName({ mealName, grams }) {
        const prompt = `
=== TASK ===
Execute Request Type: Calculate Exact Nutritional Values for Custom Meal

=== CALCULATION DATA ===
{"meal_name":"${mealName}","total_grams_weight":"${grams}"}

=== OUTPUT SCHEMA & STRICT RULES ===
Calculate the mathematically exact nutritional values based strictly on the query data (meal name and total grams).

MATHEMATICAL CALCULATIONS:
1. Cross-reference the meal name against standard USDA nutritional database averages per 100g.
2. Scale the per-100g values mathematically to exactly match the requested total_grams_weight.
3. Rounding Rules: Round ALL final values mathematically to the nearest integer.
4. Validation Layer: Ensure (Protein x 4) + (Carbs x 4) + (Fat x 9) equals total Calories (±2% tolerance).

Respond strictly in JSON format without markdown wraps:
{
  "foodName": "Name of the food item",
  "nutrition": {
    "calories": <Exact Integer>,
    "carbohydrates": <Exact Integer>,
    "fat": <Exact Integer>,
    "protein": <Exact Integer>
  }
}
Do not include any other text, reasoning, or markdown blocks.
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: prompt,
        });

        return this.extractJson(response.text);
    }

    async analyzeFoodImage({ imageBase64 }) {
        const prompt = `
You are a state-of-the-art visual AI Nutritionist capable of high-precision object detection, portion volume estimation, and micro/macronutrient mathematics.
Analyze the food image provided and break down the visible food items into exact, scientifically accurate components. Act as an expert dietitian precisely logging macros.

Respond strictly in the following JSON format without any markdown wrappers, code blocks, or extra text:

{
  "label": {
    "meal_name": "Name of the overall meal",
    "food_name": "Name of the primary food item(s)",
    "estimated_quantity": {
      "amount": <Integer representing exact grams based on visual volume>,
      "unit": "g"
    },
    ... (Calculate exact carbohydrates, fat, fiber, sodium, saturated_fat, calories, protein mirroring the internal model structure)
      "value": <exact integer>,
      "dv_percentage": "<exact number>% DV",
      "health_impact": "Good health impact" | "Moderate health impact" | "Bad health impact"
  }
}

CRITICAL RULES FOR CALCULATION:
1. Volumetric Estimation: Do not guess blindly. Use visual cues to estimate the exact total mass in grams.
2. Exact Nutritional Linking: Cross-reference the estimated mass against standard USDA nutritional databases. Calculate the EXACT macros for that specific weight.
3. Macro Math Verification: Ensure that (Protein x 4) + (Carbs x 4) + (Fat x 9) approximately equals the total Calories.
4. JSON Integrity: Stringify the response perfectly. Do NOT add missing braces.
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: [
                prompt,
                { inlineData: { data: imageBase64, mimeType: "image/jpeg" } }
            ]
        });

        return this.extractJson(response.text);
    }

    async getHealthImpact({ scanned_nutrition }) {
        const prompt = `
=== TASK ===
Execute Request Type: Explain Health Impact & Daily Value (DV)

=== CALCULATION DATA ===
${JSON.stringify({ scanned_nutrition })}

=== OUTPUT SCHEMA & STRICT RULES ===
Analyze the query data and provide very short, deterministic information about the health impact of the exact DV percentages provided.

RULES:
1. If the food has no values (or 0), state exactly that it lacks this nutrient.
2. Make the health impact string extremely concise, deterministic, and consistent. Do not use flowery language.
3. Be strictly factual (e.g., "High saturated fat (>20% DV) increases LDL cholesterol risk" instead of "Oh this is so bad for your heart").

Respond strictly in JSON format without markdown wraps:
{
     "description": "Short description of the food item",
     "reason_of_carbs": "Carbohydrates Health impact explanation",
     "reason_of_fat": "Fat Health impact explanation",
     "reason_of_fiber": "Fiber Health impact explanation",
     "reason_of_calories": "Calories Health impact explanation",
     "reason_of_protein": "Protein Health impact explanation",
     "reason_of_sodium": "Sodium Health impact explanation",
     "reason_of_saturated_fat": "Saturated fat Health impact explanation"
}
Do not give any other information outside this JSON.
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: prompt,
        });

        return this.extractJson(response.text);
    }

    async recommendFoods({ analyzed_nutrition }) {
        const prompt = `
=== TASK ===
Execute Request Type: Suggest Complementary Foods based on Deficiencies

=== CALCULATION DATA ===
${JSON.stringify({ analyzed_nutrition })}

=== OUTPUT SCHEMA & STRICT RULES ===
Analyze the query data to mechanically identify which essential nutrients (Protein, Fiber, etc.) are lacking or disproportionately low compared to the others.

RULES:
1. Suggest exactly 3 real, culturally appropriate, accessible foods that mathematically balance the missing nutrients. No unrealistic or theoretical foods.
2. The foods must specifically compensate for the exact data gaps in the query.
3. Be deterministic. Do not append "Here are your foods...".

Respond strictly in JSON format without markdown wraps:
{
  "foodItems": [
    {
      "food_name": "Name of the food item",
      "description": "Short, factual description of exactly which missing nutrients this provides."
    }
  ]
}
Do not add any other keys. Avoid extra information.
`;

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: prompt,
        });

        return this.extractJson(response.text);
    }

    async chat({ message, history, foodContext }) {
        const lowerMessage = message.toLowerCase();

        
        let bestMatch = null;
        let highestScore = 0;

        for (const prompt of promptsData) {
            for (const keyword of prompt.keywords) {
                const score = stringSimilarity.compareTwoStrings(lowerMessage, keyword.toLowerCase());
                if (score > highestScore) {
                    highestScore = score;
                    bestMatch = prompt.response;
                }
            }
        }

        
        if (highestScore > 0.65 && bestMatch) {
            console.log(`[AI] JSON Match Found (Score: ${highestScore.toFixed(2)})`);
            return { reply: bestMatch };
        }

        
        const systemInstruction = `
You are SAM1-2 NutriCore, an elite health, fitness, and nutrition AI expert created and owned purely by Sami Malik. 
Your primary goal is to guide the user towards their health and dietary goals through evidence-based, scientifically accurate advice.

STRICT DOMAIN RULES:
1. You MUST ONLY answer questions strictly related to food, nutrition labels, diet, calories, macros, supplements, fitness, and biology.
2. IF THE USER ASKS ABOUT ANYTHING ELSE (e.g., coding, math, general chat, movies, politics), YOU MUST REFUSE TO ANSWER. Reply exactly with: "I am SAM1-2 NutriCore. I only answer questions related to food, nutrition labels, and health. Please ask me about nutrition!"
3. If they ask about your developer, creator, or owner, you must answer "Sami Malik".
4. If they ask about your model or version, you must answer "SAM1-2 NutriCore".
5. When explaining health concepts, be highly detailed, analytical, and scientifically sound.
6. When providing long meal plans, workout plans, or massive data dumps, ALWAYS chunk your responses. Provide Day 1 (or Chunk 1) first, and ask the user "Would you like me to continue with the next part?" Do not dump huge tables at once.
7. Address the user directly and validate their goals.

CURRENT MEMORY CONTEXT:
The user might have previously mentioned a food item or nutrition label recently. Here is what they are currently focused on (if anything):
${foodContext ? foodContext : "No active food context."}
`;

        
        const formattedHistory = (history || []).map(msg => ({
            role: msg.isUser ? 'user' : 'model',
            parts: [{ text: msg.text }]
        }));

        
        formattedHistory.push({
            role: 'user',
            parts: [{ text: message }]
        });

        const response = await ai.models.generateContent({
            model: MODEL_NAME,
            contents: formattedHistory,
            config: {
                systemInstruction: systemInstruction
            }
        });

        return { reply: response.text };
    }
}

module.exports = new AiService();
