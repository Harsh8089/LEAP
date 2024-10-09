import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/widgets/fd/fd_plans.dart';
import 'package:leap/widgets/fd/utils/fd_procedures.dart';

class BookFdPage extends StatefulWidget {
  final double interestRate;
  final Date duration;
  final double initialAmount;

  const BookFdPage({
    Key? key,
    required this.interestRate,
    required this.duration,
    required this.initialAmount,
  }) : super(key: key);

  @override
  _BookFdPageState createState() => _BookFdPageState();
}

class _BookFdPageState extends State<BookFdPage> {
  late TextEditingController _amountController;
  late double _maturityAmount;
  late double _totalGain;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.initialAmount.toString());
    _calculateMaturityAndGain(widget.initialAmount);
  }

  void _calculateMaturityAndGain(double amount) {
    setState(() {
      _maturityAmount = amount *
          pow((1 + (widget.interestRate / 100)),
              (widget.duration.year + (widget.duration.month / 12)));
      _totalGain = ((_maturityAmount - amount) / amount * 100) /
          (widget.duration.year + widget.duration.month / 12);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.help),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "Book FD",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.lightBlue,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INVESTMENT AMOUNT",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(12),
                                width: 280,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                                margin: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  autofocus: true,
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  decoration: InputDecoration(
                                    prefixText: "₹ ",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    double amount = double.tryParse(value) ?? 0;
                                    _calculateMaturityAndGain(amount);
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.lightBlue.withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Maturity Amount"),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'en_IN',
                                            symbol: '₹',
                                            decimalDigits: 2,
                                          ).format(_maturityAmount),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                      color: AppColors.lightBlue,
                                      width: 1,
                                    ),
                                    Column(
                                      children: [
                                        Text("Total Gain"),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'en_IN',
                                                symbol: '₹',
                                                decimalDigits: 2,
                                              ).format(_maturityAmount -
                                                  double.parse(
                                                      _amountController.text ==
                                                              ""
                                                          ? "0"
                                                          : _amountController
                                                              .text)),
                                              style: TextStyle(
                                                color: AppColors.lightGreen,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_upward_rounded,
                                              color: AppColors.lightGreen,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tenure selected",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "${widget.duration.year} ${widget.duration.year > 1 ? "years" : "year"} ${widget.duration.month} ${widget.duration.month == 0 ? "" : widget.duration.month > 1 ? "months" : "month"} p.a.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Interest",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "${widget.interestRate.toString()}% p.a.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Annual Yield",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "${_totalGain.toStringAsFixed(2)}% p.a.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom section
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.star_border,
                        size: 20.0,
                        color: Colors.amber[300],
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Highlights of this plan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Icon(Icons.star_border,
                          size: 20.0, color: Colors.amber[300]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: AppColors.lightBlue,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text("Withdraw your money anytime after 7 days"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: AppColors.lightBlue,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text("Sum upto 50,000/- insured"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Processing..."),
                              ],
                            ),
                          );
                        },
                      );
                      final scaffold = ScaffoldMessenger.of(context);
                      int response = await bookFd(
                          widget.interestRate,
                          widget.duration,
                          double.parse(_amountController.text));
                      navigator.pop();
                      if (response == 1) {
                        navigator.pop();
                        navigator.pushReplacement(MaterialPageRoute(
                            builder: (context) => Done(
                                amount: widget.initialAmount,
                                interest: widget.interestRate)));
                      } else if (response == -1) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              'You are not logged in',
                            ),
                          ),
                        );
                      } else if (response == 0) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Insufficient Balance",
                            ),
                          ),
                        );
                      } else {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Server Error, Please try again after some time",
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class Done extends StatefulWidget {
  final double amount;
  final double interest;
  const Done({
    Key? key,
    required this.amount,
    required this.interest,
  }) : super(key: key);

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
  bool _showTick = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showTick = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: 1600,
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
        child: Center(
          child: _showTick
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Fd Created",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Invested Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                height: 2,
                                width: 135,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.grey,
                                )),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "₹${widget.amount.toString()}",
                                style: TextStyle(
                                  color: AppColors.lightGreen,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Interest",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                height: 2,
                                width: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.grey,
                                )),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${widget.interest.toString()}% p.a.",
                                style: TextStyle(
                                  color: AppColors.lightGreen,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
                ),
        ),
      ),
    );
  }
}
