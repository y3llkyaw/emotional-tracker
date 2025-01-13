import 'dart:developer';

import 'package:flutter/material.dart';

class SentimentRadio extends StatefulWidget {
  const SentimentRadio({Key? key}) : super(key: key);

  @override
  State<SentimentRadio> createState() => _SentimentRadioState();
}

class _SentimentRadioState extends State<SentimentRadio> {
  String _selectedSentiment = "Very Negative";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade100.withOpacity(0.3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSentimentOption("Super Bad", Colors.red),
          _buildSentimentOption("Kinda Bad", Colors.orange),
          _buildSentimentOption("Meh", Colors.amber),
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
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _selectedSentiment == sentiment
                    ? Colors.transparent
                    : color,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Container(
                color: Colors.white10,
                padding: const EdgeInsets.all(5),
                width: 4,
                height: 4,
                child: Container(
                  width: 1,
                  height: 1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedSentiment == sentiment
                        ? color
                        : Colors.white10,
                    border: Border.all(color: color, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(sentiment),
          ],
        ),
      ),
    );
  }
}
