import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

class VCard extends StatefulWidget {
  const VCard({Key? key, required this.course}) : super(key: key);

  final CourseModel course;

  @override
  State<VCard> createState() => _VCardState();
}

class _VCardState extends State<VCard> {
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    cardColor = getRandomColor();
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} "
           "${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: widget.course),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260, maxHeight: 310),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: cardColor.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.course.title,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Content (max 3 lines)
            Text(
              widget.course.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            // Created at
            Text(
              formatDate(widget.course.createdAt),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
