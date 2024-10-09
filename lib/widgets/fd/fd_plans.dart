import 'package:flutter/material.dart';
import 'package:leap/widgets/fd/book_fd_page.dart';

class Date {
  int year;
  int month;

  Date(this.year, this.month);
}

class TopPlans extends StatelessWidget {
  final double amount;
  final BuildContext context;
  TopPlans({
    Key? key,
    required this.amount,
    required this.context,
  }) : super(key: key);

  final List<Map<String, dynamic>> plans = [
    {'rate': 7.5, 'duration': Date(1, 4)},
    {'rate': 7.7, 'duration': Date(1, 11)},
    {'rate': 8.1, 'duration': Date(2, 3)},
    {'rate': 8.3, 'duration': Date(2, 6)},
    {'rate': 8.5, 'duration': Date(3, 0)},
    {'rate': 8.7, 'duration': Date(3, 6)},
    {'rate': 8.9, 'duration': Date(4, 0)},
    {'rate': 9.1, 'duration': Date(4, 6)},
    {'rate': 9.3, 'duration': Date(5, 0)},
    {'rate': 9.5, 'duration': Date(5, 6)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 200, // Set a fixed height for the scrollable area
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return _buildPlanItem(
                plans[index]['rate']!,
                plans[index]['duration']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlanItem(double interestRate, Date duration) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${interestRate.toString()}% p.a.",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${duration.year} ${duration.year > 1 ? "years" : "year"} ${duration.month} ${duration.month == 0 ? "" : duration.month > 1 ? "months" : "month"} p.a.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookFdPage(
                    interestRate: interestRate,
                    duration: duration,
                    initialAmount: amount,
                  ),
                ),
              );
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}
