import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton(
      {Key? key,
      required this.title,
      required this.title2,
      this.selectedColor = Colors.orange,
      this.unselectedColor = Colors.white})
      : super(key: key);
  final String title;
  final String title2;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          color: Colors.white, // Background for the toggle
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(widget.title, 0),
            _buildToggleButton(widget.title2, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Center(
        child: Container(
          width: Get.width * 0.4,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              borderRadius: isSelected
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
