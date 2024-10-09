import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/fd/create_fd.dart';
import 'package:leap/widgets/fd/view_fd.dart';

class FDHome extends StatefulWidget {
  const FDHome({super.key});

  @override
  State<FDHome> createState() => _FDHomeState();
}

class _FDHomeState extends State<FDHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Fixed Deposits',
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/growth.png",
                        color: Colors.white,
                        height: 150,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Get up to ",
                                style: TextStyle(
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: "9.5%",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightGreen,
                                ),
                              ),
                              TextSpan(
                                text: " interest per annum in FD",
                                style: TextStyle(
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: const TextSpan(
                          text: 'Know about Fixed Deposits',
                          style: TextStyle(
                            color: Color.fromARGB(175, 255, 255, 255),
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: Colors.white,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ViewFd()));
                      },
                      child: const Text(
                        'View my FDs',
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: AppColors.lightGreen,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateFD()));
                      },
                      child: const Text(
                        'Create FD',
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: AppColors.lightGreen,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
