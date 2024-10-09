import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leap/consts/server.dart';
import 'package:leap/utils/authentication_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Future<http.Response?> loginUser(String mobile, String password) async {
    try {
      password = sha256.convert(utf8.encode(password)).toString();
      print(Server.url);
      final response =
          await http.post(Uri.parse('${Server.url}/api/v1/users/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"mobile": mobile, "password": password}));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> signUp(
      String username, String mobile, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Server.url}/api/v1/users/register'),
        body: jsonEncode(
          <String, String>{
            "username": username,
            "mobile": mobile,
            "password": sha256
                .convert(
                  utf8.encode(password),
                )
                .toString(),
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // save state of user upon login
  Future<void> saveLoginState(
      String userId, String username, double coins) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('username', username);
    await prefs.setDouble('coins', coins);
    print("User saved in shared prefences: $userId, $username, $coins");
  }

  Future<Map<String, dynamic>> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('username');
    double? coins = prefs.getDouble('coins');
    return {'userId': userId, 'userName': userName, 'coins': coins};
  }

  // logout
  Future<bool> logOut() async {
    logOutFromFirebase();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('coins');
    return true;
  }

  // Future<double> getBalance() async {
  //     final userState = await getLoginState();
  //     try {
  //         final response = await http.post(
  //             Uri.parse('${Server.url}/api/v1/users/'),
  //             body: jsonEncode(
  //               <String, String>{

  //               },
  //             ),
  //             headers: <String, String>{
  //               'Content-Type': 'application/json; charset=UTF-8',
  //             },
  //         );
  //         return response;
  //     }
  //     catch (e) {
  //         print(e);
  //     }
  //     return 2.0;
  // }
}
