import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_samples/ui/theme.dart';
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

    String imageUrl = 'https://via.placeholder.com/150';

    if (imageUrlInput.isNotEmpty) {
      bool valid = await _checkImageUrl(imageUrlInput);
      if (!valid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image Link Not Supported. Try Another Image.")),
        );
        return;
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

  Widget buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: validator,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
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
                          children: [
                            buildInputField(
                              label: "Course Title",
                              hint: "courses title..",
                              controller: titleController,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter title' : null,
                            ),
                            buildInputField(
                              label: "Image Illustration",
                              hint: "Paste image URL or leave empty",
                              controller: imageUrlController,
                            ),
                            buildInputField(
                              label: "Video Material",
                              hint: "embed a video",
                              controller: videoController,
                            ),
                            buildInputField(
                              label: "Content of Material",
                              hint: "Content of Material.....",
                              controller: contentController,
                              maxLines: 7,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter content' : null,
                            ),
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
