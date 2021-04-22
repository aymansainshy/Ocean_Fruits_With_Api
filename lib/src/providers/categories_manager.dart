import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';

final dioOptions = BaseOptions(
  baseUrl: 'https://veget.ocean-sudan.com/api/',
  connectTimeout: 5000,
  headers: {
    'content-type': 'application/json',
    'Accept': 'application/json',
  },
);
Dio _dio = Dio(dioOptions);

class CategoriesManager with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => [..._categories];

  Future<void> fetchCategories() async {
    try {
      final response = await _dio.get('/catogry');
      final responseData = response.data["catogry"] as List<dynamic>;
      final List<Category> responseList =
          responseData.map((cat) => Category.fromJson(cat)).toList();
      _categories = responseList;
      print(_categories.toString());
      notifyListeners();
    } catch (e) {
      // print("Errror " + e.toString());
      throw e.toString();
    }
  }
}
