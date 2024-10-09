import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/fd/fd_plans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFD extends StatefulWidget {
  const CreateFD({super.key});

  @override
  State<CreateFD> createState() => _CreateFDState();
}

class _CreateFDState extends State<CreateFD> {
  double _currentValue = 10000;
  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        balance = value.getDouble("coins") ?? 0.0;
      });
    });
  }

  void _updateCurrentValue(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Open FD Account',
          style: TextStyle(
            fontSize: 20.0,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
              child: Column(
                children: [
                  CurrentBalance(balance: balance),
                  TopPlans(
                    amount: _currentValue,
                    context: context,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const Text(
                    'Select Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SliderContainer(
                    currentValue: _currentValue,
                    onValueChanged: _updateCurrentValue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SliderContainer extends StatelessWidget {
  final double currentValue;
  final ValueChanged<double> onValueChanged;

  const SliderContainer({
    super.key,
    required this.currentValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/vc.png',
              fit: BoxFit.cover,
              width: 35,
              height: 35,
            ),
            const SizedBox(width: 5.0),
            Text(
              currentValue.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.lightGreen,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.lightGreen,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: AppColors.lightGreen,
            overlayColor: AppColors.lightGreen.withOpacity(0.3),
            valueIndicatorColor: AppColors.lightGreen,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          child: Slider(
            value: currentValue,
            min: 1000,
            max: 100000,
            divisions: 90,
            label: currentValue.toStringAsFixed(0),
            onChanged: onValueChanged,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/vc.png',
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 5.0),
                const Text(
                  '1,000',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'assets/vc.png',
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 5.0),
                const Text(
                  '1,00,000',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class CurrentBalance extends StatelessWidget {
  final double balance;

  const CurrentBalance({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Current Balance',
          style: TextStyle(
            color: Color.fromARGB(199, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/vc.png',
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 5.0),
              Text(
                balance.toStringAsFixed(2),
                style: TextStyle(
                  color: AppColors.lightGreen,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
