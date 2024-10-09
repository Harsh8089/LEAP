import 'package:flutter/material.dart';
import 'package:leap/utils/authentication_functions.dart';
import 'package:leap/widgets/home/home.dart';

class OTP extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String mobileNumber;
  OTP({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              maxLength: 6,
              keyboardType: TextInputType.number,
              showCursor: false,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5,
                    ),
                  ),
                ),
                label: Text(
                  'Enter OTP',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final navigator = Navigator.of(context);
                verifyOtp(_controller.text).then(
                  (flag) {
                    if (flag) {
                      // saveLoginState();
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                );
              },
              child: const Text('Submit OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
