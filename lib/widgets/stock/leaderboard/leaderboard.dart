import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/consts/server.dart';
import 'package:http/http.dart' as http;
import 'package:leap/providers/StockProvider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UserInvestment {
  final String userId;
  final String username;
  final double investedAmount;
  final double currentValue;
  final double percentageDiff;
  final Map<String, dynamic> investments;

  UserInvestment({
    required this.userId,
    required this.username,
    required this.investedAmount,
    required this.currentValue,
    required this.percentageDiff,
    required this.investments,
  });
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<UserInvestment> userInvestments = [];
  Timer? _timer;
  String lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _initLeaderBoard();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _initLeaderBoard();
    });
  }

  Future<void> _initLeaderBoard() async {
    try {
      final uri = Uri.parse('${Server.url}/api/v1/stocks/get-share-holdings-of-users');
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          List<UserInvestment> newInvestments = [];
        
          List<Map<String, dynamic>> userDetails = List<Map<String, dynamic>>.from(data['investmentDetails']);
          
          for (var user in userDetails) {
            String userId = user['userId'];
            String username = user['username'];
            double investedAmount = (user['investedAmount'] is int) ? (user['investedAmount'] as int).toDouble() : user['investedAmount'].toDouble();
            Map<String, dynamic> investments = user['investments'];
            double currValue = 0.0;

            investments.forEach((scripId, details) {
              double qty = (details['qty'] is int) ? (details['qty'] as int).toDouble() : details['qty'].toDouble();
              final provider = Provider.of<StockProvider>(context, listen: false);
              final priceData = provider.prices[scripId] ?? [];
              final lastPrice = priceData.isNotEmpty ? priceData.last : 0.0;
              currValue += lastPrice * qty;
            });

            double percentageDiff = double.parse((((currValue - investedAmount) / investedAmount) * 100).toStringAsFixed(2));

            newInvestments.add(UserInvestment(
              userId: userId,
              username: username,
              investedAmount: investedAmount,
              currentValue: currValue,
              investments: investments,
              percentageDiff: percentageDiff
            ));
          }

          newInvestments.sort((a, b) => b.percentageDiff.compareTo(a.percentageDiff));

          setState(() {
            userInvestments = newInvestments;
            lastUpdated = DateFormat('HH:mm:ss').format(DateTime.now());
          });
        }
      } else {
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Trading Performers',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Last updated: $lastUpdated',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: ListView.builder(
              itemCount: userInvestments.length,
              itemBuilder: (context, index) {
                final userInvestment = userInvestments[index];
                final isTopThree = index < 3;

                return Card(
                  color: AppColors.darkBlue.withOpacity(0.8),
                  elevation: isTopThree ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _buildLeadingWidget(index),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            userInvestment.username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isTopThree ? _getColorForRank(index) : Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              userInvestment.percentageDiff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                              color: userInvestment.percentageDiff >= 0 ? AppColors.lightGreen : AppColors.lightRed,
                              size: 16.0,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${userInvestment.percentageDiff.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: userInvestment.percentageDiff >= 0 ? AppColors.lightGreen : AppColors.lightRed,
                              ),
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
        ],
      ),
    );
  }

  Widget _buildLeadingWidget(int index) {
    switch (index) {
      case 0:
        return _buildTrophy(FontAwesomeIcons.trophy, const Color.fromARGB(255, 251, 199, 42));
      case 1:
        return _buildTrophy(FontAwesomeIcons.trophy, Colors.grey[300]!);
      case 2:
        return _buildTrophy(FontAwesomeIcons.trophy, const Color.fromARGB(255, 208, 154, 134));
      default:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: AppColors.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildTrophy(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: FaIcon(icon, color: color, size: 24),
    );
  }

  Color _getColorForRank(int index) {
    switch (index) {
      case 0:
        return Color.fromARGB(255, 251, 199, 42);
      case 1:
        return Colors.grey[300]!;
      case 2:
        return const Color.fromARGB(255, 208, 154, 134);
      default:
        return Colors.white;
    }
  }
 
}