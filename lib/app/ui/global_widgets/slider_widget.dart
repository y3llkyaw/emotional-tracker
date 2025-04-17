import 'package:emotion_tracker/app/controllers/mood_slider_controller.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodSliderWidget extends StatefulWidget {
  const MoodSliderWidget({Key? key, required this.onChange}) : super(key: key);

  final Function onChange;
  @override
  State<MoodSliderWidget> createState() => _MoodSliderWidgetState();
}

class _MoodSliderWidgetState extends State<MoodSliderWidget> {
  final MoodSliderController moodSliderController =
      Get.put(MoodSliderController());
  final List<String> _moods = [
    "Super Bad",
    "Kinda Bad",
    "Meh",
    "Pretty Good",
    "Awesome",
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.short2,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _moods.reversed.map(
                (mood) {
                  int index = _moods.indexOf(mood);
                  return Text(
                    mood,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: moodSliderController.sliderValue.value == index
                          ? valueToColor(index)
                          : Colors.grey.shade600,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          Obx(
            () => Slider(
              min: 0,
              max: 4,
              value: moodSliderController.sliderValue.value,
              activeColor:
                  valueToColor(moodSliderController.sliderValue.value.toInt()),
              secondaryActiveColor:
                  valueToColor(moodSliderController.sliderValue.value.toInt()),
              divisions: 4, // Number of steps for the slider
              label: _moods[moodSliderController.sliderValue.value
                  .toInt()], // Show the mood label
              onChanged: (value) {
                moodSliderController.sliderValue.value = value;
                widget.onChange(
                  value.toInt(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
