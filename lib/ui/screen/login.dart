import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_samples/ui/screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _showError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      _showError = false;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RiveAppHome()),
      );
    } on FirebaseAuthException catch (_) {
      setState(() {
        _showError = true;
      });
      _shakeController.forward(from: 0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_showError ? _shakeAnimation.value : 0, 0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFD3D3D3),
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 23, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: _showError ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/samples/images/bgawal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/samples/images/topi.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'SkillUp!',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  if (_showError) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Email or password is incorrect',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: loginUser,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
