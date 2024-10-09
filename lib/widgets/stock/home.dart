import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/explore/explore.dart';
import 'package:leap/widgets/stock/holdings/holdings.dart';
import 'package:leap/widgets/stock/leaderboard/leaderboard.dart';
import 'package:leap/widgets/stock/learn/learn.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> trendingStocks = ["532540", "500825", "500820", "533096"];
  String activeTab = "";

  @override
  void initState() {
    super.initState();
    activeTab = "Explore";
  }

  Widget _getActiveScreen() {
    if(activeTab == "Explore") return Explore();
    else if(activeTab == "Holdings") return Holdings();
    else if(activeTab == "Learn") return Learn();
    else return Leaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Virtual Stock Market',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<StockProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Column(
                children: <Widget> [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(95, 45),
                            backgroundColor: activeTab == "Explore" ? AppColors.lightBlue : AppColors.lightBlue.withOpacity(0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              activeTab = "Explore";
                            });
                          },
                          child: Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: activeTab == "Explore"
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 10.0),
            
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(95, 45),
                            backgroundColor: activeTab == "Holdings" ? AppColors.lightBlue : AppColors.lightBlue.withOpacity(0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              activeTab = "Holdings";
                            });
                          },
                          child: Text(
                            'Holdings',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: activeTab == "Holdings"
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 10.0),
            
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(95, 45),
                            backgroundColor: activeTab == "Learn" ? AppColors.lightBlue : AppColors.lightBlue.withOpacity(0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              activeTab = "Learn";
                            });
                          },
                          child: Text(
                            'Learn',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: activeTab == "Learn"
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 10.0),
            
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(95, 45),
                            backgroundColor: activeTab == "Leaderboard" ? AppColors.lightBlue : AppColors.lightBlue.withOpacity(0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              activeTab = "Leaderboard";
                            });
                          },
                          child: Text(
                            'Leaderboard',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: activeTab == "Leaderboard"
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Expanded(child: _getActiveScreen())
                ]
              ),
            );
          }
        ),
      ),
    );
  }
}