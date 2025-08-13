import 'package:flutter/material.dart';
import '../models/courses.dart';
import '../screen/detailcourse.dart';

class VCard extends StatelessWidget {
  final CourseModel course;
  const VCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Image.network(
              course.imageUrl,
              height: 120,
              width: 120, // <-- FIX: set a fixed width
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (course.content.isNotEmpty)
                    Text(
                      course.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}