import 'dart:convert';

import 'package:news_case2/model/article_response.dart';
import 'package:news_case2/model/source_response.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  static String apiKey = "";

  Future<SourceResponse> getSources() async {
    var params = {
      'authorization': 'apikey $apiKey',
      'content-type': 'application/json',
      'charset': 'utf-8',
    };

    try {
      var response = await http.get(
          Uri.parse("https://newsapi.org/v2/sources?country=us"),
          headers: params);
      return SourceResponse.fromJson(jsonDecode(response.body));
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print(error.toString() + " " + stacktrace.toString());
      return SourceResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {
      'authorization': 'apikey $apiKey',
      'content-type': 'application/json',
      'charset': 'utf-8',
    };

    try {
      var response = await http.get(
          Uri.parse("https://newsapi.org/v2/top-headlines?country=tr"),
          headers: params);
      return ArticleResponse.fromJson(jsonDecode(response.body));
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print(error.toString() + " " + stacktrace.toString());
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {
      'authorization': 'apikey $apiKey',
      'content-Type': 'application/json;charset=UTF-8',
      'charset': 'utf-8',
    };

    try {
      var response = await http.get(
          Uri.parse(
              "https://newsapi.org/v2/everything?q=apple&sortBy=popularity"),
          headers: params);

      return ArticleResponse.fromJson(jsonDecode(response.body));
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print(error.toString() + " " + stacktrace.toString());
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {
      'authorization': 'apikey $apiKey',
      'content-Type': 'application/json',
      'charset': 'utf-8',
    };

    try {
      var response = await http.get(
          Uri.parse("https://newsapi.org/v2/top-headlines?sources=$sourceId"),
          headers: params);
      return ArticleResponse.fromJson(jsonDecode(response.body));
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print(error.toString() + " " + stacktrace.toString());
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> search(String searchValue) async {
    var params = {
      'authorization': 'apikey $apiKey',
      'content-Type': 'application/json;charset=UTF-8',
      'charset': 'utf-8',
    };

    try {
      var response = await http.get(
          Uri.parse("https://newsapi.org/v2/top-headlines?q=$searchValue"),
          headers: params);
      return ArticleResponse.fromJson(jsonDecode(response.body));
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print(error.toString() + " " + stacktrace.toString());
      return ArticleResponse.withError(error.toString());
    }
  }
}
