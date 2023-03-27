const express = require('express');
const app = express();
const cors = require('cors');
const webtoonRoutes = require('./routes/webtoonRoutes');
const userRoutes = require('./routes/userRoutes');
const jwt = require('./middlewares/jwt');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

app.use('/webtoon', webtoonRoutes);
app.use('/user', userRoutes);
app.use('/refresh', jwt.authenticateRefreshToken);

app.listen(3000, () => {
  console.log('Server started on port 3000');
});