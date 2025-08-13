import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

class HCard extends StatelessWidget {
  final CourseModel section;

  const HCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (section.images.isNotEmpty) {
      if (section.images.startsWith('http')) {
        imageWidget = Image.network(
          section.images,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
        );
      } else {
        imageWidget = Image.asset(
          section.images,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/default.png',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/images/default.png',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      );
    }

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
            imageWidget,
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
                    if (section.subtitle != null)
                      Text(
                        section.subtitle!,
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