import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/fd/utils/fd_procedures.dart';

class ViewFd extends StatefulWidget {
  const ViewFd({super.key});

  @override
  _ViewFdState createState() => _ViewFdState();
}

class _ViewFdState extends State<ViewFd> {
  List<dynamic> fdData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      final response = await getFd();
      setState(() {
        fdData = response;
        isLoading = false;
      });
    } catch (error) {
      print(error);
    } 
  }

  @override
  Widget build(BuildContext context) {
    double investmentValue = 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Fixed Deposits',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : fdData.isEmpty
                ? const Center(
                    child: Text('No Fixed Deposits found.'),
                  )
                : ListView.builder(
                    itemCount: fdData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == fdData.length) {
                        return Container(
                          height: 90,
                          // margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightGreen),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your Investment Value",
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_IN',
                                  symbol: '₹',
                                  decimalDigits: 2,
                                ).format(investmentValue),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final item = fdData[index];
                      final creationDate = item["creationDate"];
                      final amount = item["amount"];
                      final interest = item["interest"];
                      DateTime creationDateFlutter = DateTime(
                        creationDate["year"],
                        creationDate["month"],
                        creationDate["day"],
                      );
                      DateTime now = DateTime.now();
                      int days = now.difference(creationDateFlutter).inDays;
                      double currentValue =
                          amount * pow((1 + (interest / 100) / 365), days);
                      investmentValue += currentValue;
                      return Card(
                        amount: item["amount"].toDouble(),
                        maturityDate: item["maturityDate"],
                        currentValue: currentValue,
                      );
                    },
                  ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final double currentValue;
  final double amount;
  final String maturityDate;
  const Card({
    super.key,
    required this.amount,
    required this.maturityDate,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Principal",
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_IN',
                      symbol: '₹',
                      decimalDigits: 2,
                    ).format(amount),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Current Value",
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_IN',
                      symbol: '₹',
                      decimalDigits: 2,
                    ).format(currentValue),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.lightGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Maturity Date: $maturityDate",
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
