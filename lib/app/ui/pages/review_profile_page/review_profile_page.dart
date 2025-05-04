import 'package:flutter/material.dart';

class ReviewProfilePage extends StatelessWidget {
  const ReviewProfilePage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review This Person"),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
