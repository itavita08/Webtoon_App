const express = require('express');
const app = express();
const cors = require('cors');
const webtoonRoutes = require('./routes/routes');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

app.use('/', webtoonRoutes);

app.listen(3000, () => {
  console.log('Server started on port 3000');
});