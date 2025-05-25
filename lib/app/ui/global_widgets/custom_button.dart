import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.color = Colors.blueAccent,
    this.fontSize = 14.0,
    this.fontColor = Colors.white,
  }) : super(key: key);

  final bool isLoading;
  final String text;
  final bool isDisabled;
  final Function onPressed;
  final Color color;
  final Color fontColor;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isDisabled
            ? null
            : () {
                final player = AudioPlayer();
                player.play(AssetSource("audio/multi-pop.mp3"));
                onPressed();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                      // wordSpacing: 4,
                      fontSize: fontSize,
                      color: fontColor,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
