import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BuyScreen extends StatefulWidget {
  final String companyName;
  final String scripId;

  const BuyScreen({
    super.key,
    required this.companyName,
    required this.scripId,
  });

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final TextEditingController _qtyController = TextEditingController();

  Future<void> _buy(double lastPrice) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Buying"),
            ],
          ),
        );
      },
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    const uri = '${Server.url}/api/v1/stocks/buy';
    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "userId": userId,
        "scripId": widget.scripId,
        "companyName": widget.companyName,
        "qty": _qtyController.text,
        "purchasedAt": lastPrice.toString(), // Convert double to String
      }),
    );

    Navigator.of(context).pop(); // Close the dialog

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock bought successfully!')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to buy stock.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final priceData = provider.prices[widget.scripId] ?? [];
    final lastPrice = priceData.isNotEmpty ? priceData.last : 0.0;
    final startPrice = priceData.isNotEmpty ? priceData.first : 0.0;

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
              AppColors.lightBlue.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      widget.companyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.scripId,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    _buildPriceContainer(lastPrice, startPrice),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        _buildActionButton('At Market', AppColors.lightBlue),
                        SizedBox(width: 10),
                        _buildActionButton('NSE', AppColors.lightBlue),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Enter Quantity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildQuantityInput(),
                  ]),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Order will be executed at best price in market.',
                        style: TextStyle(color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      _buildBalanceContainer(),
                      SizedBox(height: 20),
                      _buildBuyButton(lastPrice),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceContainer(double lastPrice, double startPrice) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Price',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                '₹ ${lastPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildPriceChangeIndicator(lastPrice, startPrice),
        ],
      ),
    );
  }

  Widget _buildQuantityInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightBlue, width: 1.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: _qtyController,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Quantity',
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildBalanceContainer() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your Current Balance',
            style: TextStyle(color: Colors.grey[400]),
          ),
          Text(
            '₹3,827',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(double lastPrice) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _buy(lastPrice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightGreen,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Buy Now',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildPriceChangeIndicator(double lastPrice, double startPrice) {
    bool isPositive = lastPrice >= startPrice;
    double percentageChange = (lastPrice - startPrice) / startPrice * 100.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.green : Colors.red,
            size: 16,
          ),
          SizedBox(width: 5),
          Text(
            '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(2)}',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
