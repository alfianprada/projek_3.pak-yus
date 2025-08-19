import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/courses.dart';
import '../theme.dart';
import '../screen/editcourse.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseModel course;

  const CourseDetailPage({super.key, required this.course});

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted')),
        );
      }
    }
  }

  Future<void> _launchVideo(BuildContext context) async {
    if (course.videoUrl.isEmpty) return;
    final url = Uri.parse(course.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch video')),
        );
      }
    }
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final randomColor = getRandomColor();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isCreator = course.creatorId == currentUserId; // hanya creator

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
                    /// Image with error handling
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
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text(
                              "Image Link Not Supported. Try Another Image.",
                              style: TextStyle(color: Colors.black54, fontFamily: "Inter"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Video link
                    if (course.videoUrl.isNotEmpty)
                      InkWell(
                        onTap: () => _launchVideo(context),
                        child: Text(
                          course.videoUrl,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),

                    /// Date
                    Text(
                      getFormattedDate(course.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// Content card with random color
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: randomColor,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          course.content.isNotEmpty
                              ? course.content
                              : "No content available.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Buttons (Edit & Delete hanya untuk creator)
                    if (isCreator)
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
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCoursePage(course: course),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Course updated!')),
                                  );
                                }
                              },
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
