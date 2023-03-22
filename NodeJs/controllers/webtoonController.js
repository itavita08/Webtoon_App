const axios = require('axios');

const getWebtoonsByDay = async (req, res) => {
  try {
    const day = req.params.day;
    const response = await axios.get(`https://webtoon-crawler.nomadcoders.workers.dev/${day}`);
    const data = response.data;
    var list = [];

    for( i in data){
        list.push({
            "title" : data[i]['title'],
            "id" : data[i]['id'],
            "thumb" : data[i]['thumb']});
    }

    res.json(list);
  } catch (error) {
    console.error(error);
    res.status(500).send('Failed to load webtoons');
  }
};

const getWebtoonById = async (req, res) => {
  try {
    const id = req.params.id;
    const response = await axios.get(`https://webtoon-crawler.nomadcoders.workers.dev/${id}`);
    const data = response.data;

    res.json({
        'title' : data['title'],
        'about' : data['about'],
        'genre' : data['genre'],
        'age' : data['age']
    });
  } catch (error) {
    console.error(error);
    res.status(500).send('Failed to load webtoon');
  }
};

const getWebtoonByEpisode = async (req, res) => {
    try {
      const id = req.params.id;
      const response = await axios.get(`https://webtoon-crawler.nomadcoders.workers.dev/${id}/episodes`);
      const data = response.data;
      var list = [];

      for( i in data){
        list.push({
            'id' : data[i]['id'],
            'title' : data[i]['title'],
            'rating' : data[i]['rating'],
            'date' : data[i]['date']
        });
    }

    res.json(list);
    } catch (error) {
      console.error(error);
      res.status(500).send('Failed to load webtoon');
    }
  };

module.exports = { getWebtoonsByDay, getWebtoonById, getWebtoonByEpisode };
