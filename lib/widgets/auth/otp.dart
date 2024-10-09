import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:leap/providers/userProvider.dart';
import 'package:leap/utils/authentication_functions.dart';
import 'package:leap/widgets/auth/login.dart';
import 'package:provider/provider.dart';

class Otp extends StatefulWidget {
  final TextEditingController mobileController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;

  const Otp({
    required this.mobileController,
    required this.userNameController,
    required this.passwordController,
    Key? key,
  }) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  Color lightPurpleColor = Color(0xFFD1C4E9);

  @override
  Widget build(BuildContext context) {
    List<TextStyle?> otpTextStyles =
        List.generate(6, (index) => createStyle(lightPurpleColor));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make it transparent
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 70.0),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40.0),
              Text(
                'Enter the OTP sent to +91 ${widget.mobileController.text}',
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50.0),
              OtpTextField(
                numberOfFields: 6,
                borderColor: lightPurpleColor,
                showFieldAsBox: false,
                borderWidth: 2.0,
                styles: otpTextStyles, // Text color inside OTP fields
                onSubmit: (String otp) async {
                  final tempNavigator = Navigator.of(context);
                  bool flag = await verifyOtp(otp);
                  if (flag) {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    final response = await userProvider.signUp(
                        widget.userNameController.text,
                        widget.passwordController.text,
                        widget.passwordController.text);
                    if (response != null) {
                      if (response.statusCode == 200) {
                        tempNavigator.push(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Uh Oh! Incorrect OTP, Try Again!'),
                          ),
                        );
                      }
                    } else {
                      print(
                          "Something went wrong, response was null, try again");
                    }
                  }
                },
              ),
              const SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Didn't receive the OTP ?"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Resend OTP'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.displayMedium?.copyWith(color: color);
  }
}
