// 📦 Import library Flutter untuk UI
import 'package:flutter/material.dart';

// 📦 Import Firebase Firestore (database realtime / cloud storage)
import 'package:cloud_firestore/cloud_firestore.dart';

// 📦 Import file tema custom dari project
import 'package:flutter_samples/ui/theme.dart';

// 📦 Import http untuk melakukan request (validasi URL gambar)
import 'package:http/http.dart' as http;

// 📦 Import Firebase Auth untuk identifikasi user yang sedang login
import 'package:firebase_auth/firebase_auth.dart';

/// ✅ Halaman untuk menambahkan Course baru
class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

/// ✅ State dari halaman AddCoursePage
class _AddCoursePageState extends State<AddCoursePage> {
  // 🔑 Global key untuk memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // 📌 Controller input untuk form
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final videoController = TextEditingController();
  final contentController = TextEditingController();

  // ❌ Jangan lupa dispose controller agar tidak memory leak
  @override
  void dispose() {
    titleController.dispose();
    imageUrlController.dispose();
    videoController.dispose();
    contentController.dispose();
    super.dispose();
  }

  /// 🔍 Mengecek apakah link yang diinput user adalah gambar valid
  Future<bool> _checkImageUrl(String url) async {
    try {
      // Cek header dari URL (hanya metadata, lebih ringan dari GET)
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200 &&
          response.headers['content-type'] != null &&
          response.headers['content-type']!.startsWith('image/')) {
        return true; // ✅ valid image
      }
      return false;
    } catch (_) {
      return false; // ❌ gagal parsing atau bukan gambar
    }
  }

  /// 💾 Simpan data course ke Firestore
  Future<void> saveCourse() async {
    // Cek validasi form
    if (!_formKey.currentState!.validate()) return;

    // Ambil nilai dari TextFormField
    final title = titleController.text.trim();
    final imageUrlInput = imageUrlController.text.trim();
    final video = videoController.text.trim();
    final content = contentController.text.trim();

    // Default placeholder jika user tidak isi gambar
    String imageUrl = 'https://via.placeholder.com/150';

    // Jika user isi URL gambar → cek valid
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
      // 🚀 Simpan ke Firestore
      await FirebaseFirestore.instance.collection('courses').add({
        'title': title,
        'imageUrl': imageUrl,
        'videoUrl': video,
        'content': content,
        'creatorId': FirebaseAuth.instance.currentUser!.uid, // ✅ ID user yang bikin course
        'createdAt': FieldValue.serverTimestamp(), // timestamp server, supaya konsisten
      });

      // ✅ Notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course saved successfully")),
      );

      // Reset form setelah berhasil
      titleController.clear();
      imageUrlController.clear();
      videoController.clear();
      contentController.clear();
    } catch (e) {
      // ❌ Jika error tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// 📝 Membuat widget input field custom (biar gak copy-paste)
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
          label, // label form
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
            validator: validator, // validasi input
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// 🖥️ UI utama dari halaman Add Course
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2, // 🎨 background custom
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
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 60, 
                // ⬆️ biar form scroll aman kalau keyboard muncul
              ),
              child: Form(
                key: _formKey, // 🔑 pakai form key untuk validasi
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

                    /// 📝 Card form input
                    Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // 🏷️ Input Title
                            buildInputField(
                              label: "Course Title",
                              hint: "courses title..",
                              controller: titleController,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter title' : null,
                            ),
                            // 🖼️ Input Image
                            buildInputField(
                              label: "Image Illustration",
                              hint: "Paste image URL or leave empty",
                              controller: imageUrlController,
                            ),
                            // 🎥 Input Video
                            buildInputField(
                              label: "Video Material",
                              hint: "embed a video",
                              controller: videoController,
                            ),
                            // 📄 Input Content
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

                    /// 🔘 Tombol aksi
                    Row(
                      children: [
                        // ✅ Save button
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
                            onPressed: saveCourse, // simpan ke firestore
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

                        // ❌ Cancel button (clear form)
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
                              // reset semua input
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
                    const SizedBox(height: 20),
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
