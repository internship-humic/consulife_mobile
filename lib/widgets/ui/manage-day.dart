import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageDay extends StatelessWidget {
  final RxList<String> value; // Change to RxList for reactivity
  final Function(List<String>) onChange;
  final bool isSingleSelect;
  final bool disabled;

  const ManageDay({
    Key? key,
    required this.value, // Now required to be an observable list
    required this.onChange,
    this.isSingleSelect = false,
    this.disabled = false,
  }) : super(key: key);

  void handleSelectDay(String selectedDay) {
    if (disabled) return;

    if (isSingleSelect) {
      if (value.contains(selectedDay)) {
        onChange([]);
      } else {
        onChange([selectedDay]);
      }
    } else {
      List<String> selectedDays = List.from(value);
      if (selectedDays.contains(selectedDay)) {
        selectedDays.remove(selectedDay);
      } else {
        selectedDays.add(selectedDay);
      }
      onChange(selectedDays);
    }
  }

  bool isSelected(String itemValue) {
    return value.contains(itemValue);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> days = [
      {'label': 'Mon', 'value': 'Monday'},
      {'label': 'Tue', 'value': 'Tuesday'},
      {'label': 'Wed', 'value': 'Wednesday'},
      {'label': 'Thu', 'value': 'Thursday'},
      {'label': 'Fri', 'value': 'Friday'},
      {'label': 'Sat', 'value': 'Saturday'},
      {'label': 'Sun', 'value': 'Sunday'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Wrap(
            spacing: 10, // Horizontal space between items
            runSpacing: 10, // Vertical space between lines
            children: days.map((item) {
              bool selected = isSelected(item['value']!);
              return GestureDetector(
                onTap: () => handleSelectDay(item['value']!),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: disabled
                        ? (selected ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.2))
                        : (selected ? primaryColor : const Color(0xffDDE7F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['label']!,
                    style: TextStyle(
                      color: disabled
                          ? (selected ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.2))
                          : (selected ? Colors.white : Colors.black54),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
