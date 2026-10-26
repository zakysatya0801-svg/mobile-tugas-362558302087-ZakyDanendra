import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  Map<String, Color> _getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'berlangsung':
        return {
          'badgeBg': const Color(0xFF0284C7),
          'badgeText': Colors.white,
          'footerBg': const Color(0xFFE0F2FE),
          'footerText': const Color(0xFF0369A1),
          'iconColor': const Color(0xFF0284C7),
        };
      case 'akan datang':
        return {
          'badgeBg': const Color(0xFFFEF3C7),
          'badgeText': const Color(0xFF92400E),
          'footerBg': const Color(0xFFFFFBEB),
          'footerText': const Color(0xFFB45309),
          'iconColor': const Color(0xFFB45309),
        };
      case 'selesai':
        return {
          'badgeBg': const Color(0xFFE5E7EB),
          'badgeText': const Color(0xFF4B5563),
          'footerBg': const Color(0xFFF3F4F6),
          'footerText': const Color(0xFF4B5563),
          'iconColor': const Color(0xFF4B5563),
        };
      case 'tersedia':
      default:
        return {
          'badgeBg': const Color(0xFF10B981),
          'badgeText': Colors.white,
          'footerBg': const Color(0xFFE6F4EA),
          'footerText': const Color(0xFF047857),
          'iconColor': const Color(0xFF10B981),
        };
    }
  }

  IconData _getFooterIcon(String status) {
    switch (status.toLowerCase()) {
      case 'berlangsung':
        return Icons.group_rounded;
      case 'akan datang':
        return Icons.access_time_filled_rounded;
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'tersedia':
      default:
        return Icons.meeting_room_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(course.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors['badgeBg'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course.status,
                  style: TextStyle(
                    color: colors['badgeText'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (course.waktu.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 6),
                Text(
                  course.waktu,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  course.room,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors['footerBg'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _getFooterIcon(course.status),
                  size: 18,
                  color: colors['iconColor'],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    course.note ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors['footerText'],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
