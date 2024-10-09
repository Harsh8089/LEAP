import 'package:flutter/cupertino.dart';
import '../consts/companies.dart' as data;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:typed_data';

class Stock {
  final String scripId;
  double price;
  List bids;
  List asks;
  int totalBuyQuantity;
  int totalSellQuantity;

  Stock({
    required this.scripId,
    this.price = 0.0,
    this.bids = const [
      [0.0, 0],
      [0.0, 0],
      [0.0, 0],
      [0.0, 0],
      [0.0, 0]
    ],
    this.asks = const [
      [0.0, 0],
      [0.0, 0],
      [0.0, 0],
      [0.0, 0],
      [0.0, 0]
    ],
    this.totalBuyQuantity = 0,
    this.totalSellQuantity = 0,
  });

  void update({
    double? newPrice,
    List? newBids,
    List? newAsks,
    int? newTotalBuyQuantity,
    int? newTotalSellQuantity,
  }) {
    if (newPrice != null) price = newPrice;
    if (newBids != null) bids = newBids;
    if (newAsks != null) asks = newAsks;
    if (newTotalBuyQuantity != null) totalBuyQuantity = newTotalBuyQuantity;
    if (newTotalSellQuantity != null) totalSellQuantity = newTotalSellQuantity;
  }
}

class StockProvider extends ChangeNotifier {
  Map<String, int> companies = data.companies;
  String _query = '';

  final List<Stock> _stocks = [];
  Map<String, List<double>> prices = {};
  WebSocketChannel? _channel;

  StockProvider() {
    _initWebSocket();
  }

  void _initWebSocket() {
    print("Inside init web socket function");

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(
            'wss://developer-ws.paytmmoney.com/broadcast/user/v1/data?x_jwt_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJtZXJjaGFudCIsImlzcyI6InBheXRtbW9uZXkiLCJpZCI6OTc1MTQ5LCJleHAiOjE3Mjc5ODAxOTl9.W7GXEN16GdOgEGnNsP5x9b9OiBBET5xXtL2kZEkKtdU'),
      );

      final jsonData = [
        {
          "actionType": "ADD",
          "modeType": "FULL",
          "scripType": "EQUITY",
          "exchangeType": "BSE",
          "scripId": "500570",
        },
        {
          "actionType": "ADD",
          "modeType": "FULL",
          "scripType": "EQUITY",
          "exchangeType": "BSE",
          "scripId": "543320",
        },
        {
          "actionType": "ADD",
          "modeType": "FULL",
          "scripType": "EQUITY",
          "exchangeType": "BSE",
          "scripId": "533096",
        },
        {
          "actionType": "ADD",
          "modeType": "FULL",
          "scripType": "EQUITY",
          "exchangeType": "BSE",
          "scripId": "532822",
        },
      ];

      _channel?.sink.add(jsonEncode(jsonData));

      _channel!.stream.listen(
        (message) {
          // print("Received message\n");
          handleMessage(message);
        },
        onError: (error) {
          print("WebSocket error: $error");
        },
        onDone: () {
          print("WebSocket connection closed");
        },
      );
    } catch (e) {
      print("Failed to connect to WebSocket: $e");
    }
  }

  void handleMessage(dynamic message) {
    final buffer = ByteData.view(Uint8List.fromList(message).buffer);
    int i = 0;
    while (i < message.length) {
      final type = buffer.getUint8(i);
      i += 1;
      if (type == 63) {
        int depthPosition = i;
        List<dynamic> bids = [];
        List<dynamic> asks = [];
        for (int depth = 0; depth < 5; depth++) {
          int buyQuantity = buffer.getInt32(depthPosition, Endian.little);
          int sellQuantity = buffer.getInt32(depthPosition + 4, Endian.little);
          String buyPrice = buffer
              .getFloat32(depthPosition + 12, Endian.little)
              .toStringAsFixed(2);
          String sellPrice = buffer
              .getFloat32(depthPosition + 16, Endian.little)
              .toStringAsFixed(2);
          bids.add([buyPrice, buyQuantity]);
          asks.add([sellPrice, sellQuantity]);
          depthPosition += 20;
        }
        i += 100;
        int totalBuyQuantity = buffer.getInt32(i + 26, Endian.little);
        int totalSellQuantity = buffer.getInt32(i + 30, Endian.little);
        final price = buffer.getFloat32(i, Endian.little);
        final scripId = buffer.getInt32(i + 8, Endian.little).toString();
        i += 74;

        // Update the relevant Stock with the new data
        final stock = _stocks.firstWhere(
          (stock) => stock.scripId == scripId,
          orElse: () {
            final newStock = Stock(scripId: scripId);
            _stocks.add(newStock);
            return newStock;
          },
        );
        stock.update(
          newPrice: double.parse(price.toStringAsFixed(2)),
          newBids: bids,
          newAsks: asks,
          newTotalBuyQuantity: totalBuyQuantity,
          newTotalSellQuantity: totalSellQuantity,
        );

        // Initialize the list if it doesn't exist
        if (prices[stock.scripId] == null) {
          prices[stock.scripId] = [];
        }
        prices[stock.scripId]?.add(stock.price);

        notifyListeners();
      }
    }
  }

  List<Stock> get stocks => _stocks;

  String get query => _query;

  void updateQuery(String newQuery) {
    if (_query != newQuery) {
      _query = newQuery;
      notifyListeners();
    }
  }
}
