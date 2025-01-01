import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;

  const SearchWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Background color
          borderRadius: BorderRadius.circular(24.0), // Rounded corners
        ),
        child: TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
            hintText: 'Search', // Placeholder text
            hintStyle: TextStyle(color: Colors.grey), // Placeholder text style
            border: InputBorder.none, // Remove underline
            contentPadding: EdgeInsets.symmetric(
                vertical: 15.0), // Padding inside TextField
          ),
        ),
      ),
    );
  }
}
