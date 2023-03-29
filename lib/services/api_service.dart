import 'package:toonflix/model/webtoon_detail_model.dart';
import 'package:toonflix/model/webtoon_episode_model.dart';
import 'package:toonflix/model/webtoon_model.dart';
import 'package:toonflix/services/auth_dio.dart';

class ApiService {
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    var dio = await authDio();
    final response = await dio.get('/webtoon/$today');
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = response.data;
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    var dio = await authDio();
    final response = await dio.get('/webtoon/detail/$id');
    if (response.statusCode == 200) {
      final webtoon = response.data;
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatesEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    var dio = await authDio();
    final response = await dio.get('/webtoon/$id/episodes');
    if (response.statusCode == 200) {
      final episodes = response.data;
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
