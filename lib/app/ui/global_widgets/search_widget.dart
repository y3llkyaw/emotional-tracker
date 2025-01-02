import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const SearchWidget(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);

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
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ), // Search icon
            hintText: 'Search', // Placeholder text
            hintStyle: const TextStyle(
              color: Colors.grey,
            ), // Placeholder text style
            border: InputBorder.none, // Remove underline
            contentPadding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01), // Padding inside TextField
          ),
        ),
      ),
    );
  }
}
