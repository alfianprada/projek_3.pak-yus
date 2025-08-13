import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_samples/ui/theme.dart'; // sesuaikan dengan path proyekmu
import 'package:cached_network_image/cached_network_image.dart';

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

  Future<void> saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final imageUrl = imageUrlController.text.trim().isNotEmpty
        ? imageUrlController.text.trim()
        : 'https://via.placeholder.com/150'; // default image online
    final video = videoController.text.trim();
    final content = contentController.text.trim();

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
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: "courses title..",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Enter title' : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Image Illustration (URL or leave empty for default)",
                              style: TextStyle(
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
                                controller: imageUrlController,
                                decoration: const InputDecoration(
                                  hintText: "Paste image URL or leave empty",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Video Material",
                              style: TextStyle(
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
                                controller: videoController,
                                decoration: const InputDecoration(
                                  hintText: "embed a video",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Content of Material",
                              style: TextStyle(
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
                                controller: contentController,
                                maxLines: 7,
                                decoration: const InputDecoration(
                                  hintText: "Content of Material.....",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Enter content' : null,
                              ),
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

class CourseListPage extends StatelessWidget {
  const CourseListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: data['imageUrl'] != null && data['imageUrl'] != ''
                      ? CachedNetworkImage(
                          imageUrl: data['imageUrl'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.image),
                  title: Text(data['title'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data['videoUrl'] != null && data['videoUrl'] != '')
                        Text(
                          'Video: ${data['videoUrl']}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
