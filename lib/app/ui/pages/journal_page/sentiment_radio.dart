import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentimentRadio extends StatefulWidget {
  const SentimentRadio({Key? key, required this.onPressed}) : super(key: key);

  final Function onPressed;

  @override
  State<SentimentRadio> createState() => _SentimentRadioState();
}

class _SentimentRadioState extends State<SentimentRadio> {
  String _selectedSentiment = "Meh";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSentimentOption("Super Bad", Colors.red),
          _buildSentimentOption("Kinda Bad", Colors.orange),
            _buildSentimentOption("Neutral", Colors.grey),
          _buildSentimentOption("Pretty Good", Colors.lightGreen),
          _buildSentimentOption("Awesome", Colors.green),
        ],
      ),
    );
  }

  Widget _buildSentimentOption(String sentiment, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSentiment = sentiment;
          log(sentiment);
          widget.onPressed(color);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedSentiment == sentiment
                    ? color
                    : Colors.transparent,
                border: Border.all(color: color, width: 2),
              ),
              child: _selectedSentiment == sentiment
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              sentiment,
              style: TextStyle(
                color: _selectedSentiment == sentiment ? Colors.black : Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
