import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/company_logo.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/holdings/order_history.dart';

class HoldingDetailsofCompany extends StatefulWidget {
  final String stockCode;
  final String companyName;
  final double investedAmount;
  final double avgPrice;
  final int shares;
  final StockProvider stockProvider;

  HoldingDetailsofCompany({
    Key? key,
    required this.stockCode,
    required this.companyName,
    required this.investedAmount,
    required this.avgPrice,
    required this.shares,
    required this.stockProvider
  }) : super(key: key);

  @override
  State<HoldingDetailsofCompany> createState() => _HoldingDetailsofCompanyState();
}

class _HoldingDetailsofCompanyState extends State<HoldingDetailsofCompany> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Holding Details',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailContainer(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OrderHistory(scripId: widget.stockCode)
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
                  'Check Order History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentValue() {
    var prices = widget.stockProvider.prices;
    var stockCode = widget.stockCode;
    if (prices.containsKey(stockCode) && prices[stockCode] != null && prices[stockCode]!.isNotEmpty) {
      return (prices[stockCode]!.last * widget.shares).toStringAsFixed(2);
    }
    return "N/A";
  }
  

  Widget _buildDetailContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkBlue.withOpacity(0.1),
            AppColors.darkBlue.withOpacity(0.3),
          ],
      ),
        
        border: Border.all(color: checkPositive() ? AppColors.lightGreen.withOpacity(0.2) : Colors.red.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  _buildLogo(),
                  _buildMockPriceInfo(widget.avgPrice, widget.stockCode, widget.stockProvider, widget.shares)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
                  widget.companyName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
            const SizedBox(height: 8),
            Text(
              widget.stockCode,
              style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Current Value', _getCurrentValue()),
            _buildDetailRow('Total Invested', widget.investedAmount.toStringAsFixed(2)),
            _buildDetailRow('Avg Price', widget.avgPrice.toStringAsFixed(2)),
            _buildDetailRow('Shares', widget.shares.toString()),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    String? logoUrl = companyLogo[int.parse(widget.stockCode)];
    if(logoUrl != null) {
      return Image.network(
        logoUrl,
        width: 60,
        height: 60,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderLogo(),
      );
    } 
    else return _buildPlaceholderLogo();
  }

   Widget _buildPlaceholderLogo() {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.companyName.substring(0, 1).toUpperCase(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Row(
            children: <Widget>[
                label != 'Shares' ? 
                Image.asset(
                  'assets/vc.png',
                  // fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                ): Container(),
                const SizedBox(width: 5.0,),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  bool checkPositive() {
      double currPrice = widget.stockProvider.prices[widget.stockCode]?.last ?? 0.0;
      double percentageChange = double.parse((((currPrice - widget.avgPrice) / widget.avgPrice) * 100.0).toStringAsFixed(2));
      return currPrice >= widget.avgPrice || percentageChange >= 0.0;
  }

  Widget _buildMockPriceInfo(double avgPrice, String stockCode, StockProvider provider, int shares) {
    double currPrice = provider.prices[stockCode]?.last ?? 0.0;
    double percentageChange = double.parse((((currPrice - avgPrice) / avgPrice) * 100.0).toStringAsFixed(2));
    if(percentageChange == -0.0) percentageChange = 0.0;
    
    final isPositive = checkPositive() || percentageChange >= 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            size: 15,
          ),
          const SizedBox(width: 2),
          Text(
            '${percentageChange.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 15,
              color: isPositive ? AppColors.lightGreen : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}