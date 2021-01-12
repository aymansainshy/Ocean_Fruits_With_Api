import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String userId;
  String userName;
  String userAddress;
  String userPhone;
  String userEmail;
  String _userPassword;
  String _userToken;
  String imageUrl;

  bool get isAuth {
    print('Rebuilding ............');
    print("Tookeeeeeeeeeeeeeeeen is " + userId.toString());
    return userId != null;
    // return _userToken != null;
  }

  String get password {
    return _userPassword;
  }

  Future<void> _authenticat(String urls, Map<String, dynamic> data) async {
    Dio dio = Dio();
    final url = urls;
    try {
      final response = await dio.post(
        url,
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: data,
      );

      print("Response Date.... " + response.toString());
      print("ResponseStatusCode .... " + response.statusCode.toString());

      final responseData = response.data as Map<String, dynamic>;

      userId = responseData["id"].toString();
      userName = responseData["name"];
      userAddress = responseData["address"];
      userEmail = responseData["email"];
      userPhone = responseData["phone"].toString();
      // _userToken = responseData["remember_token"];
      // _userPassword = responseData["password"];
      // imageUrl = responseData["image_url"] == null
      //     ? ""
      //     : 'http://veget.ocean-sudan.com/api/' +
      //         responseData["image_url"];
      notifyListeners();

      /// [*] Storing data after logIn.... for [Auto log in] .......
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "userId": responseData["id"].toString(),
        "userName": responseData["name"],
        "userAddress": responseData["address"],
        "userEmail": responseData["email"],
        "userPhone": responseData["phone"].toString(),
        // "userToken": responseData["remember_token"],
        // "userPassword": responseData["password"],
        // "imageUrl": responseData["image_url"] == null
        //     ? ""
        //     : 'http://veget.ocean-sudan.com/api/' +
        //         responseData["image_url"],
      });
      prefs.setString('userData', userData);
    } on DioError catch (e) {
      print("Catch Dio error " + e.response.data['code'].toString());
      throw HttpException(e.response.data['code'].toString());
    } catch (e) {
      print("Catch " + e.toString());
      throw e.toString();
    }
  }

  Future<void> register(String name, String address, String phone, String email,
      String password) async {
    final url = 'http://veget.ocean-sudan.com/api/user/';
    var data = {
      "name": name,
      "password": password,
      "address": address,
      "phone": phone,
      "email": email
    };

    return _authenticat(url, data);
  }

  Future<void> login(String email, String password) async {
    final url = 'http://veget.ocean-sudan.com/api/user/login';
    var data = {
      "email": email,
      "password": password,
    };

    return _authenticat(url, data);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final _userData =
        json.decode(prefs.getString("userData")) as Map<String, dynamic>;
    userId = _userData["userId"];
    userName = _userData["userName"];
    userAddress = _userData["userAddress"];
    userEmail = _userData["userEmail"];
    userPhone = _userData["userPhone"];
    // _userPassword = _userData["userPassword"];
    // imageUrl = _userData["imageUrl"];
    // _userToken = _userData["userToken"];
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _userToken = null;
    userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  Future<void> updataUser({
    @required String userId,
    @required String userName,
    @required String userEmail,
    @required String userPassword,
    @required String userAddress,
    @required String userPhone,
    File image,
  }) async {
    Dio dio = Dio();
    final url = 'http://backend.bdcafrica.site/api/user/$userId/';

    Map<String, dynamic> data = {
      "name": userName,
      "email": userEmail,
      "address": userAddress,
      "phone": userPhone,
      "password": userPassword,
    };

    try {
      final response = await dio.put(
        url,
        data: jsonEncode(data),
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (image != null) {
        await uploadImage(image, userId);
      }

      final responseData = response.data as Map<String, dynamic>;

      /// [*] Storing data after logIn.... for [Auto log in] .......
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("userData")) {
        return;
      }
      // prefs.remove("userData");
      final _userData =
          json.decode(prefs.getString("userData")) as Map<String, dynamic>;
      final userData = json.encode({
        "userId": responseData["id"].toString(),
        "userName": responseData["name"],
        "userAddress": responseData["address"],
        "userEmail": responseData["email"],
        "userPassword": responseData["password"],
        "userPhone": responseData["phone"].toString(),
        "userToken": responseData["remember_token"],
        "imageUrl": _userData['imageUrl'],
        //  responseData["image_url"] == null
        //     ? ""
        //     : 'http://backend.bdcafrica.site/images/' +
        //         responseData["image_url"],
      });
      prefs.setString("userData", userData);
      await tryAutoLogin();
    } on DioError catch (e) {
      throw HttpException(e.response.data['code'].toString());
    } catch (e) {
      throw e;
    }
  }

  Future<void> uploadImage(File image, String userId) async {
    Dio dio = Dio();
    final url = 'http://backend.bdcafrica.site/api/user/$userId/imageUpdate';
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image_url": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'multipart/form-data',
            'Accept': '*/*',
          },
        ),
      );
      final responseData = response.data as Map<String, dynamic>;

      /// [*] Storing data after logIn.... for [Auto log in] .......
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("userData")) {
        return;
      }
      prefs.remove("userData");
      final userData = json.encode({
        "userId": responseData["id"].toString(),
        "userName": responseData["name"],
        "userAddress": responseData["address"],
        "userEmail": responseData["email"],
        "userPassword": responseData["password"],
        "userPhone": responseData["phone"].toString(),
        "userToken": responseData["remember_token"],
        "imageUrl": responseData["image_url"] == null
            ? ""
            : 'http://backend.bdcafrica.site/images/' +
                responseData["image_url"],
      });
      prefs.setString("userData", userData);
      await tryAutoLogin();
    } on DioError catch (e) {
      throw HttpException(e.response.data['code'].toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> forgetPassword(String email) async {
    Dio dio = Dio();
    final url = 'http://backend.bdcafrica.site/api/user/forgetpassword';
    try {
      final response = await dio.post(
        url,
        data: jsonEncode(email),
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("Response Data .........." + response.data.toString());
      print("Response Stause Code .........." + response.statusCode.toString());
      print("Response Message .......... " + response.statusMessage.toString());
    } on DioError catch (e) {
      print("Catch E " + e.toString());
    }
  }
}
