import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/auth/login.dart';
import 'package:leap/widgets/welcome/quote_icon.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Remove the appBar height
        backgroundColor: Colors.transparent, // Make it transparent
      ),
      body: Stack(
        children: <Widget>[
          Container(
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: <Widget>[
                  // App Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // 'L' text with gradient
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: <Color>[
                              AppColors.lightPurple,
                              AppColors.lightGreen
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'L',
                          style: TextStyle(
                            fontSize: 90.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -5.0
                          ),
                        ),
                      ),

                      // Rotated icon with background decoration
                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: 90 * 3.1415927 / 180, // 90 degrees in radians
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.lightPurple,
                                AppColors.lightGreen
                              ], // Gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Icon(
                              Icons.bar_chart_rounded,
                              size: 60.0, // Increased size
                            ),
                          ),
                        ),
                      ),

                      // 'AP' text with gradient
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: <Color>[
                              AppColors.lightPurple,
                              AppColors.lightGreen
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'AP',
                          style: TextStyle(
                            fontSize: 90.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                 Spacer(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const QuotesIcon(size: 30, color: AppColors.lightGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Dive into a world of interactive challenges and real-life simulations to master the art of money management.",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[300],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Button section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Let's Get",
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Started",
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Container(
                            width: 40.0, // Width of the circle
                            height: 40.0, // Height of the circle
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.lightPurple,
                                  AppColors.lightGreen
                                ], // Gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_right_rounded,
                                color: Colors.white, // Icon color
                                size: 30.0, // Icon size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGreen,
                  minimumSize: const Size(
                      double.infinity, 50), // Stretch button horizontally
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: const Text(
                  'Join Now',
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
