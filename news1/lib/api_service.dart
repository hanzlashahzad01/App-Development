import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'news_model.dart';

class ApiService {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  static const String _apiKey = 'c4cc42bc45604ac18366f708c6aaa832'; // Get from newsapi.org
  static const String _headlines = 'top-headlines?country=us';

  Future<List<Article>> getTopHeadlines({required String category}) async {
    final response = await http.get(Uri.parse('$_baseUrl$_headlines&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}