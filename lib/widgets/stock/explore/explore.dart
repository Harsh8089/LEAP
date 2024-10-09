import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Explore extends StatefulWidget {

  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final List<Map<String, dynamic>> trendingStocks = const [
    {"code": "543320", "name": "Zomato Limited", "price": 0.00, "change": 2.5},
    {
      "code": "500570",
      "name": "Tata Motors Ltd",
      "price": 0.00,
      "change": -1.2
    },
    {
      "code": "533096",
      "name": "Adani Power Limited",
      "price": 0.00,
      "change": 0.8
    },
    {
      "code": "532822",
      "name": "VODAFONE IDEA LIMITED",
      "price": 0.00,
      "change": 3.7
    },
  ];

  double totalInvestedAmount = 0.0;
  double totalValueofInvestStock = 0.0;
  Map<String, int> qtyMap = {};

  Future<void> _getInvestedAmount() async {
    try {
        totalInvestedAmount = 0.0;
        totalValueofInvestStock = 0.0;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        final uri = Uri.parse('${Server.url}/api/v1/stocks/holdings?userId=$userId');
        final response = await http.get(uri);
        if (response.statusCode == 200) {
            print(json.decode(response.body));
            final Map<String, dynamic> data = json.decode(response.body);
            if (data['success']) {
                Map<String, dynamic> holdings = data['holdings'];
                holdings.forEach((scripId, holdingData) {
                    totalInvestedAmount += holdingData['investedAmount'];
                    qtyMap[scripId] = holdingData['qty'];
                });
                print("Total Invested Amount: \$${totalInvestedAmount}");
                print("Quantity Map: $qtyMap");
                setState(() {});
            }
        } else {
            print(json.decode(response.body));
        }
    } catch (e) {
        print(e);
    }
}


  @override
  void initState() {
      super.initState();
      _getInvestedAmount();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    totalValueofInvestStock = 0.0; 
    qtyMap.forEach((scripId, qty) {
      final priceData = provider.prices[scripId] ?? [];
      totalValueofInvestStock += (priceData.isNotEmpty ? priceData.last : 0.0) * qty;
    });
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPortfolioSection(context, totalInvestedAmount, totalValueofInvestStock),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Text(
                      'Trending Stocks',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Icon(Icons.trending_up),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            _buildTrendingStocksGrid(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingStocksGrid(
    BuildContext context, StockProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: trendingStocks.length,
      itemBuilder: (context, index) {
        return _buildStockCard(trendingStocks[index], context, provider);
      },
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock, BuildContext context,
      StockProvider provider) {
    double openPrice = provider.prices[stock['code']]?.first ?? 0.0;
    double currPrice = provider.prices[stock['code']]?.last ?? 0.0;
    final percentageChange = (((currPrice - openPrice) / openPrice) * 100.0);

    bool isPositive = currPrice >= openPrice;
    Color changeColor = isPositive ? AppColors.lightGreen : Colors.red;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkBlue,
            AppColors.darkBlue.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: changeColor.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stock['code'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${provider.prices[stock['code']]?.last.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: changeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: changeColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${percentageChange.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: changeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSection(BuildContext context, double totalInvestedAmount, double totalValueofInvestStock) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.lightBlue,
              AppColors.darkBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Portfolio',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildPortfolioItem('Current Value', totalValueofInvestStock.toStringAsFixed(2), 0.1, true),
            const SizedBox(height: 12.0),
            _buildPortfolioItem('Invested Amount', totalInvestedAmount.toStringAsFixed(2), 0.1, false),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(String label, String value, double growth, bool displayGrowth) {
    double percentageDiff = (totalInvestedAmount == 0.0) ? 0.0 : double.parse((((totalValueofInvestStock - totalInvestedAmount) / totalInvestedAmount) * 100).toStringAsFixed(2));     
    if(percentageDiff == -0.0) percentageDiff = 0.0;
    bool isPositive = percentageDiff >= 0.0 ? true : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/vc.png',
                  width: 40,
                  height: 40,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            displayGrowth
                ? Container(
                    padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive ? AppColors.lightGreen.withOpacity(0.2) : AppColors.lightRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isPositive ? AppColors.lightGreen : AppColors.lightRed,
                          width: 1
                      )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon( isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ?  AppColors.lightGreen : AppColors.lightRed, size: 14,),
                        const SizedBox(width: 4),
                        Text(
                          '${percentageDiff.toStringAsFixed(2)} %',
                          style: TextStyle(
                            fontSize: 14,
                            color: isPositive ? AppColors.lightGreen : AppColors.lightRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
