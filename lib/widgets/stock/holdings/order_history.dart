import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leap/consts/server.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  final String scripId;

  OrderHistory({super.key, required this.scripId});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Map<String, dynamic>> transactions = [];


  Future<void> _getTransactionRecords() async {
      try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('userId') ?? '';
          
          final uri = '${Server.url}/api/v1/stocks/get-holdings-of-scripid?userId=$userId&scripId=${widget.scripId}';
          final response = await http.get(Uri.parse(uri));
          if(response.statusCode == 200) {
            final data = json.decode(response.body);
            print(data);
            if (data['success'] == true) {
              setState(() {
                transactions = List<Map<String, dynamic>>.from(data['transactions']);
              });
            }
        } else {
          print('Failed to load holdings');
        }
      }
      catch(e) {
          print(e);
      }
  }

  @override
  void initState() {
      super.initState();
      _getTransactionRecords();
  }

  String _formatTime(String timestamp) {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
  }

  String _formatDate(String timestamp) {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Order History',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              AppColors.lightBlue.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: transactions.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final txn = transactions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: AppColors.darkBlue.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                            color: txn['transactionType'] == 'buy' ? AppColors.lightGreen.withOpacity(0.1) : Colors.red.withOpacity(0.2),
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_formatDate(txn['timestamp'])} | ${_formatTime(txn['timestamp'])}',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                _buildTransactionTypeBadge(txn['transactionType']),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'ID: ${txn['_id'].toString().substring(0, 15)}...',
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Qty: ${txn['qty']}',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹${txn['atPrice']}',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeBadge(String type) {
    Color badgeColor = type.toLowerCase() == 'buy' ? AppColors.lightGreen : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}