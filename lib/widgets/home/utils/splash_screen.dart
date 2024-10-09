// import 'package:flutter/material.dart';
// import 'package:revisit/main.dart';
// import 'package:revisit/screens/home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   final bool isLoggedIn;
//   const SplashScreen({super.key, required this.isLoggedIn});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );

//     _controller.forward();

//     final navigator = Navigator.of(context);

//     Future.delayed(const Duration(seconds: 0), () {
//       navigator.pushReplacement(
//         MaterialPageRoute(
//             builder: (context) =>
//                 widget.isLoggedIn ? const HomePage() : LoginPage()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(widget.isLoggedIn);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: FadeTransition(
//           opacity: _animation,
//           child: Center(
//             child: Image.asset('assets/loading.gif'),
//           ),
//         ),
//       ),
//     );
//   }
// }
