import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/courses.dart';
import '../theme.dart';

const String editCourseText = "Edit Course";

class EditCoursePage extends StatefulWidget {
  final CourseModel course;
  const EditCoursePage({super.key, required this.course});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController imageUrlController;
  late TextEditingController videoController;
  late TextEditingController contentController;

  bool isOwner = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.course.title);
    imageUrlController = TextEditingController(text: widget.course.imageUrl);
    videoController = TextEditingController(text: widget.course.videoUrl);
    contentController = TextEditingController(text: widget.course.content);

    isOwner = currentUser != null && currentUser!.uid == widget.course.creatorId;
  }

  @override
  void dispose() {
    titleController.dispose();
    imageUrlController.dispose();
    videoController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> updateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (!isOwner) return;

    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .update({
        'title': titleController.text.trim(),
        'imageUrl': imageUrlController.text.trim(),
        'videoUrl': videoController.text.trim(),
        'content': contentController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course updated successfully")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
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
    bool enabled = true,
    bool showImagePreview = false,
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
        if (showImagePreview && controller != null && controller.text.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              controller.text,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    "Image not supported. Try another URL.",
                    style: TextStyle(color: Colors.black54, fontFamily: "Inter"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: validator,
            onChanged: (_) {
              if (showImagePreview) setState(() {}); // refresh preview
            },
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
                      editCourseText,
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                              hint: "Course title..",
                              controller: titleController,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter title' : null,
                              enabled: isOwner,
                            ),
                            buildInputField(
                              label: "Image Illustration",
                              hint: "Paste image URL",
                              controller: imageUrlController,
                              enabled: isOwner,
                              showImagePreview: true,
                            ),
                            buildInputField(
                              label: "Video Material",
                              hint: "Embed a video",
                              controller: videoController,
                              enabled: isOwner,
                            ),
                            buildInputField(
                              label: "Content of Material",
                              hint: "Content of Material.....",
                              controller: contentController,
                              maxLines: 7,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter content' : null,
                              enabled: isOwner,
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
                              backgroundColor: isOwner ? Colors.blue[600] : Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isOwner ? updateCourse : null,
                            child: const Text(
                              "Update & Publish",
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
                              Navigator.pop(context, false);
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
                    if (!isOwner) ...[
                      const SizedBox(height: 16),
                      const Text(
                        "⚠️ You can only edit courses you created.",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
