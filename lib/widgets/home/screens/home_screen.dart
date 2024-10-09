import 'package:flutter/material.dart';
import 'package:leap/widgets/home/utils/custom_card.dart';

class HomeScreen extends StatelessWidget {
  final username;
  final coins;

  const HomeScreen({super.key, required this.username, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Profile(),
          const SizedBox(height: 20.0),
          Greet(username: username ?? 'Guest'), // Default value if username is null
          const SizedBox(height: 20.0),
          CustomBankCard(coins: coins),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(Icons.audiotrack),
    );
  }
}

class Greet extends StatelessWidget {
  final String username; // Make this non-nullable

  const Greet({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Good Afternoon, ',
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          username,
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}