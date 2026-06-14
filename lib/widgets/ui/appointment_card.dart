import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentCard extends StatelessWidget {
  final String status;
  final String name;
  final String time;
  final String id;
  final bool isVertical;
  final bool isPatient;

  const AppointmentCard({
    super.key,
    required this.status,
    required this.name,
    required this.time,
    required this.id,
    required this.isVertical,
    required this.isPatient,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'waiting':
        return primaryColor;
      case 'ongoing':
        return textColor;
      case 'canceled':
        return Colors.red;
      case 'completed':
        return successColor;
      default:
        return Colors.white;
    }
  }

  void _navigateToDetail(BuildContext context) {
    if (isPatient) {
      Get.toNamed(Routes.DETAIL_COMPLETED_PASIEN, arguments: id);
    } else {
      Get.toNamed(Routes.DETAIL_COMPLETED, arguments: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: isVertical
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: _getStatusColor().withOpacity(0.1),
                          ),
                          child: Text(
                            status.capitalize!,
                            style: TextStyle(fontWeight: FontWeight.bold, color: _getStatusColor(), fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 15),
                            SizedBox(width: 5),
                            Text(
                              time,
                              style: const TextStyle(color: textColor, fontSize: 12),
                            ),
                          ],
                        ),
                        if (status.toLowerCase() == 'canceled' || status.toLowerCase() == 'completed')
                          Icon(
                            status.toLowerCase() == 'canceled' ? Icons.cancel : Icons.check_circle,
                            color: _getStatusColor(),
                            size: 20,
                          ),
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: $name",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    "Time: $time",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}
