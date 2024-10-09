import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/companies.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/holdings/holding_details.dart';
import 'package:leap/widgets/stock/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Holdings extends StatefulWidget {
  const Holdings({super.key});

  @override
  State<Holdings> createState() => _HoldingsState();
}

class _HoldingsState extends State<Holdings> {
  Map<String, dynamic>? holdings;

  // Reverse the companies map to easily access company names by their code
  final Map<String, String> reversedCompaniesMap = Map.fromEntries(
    companies.entries.map((entry) => MapEntry(entry.value.toString(), entry.key))
  );

  Future<String> _getUserDetailsFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? ''; // Fallback to empty string if null
  }

  Future<void> _getHoldingDetails() async {
    String userId = await _getUserDetailsFromSharedPreferences();
    final uri = '${Server.url}/api/v1/stocks/holdings?userId=$userId';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['success'] == true) {
        setState(() {
          holdings = Map<String, dynamic>.from(data['holdings']);
        });
      }
    } else if(response.statusCode == 404) {
      print(json.decode(response.body));
      setState(() {
          holdings = {};  
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getHoldingDetails();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);

    return Container(
      child: holdings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                    children: <Widget>[
                        const Text(
                          'Your Holdings',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        const SizedBox(width: 5.0,),
                        Text(
                          '(${holdings!.length})',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),  
                        )
                    ],
                ),
                const SizedBox(height: 16),

                holdings!.length == 0 ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                         Spacer(),
                         Container(
                            padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                            decoration: BoxDecoration(
                                color: AppColors.lightRed.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: AppColors.lightRed.withOpacity(0.5), 
                                  width: 1.0, 
                                ),
                            ),
                            child:  const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                    Icon(
                                      Icons.info,
                                      color: AppColors.lightRed, 
                                      size: 25, 
                                    ),
                                    const SizedBox(width: 10.0,),
                                    Text(
                                    "You Haven't Invested in Shares",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),  
                                  ),
                                ]
                              ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => Home(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Explore and Invest',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ): 
                  Column(
                      children: holdings!.entries.map((entry) {
                        final companyName = reversedCompaniesMap[entry.key] ?? "Unknown Company";
                        final holdingData = entry.value as Map<String, dynamic>;
                        return _buildHoldingCard(
                          context, 
                          companyName, 
                          holdingData['qty'] as int, 
                          entry.key, 
                          provider,
                          (holdingData['investedAmount'] as num).toDouble(),
                          (holdingData['avgPrice'] as num).toDouble()
                        );
                      }).toList(),
                  )
              ],
            ),
    );
  }

  String _truncateCompanyName(String name, int maxLength) {
    if (name.length > maxLength) return '${name.substring(0, maxLength)}...';
    return name;
  }

  Widget _buildHoldingCard(BuildContext context, String companyName, int shares, String stockCode, StockProvider provider, double investedAmount, double avgPrice) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HoldingDetailsofCompany(stockCode: stockCode, companyName: companyName, investedAmount: investedAmount, avgPrice: avgPrice, shares: shares, stockProvider: provider)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBlue,
              AppColors.darkBlue.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _truncateCompanyName(companyName, 14),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$shares ${shares == 1 ? "share" : "shares"} • Avg ₹${avgPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            _buildMockPriceInfo(avgPrice, stockCode, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildMockPriceInfo(double avgPrice, String stockCode, StockProvider provider) {
    double currPrice = provider.prices[stockCode]?.last ?? 0.0;
    double percentageChange = double.parse((((currPrice - avgPrice) / avgPrice) * 100.0).toStringAsFixed(2));

    final isPositive = currPrice >= avgPrice || percentageChange >= -0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '₹${currPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.lightGreen.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? AppColors.lightGreen : Colors.red,
                size: 10,
              ),
              const SizedBox(width: 2),
              Text(
                '${percentageChange.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 10,
                  color: isPositive ? AppColors.lightGreen : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}