import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

import '../../../constants/color.dart';
import '../../../models/user.dart';
import '../../../utils/helpers/string_helper.dart';

class PsychologistCard extends StatelessWidget {
  final User psychologist;
  final VoidCallback onTap;

  const PsychologistCard({super.key, required this.psychologist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fullName = '${psychologist.firstname.capitalizeFirst} ${psychologist.lastname.capitalizeFirst}';
    final specialization = getSpecializationString(psychologist.psychologist?.specialization);
    final gender = psychologist.gender?.toString() ?? 'N/A';
    final experience = psychologist.psychologist?.workExperience?.toString() ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    psychologistAvatar(psychologist.profilePicture),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            specialization,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF8A94AA)),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [genderInfoBadge(gender), experienceInfoBadge(experience)],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: onTap,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Details', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget psychologistAvatar(String? imageUrl) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: hasImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _fallbackAvatar();
              },
            )
          : _fallbackAvatar(),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      padding: EdgeInsets.all(8),
      color: const Color(0xFFF3F6FA),
      child: const Icon(Icons.person, size: 50, color: primaryColor),
    );
  }

  Widget genderInfoBadge(String gender) {
    final normalizedGender = gender.toLowerCase();
    final icon = normalizedGender == 'male' ? Icons.male_rounded : Icons.female_rounded;

    return _infoBadge(icon, gender);
  }

  Widget experienceInfoBadge(String experience) {
    return _infoBadge(Icons.work_outline_rounded, '$experience');
  }

  Widget _infoBadge(IconData icon, String label) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Color(0xFF334155)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF334155), fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
