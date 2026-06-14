import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';

class GenderFilterButton extends StatelessWidget {
  final String genderLabel;
  final String genderValue;
  final RxString selectedGender;
  final Function(String) onGenderSelected;

  const GenderFilterButton({
    super.key,
    required this.genderLabel,
    required this.genderValue,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ElevatedButton(
        onPressed: () {
          onGenderSelected(genderValue); // When button pressed, select gender
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedGender.value == genderValue
              ? primaryColor
              : Colors.white, // Button color changes based on selection
        ),
        child: Text(
          genderLabel,
          style: TextStyle(color: selectedGender.value == genderValue ? Colors.white : Colors.black, fontSize: 12),
        ),
      );
    });
  }
}
