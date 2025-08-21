// Import package bawaan Flutter untuk UI
import 'package:flutter/material.dart';
// Import Cloud Firestore untuk membaca/menulis data ke database Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
// Import FirebaseAuth untuk mengambil informasi user yang login
import 'package:firebase_auth/firebase_auth.dart';
// Import model Course (kelas buatan sendiri)
import '../models/courses.dart';
// Import tema custom aplikasi
import '../theme.dart';

// Konstanta teks judul halaman
const String editCourseText = "Edit Course";

// Halaman Edit Course -> Stateful karena butuh state (misalnya perubahan text input, validasi, dll.)
class EditCoursePage extends StatefulWidget {
  final CourseModel course; // Course yang akan diedit dikirim lewat parameter
  const EditCoursePage({super.key, required this.course});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  // Kunci untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller input form (untuk menangani input teks)
  late TextEditingController titleController;
  late TextEditingController imageUrlController;
  late TextEditingController videoController;
  late TextEditingController contentController;

  // Flag apakah user yang login adalah pemilik course
  bool isOwner = false;

  // User yang sedang login sekarang
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Isi awal controller dengan data dari course yang dikirim
    titleController = TextEditingController(text: widget.course.title);
    imageUrlController = TextEditingController(text: widget.course.imageUrl);
    videoController = TextEditingController(text: widget.course.videoUrl);
    contentController = TextEditingController(text: widget.course.content);

    // Cek apakah user login adalah pemilik course
    isOwner = currentUser != null && currentUser!.uid == widget.course.creatorId;
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    titleController.dispose();
    imageUrlController.dispose();
    videoController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // Fungsi untuk update data course di Firestore
  Future<void> updateCourse() async {
    // Validasi form (jika invalid -> return)
    if (!_formKey.currentState!.validate()) return;
    // Cegah update jika bukan owner
    if (!isOwner) return;

    try {
      // Update data ke Firestore berdasarkan ID course
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .update({
        'title': titleController.text.trim(),
        'imageUrl': imageUrlController.text.trim(),
        'videoUrl': videoController.text.trim(),
        'content': contentController.text.trim(),
      });

      // Jika widget masih ada, tampilkan snackbar sukses
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course updated successfully")),
      );
      // Tutup halaman edit dan kirim hasil true (berhasil update)
      Navigator.pop(context, true);
    } catch (e) {
      // Jika error, tampilkan pesan error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Widget helper untuk membangun input field
  Widget buildInputField({
    required String label, // Judul field
    required String hint, // Hint/placeholder
    TextEditingController? controller,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool enabled = true,
    bool showImagePreview = false, // Jika true, tampilkan preview gambar
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label field
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

        // Jika showImagePreview true dan URL valid -> tampilkan preview gambar
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
              // Jika error (URL gambar salah), tampilkan fallback
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

        // Input form
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            enabled: enabled, // hanya bisa edit jika owner
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
            // Jika preview gambar aktif, maka update preview saat teks berubah
            onChanged: (_) {
              if (showImagePreview) setState(() {});
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Bangun UI utama halaman
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2, // warna background (dari theme custom)
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
                key: _formKey, // pakai form untuk validasi
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    // Judul halaman
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

                    // Kartu yang berisi form input
                    Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Input title
                            buildInputField(
                              label: "Course Title",
                              hint: "Course title..",
                              controller: titleController,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter title' : null,
                              enabled: isOwner,
                            ),
                            // Input image + preview
                            buildInputField(
                              label: "Image Illustration",
                              hint: "Paste image URL",
                              controller: imageUrlController,
                              enabled: isOwner,
                              showImagePreview: true,
                            ),
                            // Input video
                            buildInputField(
                              label: "Video Material",
                              hint: "Embed a video",
                              controller: videoController,
                              enabled: isOwner,
                            ),
                            // Input content
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

                    // Tombol Update & Cancel
                    Row(
                      children: [
                        // Tombol Update & Publish
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
                            onPressed: isOwner ? updateCourse : null, // hanya aktif jika owner
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
                        // Tombol Cancel
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
                              Navigator.pop(context, false); // kembali tanpa update
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

                    // Pesan warning jika bukan owner
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
