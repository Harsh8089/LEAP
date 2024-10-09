import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/company_info/buy_sell.dart';
import 'package:leap/widgets/stock/company_info/stock_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Company extends StatefulWidget {
  final String companyName;
  final String scripId;

  const Company({super.key, required this.companyName, required this.scripId});

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  bool _showOrderBook = false;
  int shareCount = 0;
  double investedAmount = 0.0;
  double avgPrice = 0.0;
  double currValue = 0.0;

  Future<void> _getHoldingDetails() async {
      try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('userId');
          final uri = Uri.parse('${Server.url}/api/v1/stocks/get-share-count?userId=$userId&scripId=${widget.scripId}');
          final response = await http.get(uri);
          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            print(data);
            if(data['success']) {
                shareCount = data['shares'];
                investedAmount = data['investedAmount'];
                avgPrice = data['avgPrice']; 
                setState(() {});
            }
        } else {
            print(json.decode(response.body));
        }
      }
      catch(e) {
          print(e);
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
    final priceData = provider.prices[widget.scripId] ?? [];
    final lastPrice = priceData.isNotEmpty ? priceData.last : 0.0;
    
    currValue = lastPrice * shareCount;

    double percentageDiff = double.parse( (investedAmount != 0 
        ? ((currValue - investedAmount) / investedAmount) * 100 
        : 0.0).toStringAsFixed(2));
    
    bool isPositive = percentageDiff >= -0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              AppColors.lightBlue.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StockChart(
                        companyName: widget.companyName,
                        scripId: widget.scripId,
                      ),
                      const SizedBox(height: 16),

                      shareCount > 0 ?
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isPositive ? AppColors.lightGreen.withOpacity(0.2) : Colors.red.withOpacity(0.2), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' $shareCount Shares',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Avg. Price ₹${avgPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 219, 215, 215),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Current Value',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  '₹${currValue.toStringAsFixed(2)}',
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
                                        ? Colors.green.withOpacity(0.2)
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
                                        '${percentageDiff.abs().toStringAsFixed(2)}%',
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
                            ),
                          ],
                        ),
                      ) : Container(),


                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(43, 255, 255, 255),
                            ),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              _showOrderBook
                                  ? 'Order Book'
                                  : 'Performance Metrics',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _showOrderBook = expanded;
                              });
                            },
                            children: [
                              _showOrderBook
                                  ? OrderBook(scripId: widget.scripId)
                                  : PerformanceMetrics(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BuySell(
                  companyName: widget.companyName,
                  scripId: widget.scripId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderBook extends StatelessWidget {
  final String scripId;
  const OrderBook({super.key, required this.scripId});

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final stock = stockProvider.stocks.firstWhere(
      (s) => s.scripId == scripId,
      orElse: () => Stock(scripId: scripId), // Provide a default Stock
    );
    final bids = stock.bids;
    final asks = stock.asks;
    final totalBuyQuantity = stock.totalBuyQuantity;
    final totalSellQuantity = stock.totalSellQuantity;
    final buyingFraction = totalBuyQuantity == 0
        ? 0.3
        : totalBuyQuantity / (totalBuyQuantity + totalSellQuantity);
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Buy orders',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                ),
              ),
              Text(
                'Sell orders',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (buyingFraction * 100).toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                ((1 - buyingFraction) * 100).toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 250),
            tween: Tween<double>(end: buyingFraction),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                color: Colors.green,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bid price",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Qty",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...List.generate(5, (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bids[index][0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            bids[index][1].toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 144, 243, 147),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bid total",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          totalBuyQuantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(115, 70, 69, 69),
                  ),
                  height: 160,
                  width: 1.5,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ask price",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Qty",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...List.generate(5, (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            asks[index][0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            asks[index][1].toString(),
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ask total",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          totalSellQuantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PerformanceMetrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('This section will display performance metrics.'),
          // Add more performance metrics widgets here
        ],
      ),
    );
  }
}
