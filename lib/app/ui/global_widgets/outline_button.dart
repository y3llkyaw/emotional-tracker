import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(
      {Key? key,
      required this.text,
      required this.isLoading,
      this.asset,
      this.height,
      required this.onPressed})
      : super(key: key);
  final bool isLoading;
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
            isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black,
                    ),
                  )
                : (asset != null ? SvgPicture.asset(asset!) : const SizedBox()),
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
