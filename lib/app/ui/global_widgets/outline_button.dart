import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(
      {Key? key,
      required this.text,
      this.asset,
      this.height,
      required this.onPressed})
      : super(key: key);

  final String text;
  final String? asset;
  final double? height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            asset != null ? SvgPicture.asset(asset!) : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
