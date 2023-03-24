import 'dart:convert';

import 'package:toonflix/model/webtoon_detail_model.dart';
import 'package:toonflix/model/webtoon_episode_model.dart';
import 'package:toonflix/model/webtoon_model.dart';
import 'package:toonflix/services/jwt_service.dart';

class ApiService {
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    // static Future<List<dynamic>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final response = await dio.get('/$today');
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.data);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel(webtoon));
      }
      return webtoonInstances;
      // return webtoons;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final response = await dio.get('/detail/$id');
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.data);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatesEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final response = await dio.get('/$id/episodes');
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.data);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
