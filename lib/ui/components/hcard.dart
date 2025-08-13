import 'package:flutter/material.dart';
import '../models/courses.dart';
import '../screen/detailcourse.dart';

class HCard extends StatelessWidget {
  final CourseModel section;
  const HCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: section),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image.network(
              section.imageUrl,
              height: 100,
              width: 100, // <-- FIX: set a fixed width
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (section.content.isNotEmpty)
                      Text(
                        section.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}