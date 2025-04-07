import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Future<void> Function(String) onSearch;
  const SearchWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.onSearch})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(24.0), // Rounded corners
        ),
        child: TextField(
          onChanged: (value) async => await widget.onSearch(value),
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ), // Search icon
            hintText: widget.hintText, // Placeholder text
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
