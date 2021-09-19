// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart';

class HealthNewsApi {
  Future<List> getHealthNews() async {
    try {
      var url = Uri.parse('https://gnews.io/api/v4/top-headlines?token=cfd02c6ee875fdf60fabbf7f0c1d4d40&country=us&lang=en&topic=health');
      var response = await get(url);
      Map data = jsonDecode(response.body);
      return data['articles'];
    } catch (e) {
      print(e.toString());
    } 
  }
}