import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/stock/company_info/buy_screen.dart';
import 'package:leap/widgets/stock/company_info/sell_screen.dart';

class BuySell extends StatefulWidget {
  final String companyName;
  final String scripId;

  const BuySell({super.key, required this.companyName, required this.scripId});

  @override
  State<BuySell> createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55), 
                backgroundColor: AppColors.lightGreen,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                // Buy logic
                Navigator.push(context, MaterialPageRoute(builder: (context) => BuyScreen(scripId: widget.scripId, companyName: widget.companyName)));
              }, 
              child: const Text(
                'Buy',
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              )
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55), 
                backgroundColor: AppColors.lightRed,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                // Sell logic
                Navigator.push(context, MaterialPageRoute(builder: (context) => SellScreen(scripId: widget.scripId, companyName: widget.companyName)));
              }, 
              child: const Text(
                'Sell',
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              )
            ),
          )
        ],        
      ),
    );
  }
}