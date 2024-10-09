import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/providers/userProvider.dart';
import 'package:leap/utils/authentication_functions.dart';
import 'package:leap/widgets/auth/signup.dart';
import 'package:leap/widgets/home/home.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  Future<void> _login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Verifying"),
            ],
          ),
        );
      },
    );

    final navigator = Navigator.of(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await userProvider.loginUser(
        _mobileController.text, _passwordController.text);

    navigator.pop();

    if (response?.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response!.body);
      final String userId = jsonResponse['data']['_id'];
      final String username = jsonResponse['data']['username'];
      final double coins = jsonResponse['data']['coins'].toDouble();
      print(username);

      await userProvider.saveLoginState(userId, username, coins);

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credentials Don't Match, Try Again")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 50.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  Container(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey Welcome Back!",
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "Log in to continue your journey and explore new features.",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Form(
                    key: _formKey, // Assign a key to the form
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _mobileController,
                          style: const TextStyle(
                            color: AppColors.lightPurple,
                          ),
                          maxLength: 10,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            prefix: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text('+91'),
                            ),
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: AppColors.lightPurple),
                          ),
                          // Validator for mobile number
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: AppColors.lightPurple),
                          keyboardType: TextInputType.visiblePassword,
                          showCursor: false,
                          autofocus: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: AppColors.lightPurple),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                _obscurePassword = !_obscurePassword;
                              }),
                              icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.lightPurple),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          // Validator for password
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                        const SizedBox(height: 50.0),
                        Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.lightGreen.withOpacity(1.0),
                              minimumSize: const Size(95, 45),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // Validate form fields
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar or proceed further
                                _login();
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[400])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text('OR', style: TextStyle(color: Colors.grey[600])),
                            ),
                            Expanded(child: Divider(color: Colors.grey[400])),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: AppColors.lightPurple),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            final navigator = Navigator.of(context);
                              signInWithGoogle().then((value) {
                                if (value) {
                                  navigator.pushReplacement(
                                      MaterialPageRoute(builder: (context) => const HomePage()));
                                }
                              });
                          },
                          icon: Image.asset("assets/google.png", height: 24, width: 24),
                          label: const Text('Login with Google', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: const Text('Sign Up'))
                    ],
                  )
                ],
              )),
        ));
  }
}
