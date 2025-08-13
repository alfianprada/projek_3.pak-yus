import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/courses.dart';
import '../theme.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseModel course;

  const CourseDetailPage({super.key, required this.course});

  Future<void> _deleteCourse(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance.collection('courses').doc(course.id).delete();
      if (context.mounted) {
        Navigator.pop(context); // Go back after delete
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            backgroundColor: RiveAppTheme.background,
            appBar: AppBar(
              title: Text(
                course.title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: RiveAppTheme.background,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Image.network(
                        course.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.videoUrl,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // If you want to show content as subtitle
                    if (course.content.isNotEmpty)
                      Text(
                        course.content,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blueGrey, // Use a default color
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          course.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[500],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _deleteCourse(context),
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}