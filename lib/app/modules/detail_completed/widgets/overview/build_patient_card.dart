import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/string_helper.dart';
import '../../controllers/detail_completed_controller.dart';

class BuildPatientCard extends GetView<DetailCompletedController> {
  const BuildPatientCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = controller.appointmentDetail.value!;
    final user = appointment.user;

    final String fullName = '${user.firstname} ${user.lastname}'.trim();

    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFE8F1FC), borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person_search_outlined, color: Color(0xFF0066CC), size: 25),
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Text(
                    'Patient Detail',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF111827), height: 1.2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _buildPatientDetailItem(label: 'FULL NAME', value: fullName),
            _buildPatientDetailItem(label: 'GENDER', value: _capitalize(user.gender.toString())),
            _buildPatientDetailItem(label: 'EMAIL', value: user.email.toString()),
            _buildPatientDetailItem(label: 'PHONE', value: user.phoneNumber.toString()),
            _buildPatientDetailItem(
              label: 'APPOINTMENT DATE',
              value: '${formatDate(appointment.date)}, ${appointment.startTime}',
              bottomSpacing: 0,
            ),

            // Tombol hanya muncul sesuai status appointment
            Obx(() {
              final status = controller.appointmentDetail.value?.status.toLowerCase();

              if (status == 'ongoing') {
                return Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: _buildPatientActionButton(
                    label: 'Done',
                    backgroundColor: const Color(0xFF22A447),
                    onPressed: () {
                      controller.done(Get.context!);
                    },
                  ),
                );
              }

              if (status == 'waiting') {
                return Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: _buildPatientActionButton(
                    label: 'Cancel',
                    backgroundColor: const Color(0xFFFF5138),
                    onPressed: () {
                      controller.cancel(Get.context!);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailItem({required String label, required String value, double bottomSpacing = 20}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: Color(0xFF8B99B2),
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.isEmpty ? '-' : value,
            softWrap: true,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF172033), height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientActionButton({
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }

  String _capitalize(String value) {
    final cleanedValue = value.trim();

    if (cleanedValue.isEmpty) {
      return '-';
    }

    return '${cleanedValue[0].toUpperCase()}'
        '${cleanedValue.substring(1).toLowerCase()}';
  }
}
