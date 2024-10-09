import 'package:flutter/material.dart';
import 'package:leap/consts/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  String query;
  final Function(String) onQueryChanged;

  CustomSearchBar(
    { 
      Key? key, 
      required this.query, 
      required this.onQueryChanged  
    }
  ): super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    widget.query = "";
    _controller = TextEditingController(text: widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.height * 0.12, 0.0, 0.0),
      child: TextFormField(
        controller: _controller,
        onChanged: widget.onQueryChanged,
        style: const TextStyle(
          color: AppColors.lightPurple,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 0.0),
            child: Icon(
              Icons.search,
              color: AppColors.lightPurple,
            ),
          ),
          hintText:
              'Search by company name', // Changed from labelText to hintText
          hintStyle: TextStyle(
              color: AppColors
                  .lightPurple), // Changed from labelStyle to hintStyle
          contentPadding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 16), // Added for better spacing
        ),
      ),
    );
  }
}
