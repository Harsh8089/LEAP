import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';
import 'package:leap/providers/StockProvider.dart';
import 'package:leap/widgets/stock/search/search_bar.dart';
import 'package:leap/widgets/stock/search/search_results.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              AppColors.lightBlue.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomSearchBar(
              query: provider.query,
              onQueryChanged: provider.updateQuery,
            ),
            const Expanded(  // Wrap SearchResults in Expanded for scrollable ListView
              child: SearchResults(),
            ),
          ],
        ),
      )
    );
  }
}
