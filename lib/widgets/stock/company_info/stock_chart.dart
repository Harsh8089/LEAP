import 'package:flutter/material.dart';
import 'package:leap/consts/company_logo.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:provider/provider.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatefulWidget {
  final String companyName;
  final String scripId;

  const StockChart(
      {super.key, required this.companyName, required this.scripId});

  @override
  State<StockChart> createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  double minY = 0.0;
  double maxY = 100.0;

  Widget _buildLogo() {
    String? logoUrl = companyLogo[int.parse(widget.scripId)];
    if(logoUrl != null) {
      return Image.network(
        logoUrl,
        width: 60,
        height: 60,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderLogo(),
      );
    } 
    else return _buildPlaceholderLogo();
  }

   Widget _buildPlaceholderLogo() {
    return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.companyName.substring(0, 1).toUpperCase(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final priceData = provider.prices[widget.scripId] ?? [];
    final lastPrice = priceData.isNotEmpty ? priceData.last : 0.0;
    final startPrice = priceData.isNotEmpty ? priceData.first : 0.0;

    if (priceData.isNotEmpty) {
      minY = priceData.reduce((a, b) => a < b ? a : b) - 0.5;
      maxY = priceData.reduce((a, b) => a > b ? a : b) + 0.5;
    }

    print(widget.scripId);

    double percentageDiff = 0.0;
    if(startPrice != 0.0) percentageDiff = ((lastPrice - startPrice) / startPrice) * 100;

    bool isPositive = lastPrice >= startPrice;

    final Color chartColor = lastPrice >= startPrice ? AppColors.lightGreen : Colors.red;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildLogo(),
                    const SizedBox(width: 15.0,),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                              widget.companyName,
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 5.0,),
                            Text(
                              '₹ $lastPrice',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                    )
                  ],
                ),               

                const SizedBox(height: 10.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                             color: AppColors.lightBlue.withOpacity(0.2),
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(
                                color: AppColors.lightBlue,
                                width: 1.0
                             ) 
                        ),
                        child: const Text(
                          '1d',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 156, 173, 242),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? AppColors.lightGreen.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isPositive ? AppColors.lightGreen.withOpacity(0.2) : AppColors.lightRed.withOpacity(0.2),
                                width: 1.0
                             ) 
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isPositive ? AppColors.lightGreen : Colors.red,
                                  size: 15,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${percentageDiff.abs().toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isPositive ? AppColors.lightGreen : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: SfCartesianChart(
              primaryXAxis: const NumericAxis(
                isVisible: false,
                majorGridLines: MajorGridLines(
                  color: Color.fromARGB(255, 192, 250, 241),
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: minY,
                maximum: maxY,
                interval: (maxY - minY) / 5,
                majorGridLines: const MajorGridLines(
                  color: Color.fromARGB(255, 192, 250, 241),
                ),
              ),
              series: <CartesianSeries>[
                LineSeries<double, int>(
                  dataSource: priceData,
                  xValueMapper: (double price, int index) => index,
                  yValueMapper: (double price, int index) => price,
                  color: chartColor,
                ),
                AreaSeries<double, int>(
                  dataSource: priceData,
                  xValueMapper: (double price, int index) => index,
                  yValueMapper: (double price, int index) => price,
                  gradient: LinearGradient(
                    colors: [
                      chartColor.withOpacity(0.5),
                      chartColor.withOpacity(0.0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderColor: chartColor,
                  borderWidth: 0.3,
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          )
        ],
      ),
    );
  }
}
