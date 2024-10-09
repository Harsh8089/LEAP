import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';

class CustomBankCard extends StatelessWidget {
  final double coins; // Accept coins as a parameter

  const CustomBankCard({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.lightGreen, // Background pink
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Pink circle at the top left
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          // Abstract pink shape
          Positioned(
            top: 60,
            left: 140,
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFF79292),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  bottomRight: Radius.circular(80),
                ),
              ),
            ),
          ),
          // Large blue curve at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width, // Fixing width
                color: AppColors.lightBlue, // Blue color
              ),
            ),
          ),
          // White lines and shapes
          const Positioned(
            top: 30,
            right: 30,
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          ),
          Positioned(
            top: 20,
            right: 60,
            child: Container(
              height: 60,
              width: 1,
              color: Colors.white70,
            ),
          ),

          // Balance Text
          const Positioned(
            bottom: 70,
            left: 20,
            child: Text(
              "Your Balance",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),

          // Balance Amount (coins value)
          Positioned(
              bottom: 20,
              left: 10,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/vc.png',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    coins.toStringAsFixed(2), // Display the coins with 2 decimal places
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
