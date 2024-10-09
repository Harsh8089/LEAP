import 'package:flutter/material.dart';
import 'package:leap/providers/userProvider.dart';
import 'package:leap/widgets/home/home.dart';
import 'package:leap/widgets/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StockProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getLoginState().then((user) => {
          if (user['username'] != null && user['userId'] != null)
            {isLoggedIn = true}
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'leap',
      initialRoute: isLoggedIn ? '/home' : '/welcome',
      routes: {
        '/welcome': (context) => const Welcome(),
        '/home': (context) => const HomePage(),
      },
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
