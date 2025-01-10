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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        });
      },
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color:
                  _selectedSentiment == sentiment ? color : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(height: 4),
          Text(sentiment),
        ],
      ),
    );
  }
}
