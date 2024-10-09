import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/providers/userProvider.dart';
import 'package:leap/widgets/home/screens/games_screen.dart';
import 'package:leap/widgets/home/screens/home_screen.dart';
import 'package:leap/widgets/home/screens/invest_home_screen.dart';
import 'package:leap/widgets/home/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? username; // Make it nullable
  double coins = 0.0;

  List<Widget> get _pages {
    return [
        HomeScreen(username: username, coins: coins,), 
        const InvestHomeScreen(), 
        GamesScreen(), 
        ProfileScreen(), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // WHY ? -> You can't access inherited widgets (UserProvider in this case) in the initState() method because at that point, the widget tree might not be fully built, and the context might not be ready to access inherited widgets. 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userProvider = Provider.of<UserProvider>(context);
    userProvider.getLoginState().then((user) {
      if (user['userName'] != null) {
        username = user['userName'];
      }
      if (user['coins'] != null) {
        coins = user['coins'];
      }
      setState(() {}); // Trigger a rebuild to update the UI
    });
  }

  Widget _buildBubbleIcon(int index, IconData icon, String label) {
    return Container(
      decoration: _selectedIndex == index
          ? BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0),
            )
          : null,
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _selectedIndex == index ? AppColors.lightGreen : Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final navigator = Navigator.of(context);
          userProvider.logOut().then((value) {
            navigator.pushNamedAndRemoveUntil(
                '/welcome', (Route<dynamic> route) => false);
          });
        },
        child: const Icon(Icons.logout),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,       
          highlightColor: Colors.transparent,   
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildBubbleIcon(0, Icons.home, 'Home'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildBubbleIcon(1, Icons.trending_up, 'Invest'),
              label: 'Invest',
            ),
            BottomNavigationBarItem(
              icon: _buildBubbleIcon(2, Icons.games, 'Games'),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: _buildBubbleIcon(3, Icons.person, 'Profile'),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.lightGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          backgroundColor: AppColors.lightBlue.withOpacity(0.2),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            AppColors.lightBlue.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 50.0),
        child: _pages[_selectedIndex],
      ),
    );
  }
}



