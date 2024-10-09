import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leap/consts/server.dart';
import 'package:leap/widgets/fd/fd_plans.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> bookFd(double interestRate, Date duration, double amount) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String userId = prefs.getString('userId') ?? '';
  if (userId == '') {
    return -1;
  }
  if (amount > (prefs.getDouble("coins") ?? 0.0)) {
    return 0;
  }
  final response = await http.post(
    Uri.parse("${Server.url}/api/v1/fd/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      {
        "userId": userId,
        "amount": amount,
        "interest": interestRate,
        "duration": {
          "year": duration.year,
          "month": duration.month,
        },
      },
    ),
  );
  if (response.statusCode == 200) {
    prefs.setDouble("coins", prefs.getDouble("coins")! - amount);
    return 1;
  } else {
    return 2;
  }
}

Future<dynamic> getFd() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("userId");
  final response = await http.post(
    Uri.parse("${Server.url}/api/v1/fd/list"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({"userId": userId}),
  );
  final content = jsonDecode(response.body);
  print(content["documents"]);
  return content["documents"];
}
