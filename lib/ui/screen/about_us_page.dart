import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/assets.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo / image
                Image.asset(topi, width: 140, height: 140),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Unleash Your Learning Power",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontFamilyFallback: ['NotoColorEmoji'],
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  "Smart. Interactive. Fun.\nAll-in-one course management for students and teachers alike.",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontFamilyFallback: ['NotoColorEmoji'],
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Description
                const Text(
                  "CourseMaster was born from the idea that managing courses "
                  "should be simple, engaging, and efficient. Developed by Team XII RPL 1, "
                  "our mission is to empower both teachers and students "
                  "through intuitive and interactive tools.",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontFamilyFallback: ['NotoColorEmoji'],
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Animated feature cards
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _featureCard(
                          topic_1,
                          "Organize Courses",
                          "Plan and manage all your courses in one place.",
                        ),
                        const SizedBox(width: 16),
                        _featureCard(
                          topic_2,
                          "Track Students",
                          "Monitor progress, attendance, and performance easily.",
                        ),
                        const SizedBox(width: 16),
                        _featureCard(
                          topic_3,
                          "Interactive Lessons",
                          "Engage students with interactive and fun learning.",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Footer text
                const Text(
                  "Developed with ❤️ by Team XII RPL 1\nEmpowering Education Together",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontFamilyFallback: ['NotoColorEmoji'],
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Call to action
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Text(
                    "Join us today and elevate your learning experience!",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontFamilyFallback: ['NotoColorEmoji'],
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureCard(String imagePath, String title, String description) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontFamilyFallback: ['NotoColorEmoji'],
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontFamilyFallback: ['NotoColorEmoji'],
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
