import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class HobbiesStone extends StatefulWidget {
  const HobbiesStone(
      {Key? key, required this.text, required this.animatedEmojis})
      : super(key: key);
  final String text;
  final AnimatedEmojiData animatedEmojis;

  @override
  State<HobbiesStone> createState() => _HobbiesStoneState();
}

class _HobbiesStoneState extends State<HobbiesStone>
    with SingleTickerProviderStateMixin {
  bool _showText = false;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  void _onTap() {
    setState(() {
      _showText = true;
    });
    _controller.forward(from: 0);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showText = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double baseWidth = Get.width * 0.135;
    // double expandedWidth = Get.width * 0.42;
    // double baseHeight = Get.width * 0.13;
    // double expandedHeight = Get.width * 0.13;
    double basePadding = 0;
    double expandedPadding = Get.width * 0.03;

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // width: _showText ? expandedWidth : baseWidth,
        // height: _showText ? expandedHeight : baseHeight,
        padding: EdgeInsets.only(
          right: _showText ? expandedPadding : basePadding,
        ),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.error,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            CircleAvatar(
              // backgroundColor: Colors.white60,
              radius: 30,
              child: AnimatedEmoji(
                widget.animatedEmojis,
              ),
            ),
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return _showText
                    ? Row(
                        children: [
                          SizedBox(width: Get.width * 0.02),
                          Opacity(
                            opacity: _fadeAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 10 * (1 - _fadeAnimation.value)),
                              child: child,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink();
              },
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
