import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/models/psychologst/info-data-psychologst.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageTime extends StatelessWidget {
  final List<Map<String, String>> days = [
    {'label': '09:00-10:00', 'start': '09:00', 'end': '10:00'},
    {'label': '11:00-12:00', 'start': '11:00', 'end': '12:00'},
    {'label': '13:00-14:00', 'start': '13:00', 'end': '14:00'},
    {'label': '14:00-15:00', 'start': '14:00', 'end': '15:00'},
    {'label': '15:00-16:00', 'start': '15:00', 'end': '16:00'},
    {'label': '16:00-17:00', 'start': '16:00', 'end': '17:00'},
  ];

  final RxList<Map<String, String>> value; // Selected time slots
  final Function(List<Map<String, String>>) onChange; // Callback for changes
  final List<Time>? times; // Optional available times
  final bool isSingleSelect; // Single selection mode
  final bool disabled; // Disable interaction

  ManageTime({
    super.key,
    required this.value, // Now required to be an observable list
    required this.onChange,
    this.isSingleSelect = false,
    this.disabled = false,
    this.times,
  });

  void handleSelectTime(Map<String, String> selectedTime) {
    if (disabled) return;

    final selectedTimes = List<Map<String, String>>.from(value);

    if (isSingleSelect) {
      // If single select mode is enabled
      if (selectedTimes.isNotEmpty &&
          selectedTimes[0]['start'] == selectedTime['start'] &&
          selectedTimes[0]['end'] == selectedTime['end']) {
        // Deselect if already selected
        onChange([]);
      } else {
        // Select the new time slot
        onChange([selectedTime]);
      }
    } else {
      // If multiple select mode is enabled
      if (selectedTimes.any((time) => time['start'] == selectedTime['start'] && time['end'] == selectedTime['end'])) {
        // Deselect the time slot if it is already selected
        onChange(
          selectedTimes
              .where((time) => time['start'] != selectedTime['start'] || time['end'] != selectedTime['end'])
              .toList(),
        );
      } else {
        // Select the new time slot
        onChange([...selectedTimes, selectedTime]);
      }
    }
  }

  bool isSelected(Map<String, String> itemValue) {
    return isSingleSelect
        ? value.isNotEmpty && value[0]['start'] == itemValue['start'] && value[0]['end'] == itemValue['end']
        : value.any((time) => time['start'] == itemValue['start'] && time['end'] == itemValue['end']);
  }

  @override
  Widget build(BuildContext context) {
    // Filter available time slots based on the provided times
    final filteredDays = (times != null && times!.isNotEmpty)
        ? days.where((day) => times!.any((time) => time.start == day['start'] && time.end == day['end'])).toList()
        : days;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 10, // Horizontal space between items
            runSpacing: 10, // Vertical space between lines
            children: filteredDays.map((item) {
              final selected = isSelected(item);
              return SizedBox(
                width: (MediaQuery.of(context).size.width / 2.3), // Set width to half of the screen width minus spacing
                child: GestureDetector(
                  onTap: () => handleSelectTime(item),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: disabled
                          ? (selected ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.2))
                          : (selected ? primaryColor : const Color(0xFFF5F3F4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add padding for better touch area
                    child: Text(
                      item['label']!,
                      style: TextStyle(
                        color: disabled
                            ? (selected ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.2))
                            : (selected ? Colors.white : Colors.black54),
                        fontWeight: FontWeight.w600,
                      ),
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
