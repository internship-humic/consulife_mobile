import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String title;

  final String time;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.time,
    // Ganti dengan primaryColor jika perlu
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 50),
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Every $title",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text("at", style: TextStyle(color: Colors.white)),
          Text(time, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
