import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_samples/ui/theme.dart'; // sesuaikan dengan path proyekmu
import 'package:http/http.dart' as http;

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final videoController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    imageUrlController.dispose();
    videoController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<bool> _checkImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      // cek content-type harus gambar
      if (response.statusCode == 200 &&
          response.headers['content-type'] != null &&
          response.headers['content-type']!.startsWith('image/')) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final imageUrlInput = imageUrlController.text.trim();
    final video = videoController.text.trim();
    final content = contentController.text.trim();

    String imageUrl = 'https://via.placeholder.com/150'; // default

    if (imageUrlInput.isNotEmpty) {
      bool valid = await _checkImageUrl(imageUrlInput);
      if (!valid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Image Link Not Supported. Try Another Image.")),
        );
        return; // stop saving
      } else {
        imageUrl = imageUrlInput;
      }
    }

    try {
      await FirebaseFirestore.instance.collection('courses').add({
        'title': title,
        'imageUrl': imageUrl,
        'videoUrl': video,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course saved successfully")),
      );

      titleController.clear();
      imageUrlController.clear();
      videoController.clear();
      contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Add Courses',
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Course Title",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                hintText: "courses title..",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter title' : null,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Image Illustration (URL or leave empty for default)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: imageUrlController,
                              decoration: const InputDecoration(
                                hintText: "Paste image URL or leave empty",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Video Material",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: videoController,
                              decoration: const InputDecoration(
                                hintText: "embed a video",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Content of Material",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: contentController,
                              maxLines: 7,
                              decoration: const InputDecoration(
                                hintText: "Content of Material.....",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter content' : null,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: saveCourse,
                            child: const Text(
                              "Save & Publish",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
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
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              titleController.clear();
                              imageUrlController.clear();
                              videoController.clear();
                              contentController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Form cleared")),
                              );
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
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
