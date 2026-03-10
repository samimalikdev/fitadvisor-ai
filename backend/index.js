require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./db/connection');

const app = express();
const PORT = process.env.PORT || 5000;


app.use(cors());
app.use(express.json());


connectDB();


const profileRoutes = require('./routes/profile');
const aiRoutes = require('./routes/ai');
const authRoutes = require('./routes/auth');
const historyRoutes = require('./routes/history');


app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/history', historyRoutes);


app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
