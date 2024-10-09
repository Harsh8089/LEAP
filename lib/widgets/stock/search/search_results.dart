import 'package:flutter/material.dart';
import 'package:leap/widgets/stock/company_info/company.dart';
import 'package:provider/provider.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<String> _stockHistory = [];

  void _loadStockHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stockHistoryData = prefs.getStringList('stockHistory');
    if (stockHistoryData != null) {
      setState(() {
        _stockHistory = stockHistoryData;
      });
    }
  }

  void _saveStockHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('stockHistory', _stockHistory);
  }

  void _pushToStockHistoryData(String companyName) {
    setState(() {
      _stockHistory.add(companyName);
      if(_stockHistory.length > 5) {
        _stockHistory.removeAt(0); 
      }
      _saveStockHistory(); 
    });
  }

  void _shiftList(String companyName) {
    setState(() {
      int index = _stockHistory.indexOf(companyName);
      if(index != -1) {
        _stockHistory.removeAt(index);
        _stockHistory.add(companyName);
        _saveStockHistory();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStockHistory();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    dynamic filteredCompanies = [];

    if (provider.query.isNotEmpty) {
      filteredCompanies = provider.companies.keys
          .where((company) =>
              company.toLowerCase().contains(provider.query.toLowerCase()))
          .take(5)
          .toList();
    } 
    else if(_stockHistory.isNotEmpty) {
        filteredCompanies = _stockHistory;
    } 
    else {
        filteredCompanies = ["Zomato Limited", "Tata Motors Ltd", "Adani Power Limited", "VODAFONE IDEA LIMITED"];
    }

    filteredCompanies = filteredCompanies.reversed.toList();
    
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
        itemCount: filteredCompanies.length,
        itemBuilder: (context, index) {
        final companyName = filteredCompanies[index];
        String scripId = provider.companies[companyName]?.toString() ?? 'N/A';

        Widget leadingIcon;
        if(provider.query.isEmpty) {
          if(_stockHistory.isNotEmpty) leadingIcon = Icon(Icons.history); 
          else leadingIcon = Icon(Icons.trending_up);
        } 
        else leadingIcon = SizedBox.shrink(); 
    
        return ListTile(
          leading: leadingIcon,
          title: Text(companyName),
          onTap: () {
            if (provider.query.isNotEmpty || _stockHistory.length < 5) {
              _pushToStockHistoryData(companyName);
            }
            else if(_stockHistory.contains(companyName)) {
                _shiftList(companyName);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Company(companyName: companyName, scripId: scripId),
              ),
            );
          },
        );
      },
    );
  }
}
