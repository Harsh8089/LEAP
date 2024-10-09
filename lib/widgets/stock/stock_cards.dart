import 'package:flutter/material.dart';
import 'package:leap/consts/companies.dart';

class StockCard extends StatelessWidget {
  final List<String> companiesList;
  final int index;
  final Map<int, String> reversedCompaniesMap;

  StockCard({super.key, required this.companiesList, required this.index})
      : reversedCompaniesMap = {
          for (var entry in companies.entries) entry.value: entry.key
        };

  @override
  Widget build(BuildContext context) {
    // Convert the string stock code to integer
    int? stockCode = int.tryParse(companiesList[index]);

    // Look up the company name in the reversed map using the integer stock code
    String? companyName =
        stockCode != null ? reversedCompaniesMap[stockCode] : null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Optional: Card border radius
      ),
      elevation: 4, // Optional: Card elevation for shadow
      child: Center(
        child: Text(
          companyName ?? 'Unknown Company', // Handle null values
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
