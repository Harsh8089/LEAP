import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/widgets/fd/home.dart';
import 'package:leap/widgets/stock/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvestHomeScreen extends StatefulWidget {
  const InvestHomeScreen({super.key});

  @override
  State<InvestHomeScreen> createState() => _InvestHomeScreenState();
}

class _InvestHomeScreenState extends State<InvestHomeScreen> {
  double totalInvestedAmountinStockMarket = 0.0;
  double totalInvestedAmountinFD = 0.0;

  Future<void> _getTotalInvestAmount() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      var uri = Uri.parse(
          '${Server.url}/api/v1/stocks/get-total-invested-amount?userId=$userId');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        totalInvestedAmountinStockMarket = (data['totalInvestedAmount'] is int)
            ? (data['totalInvestedAmount'] as int).toDouble()
            : double.parse(data['totalInvestedAmount'].toString());
      }
      uri = Uri.parse(
          '${Server.url}/api/v1/fd/get-total-investment-value?userId=$userId');
      response = await http.get(uri);
      if (response.statusCode == 200) {
        final content = jsonDecode(response.body);
        totalInvestedAmountinFD = content["totalInvestmentValue"];
      }
      setState(() {});
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getTotalInvestAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Invest & Grow',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Your path to financial freedom starts here',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Container(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Select Your Investment Option',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                  children: <Widget>[
                    _buildInvestmentOption(
                      context,
                      'Stock Market',
                      Icons.show_chart,
                      AppColors.lightBlue,
                      'High risk, high reward',
                    ),
                    _buildInvestmentOption(
                      context,
                      'Fixed Deposit',
                      Icons.account_balance,
                      AppColors.lightBlue,
                      'Low risk, stable returns',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.lightGreen.withOpacity(0.5), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Your Total Investment',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/vc.png',
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          (totalInvestedAmountinStockMarket +
                                  totalInvestedAmountinFD)
                              .toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvestmentOption(BuildContext context, String title,
      IconData icon, Color color, String subtitle) {
    return GestureDetector(
      onTap: () {
        if (title == "Stock Market") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else if (title == "Fixed Deposit") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FDHome()));
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 0.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.lightGreen),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style:
                  TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
