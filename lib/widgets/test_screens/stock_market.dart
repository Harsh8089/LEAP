import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockData {
  StockData({required this.time, required this.price});
  final int time;
  final double price;
}

class StockMarket extends StatefulWidget {
  const StockMarket({super.key});

  @override
  State<StockMarket> createState() => _StockMarketState();
}

class _StockMarketState extends State<StockMarket> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.29.90:8000'));
  List<StockData> chartData = List.generate(100, (index) => StockData(time: index, price: 0.0));

  double currPrice = 0.0;
  double minY = 0.0;
  double maxY = 100.0;

  // Track overall min and max prices
  double minPrice = double.infinity;
  double maxPrice = double.negativeInfinity;

  @override
  void initState() {
    super.initState();
    int currentIndex = 0;

    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      double price = decodedMessage['price'].toDouble();

      setState(() {
        // Update chart data
        chartData[currentIndex] = StockData(
          time: currentIndex,
          price: price,
        );
        currentIndex = (currentIndex + 1) % 100;
        
        currPrice = price;

        if(price < minPrice) minPrice = price;
        if(price > maxPrice) maxPrice = price;

        minY = (currPrice - 5 < minPrice) ? currPrice - 5 : minPrice;
        maxY = (currPrice + 5 > maxPrice) ? currPrice + 5 : maxPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Market'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Price: $currPrice',
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SfCartesianChart(
                primaryYAxis: NumericAxis(
                  minimum: minY,
                  maximum: maxY,
                  interval: (maxY - minY) / 5,
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                series: <CartesianSeries>[
                  LineSeries<StockData, num>(
                    dataSource: chartData,
                    xValueMapper: (StockData stock, _) => stock.time,
                    yValueMapper: (StockData stock, _) => stock.price,
                    color: Colors.blue,
                    width: 2,
                    pointColorMapper: (StockData stock, _) =>
                        stock.price == 0.0 ? Colors.transparent : Colors.blue,
                  ),
                  AreaSeries<StockData, num>(
                    dataSource: chartData,
                    xValueMapper: (StockData stock, _) => stock.time,
                    yValueMapper: (StockData stock, _) => stock.price,
                    gradient: LinearGradient(
                      colors: [Colors.blue.withOpacity(0.5), Colors.blue.withOpacity(0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                    pointColorMapper: (StockData stock, _) =>
                        stock.price == 0.0 ? Colors.transparent : Colors.blue.withOpacity(0.5),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional content can go here...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
