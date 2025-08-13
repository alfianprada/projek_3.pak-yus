import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

class VCard extends StatelessWidget {
  final CourseModel course;

  const VCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (course.images.isNotEmpty) {
      if (course.images.startsWith('http')) {
        imageWidget = Image.network(
          course.images,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 80, color: Colors.white),
        );
      } else {
        imageWidget = Image.asset(
          course.images,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/default.png',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/images/default.png',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported, size: 40, color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260, maxHeight: 310),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [course.color, course.color.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: course.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: course.color.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (course.subtitle != null)
                  Text(
                    course.subtitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  course.caption.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              right: -10,
              top: -10,
              child: imageWidget,
            ),
          ],
        ),
      ),
    );
  }
}
