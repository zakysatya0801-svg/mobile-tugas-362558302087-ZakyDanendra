import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';

class AcademicDashboardScreen extends StatelessWidget {
  const AcademicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = Course.getSampleCourses();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ruang Praktikum Hari Ini',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month_rounded,
                            size: 16, color: Color(0xFF0284C7)),
                        SizedBox(width: 6),
                        Text(
                          '3 sesi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.meeting_room_rounded,
                            size: 16, color: Color(0xFF10B981)),
                        SizedBox(width: 6),
                        Text(
                          '1 ruang tersedia',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 2 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent:
                            175, // Ukuran disesuaikan dari 160 ke 175 agar bebas overflow
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: courses[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
