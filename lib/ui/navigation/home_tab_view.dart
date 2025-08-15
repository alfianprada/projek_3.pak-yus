import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_samples/ui/components/vcard.dart';
import 'package:flutter_samples/ui/components/hcard.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/theme.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: topPadding + 60, bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title "Courses"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Courses",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
              ),
              const SizedBox(height: 10),

              // Courses horizontal scroll
              SizedBox(
                height: 300, // tinggi container supaya VCard tidak terpotong
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No courses available."),
                      );
                    }

                    final courses = snapshot.data!.docs;

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final data = courses[index].data() as Map<String, dynamic>;
                        return SizedBox(
                          width: screenWidth > 992 ? 250 : 200,
                          child: VCard(
                            course: CourseModel.fromMap(
                              courses[index].id,
                              data,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Title "Recent"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
              ),
              const SizedBox(height: 10),

              // Recent courses grid
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .orderBy('createdAt', descending: true)
                    .limit(4)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No recent courses."),
                    );
                  }

                  final recentCourses = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: recentCourses.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final cardWidth = screenWidth > 992
                            ? (screenWidth - 30) / 2
                            : screenWidth - 20;
                        return SizedBox(
                          width: cardWidth,
                          child: HCard(
                            section: CourseModel.fromMap(doc.id, data),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
