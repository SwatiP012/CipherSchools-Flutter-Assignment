import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cipherx/screens/auth/login_screen.dart';
import 'package:cipherx/screens/auth/verification_screen.dart';
import 'package:cipherx/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _isLoading = false;
  bool activeConnection = false;
  String T = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!mounted) return;
        setState(() => activeConnection = true);
      }
    } on SocketException catch (_) {
      if (!mounted) return;
      setState(() {
        activeConnection = false;
        T = "Turn on the internet and try again";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserConnection();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 80),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// NAME
                    TextFormField(
                      controller: nameController,
                      decoration:
                          _inputDecoration("Name", Icons.account_circle),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 15),

                    /// EMAIL
                    TextFormField(
                      controller: emailController,
                      decoration:
                          _inputDecoration("Email", Icons.email_outlined),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter email' : null,
                    ),
                    const SizedBox(height: 15),

                    /// PASSWORD
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration:
                          _inputDecoration("Password", Icons.lock_outline),
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 40),

                    /// SIGN UP BUTTON
                    GestureDetector(
                      onTap: () => _signUpUser(),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create an account",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ALREADY HAVE ACCOUNT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          ),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// OR DIVIDER
                    Row(children: <Widget>[
                      Expanded(child: Divider(color: Colors.grey[400])),
                      const Text(" or ", style: TextStyle(color: Colors.grey)),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ]),
                    const SizedBox(height: 15),

                    /// GOOGLE SIGN IN
                    ElevatedButton(
                      onPressed: () => _signInWithGoogle(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text("Continue with Google",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    ));
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      suffixIcon: Icon(icon, size: 20, color: Colors.indigo),
    );
  }

  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      String res = await _authController.signUpUser(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      if (!mounted) return;
      if (res != 'success') {
        setState(() => _isLoading = false);
        if (!mounted) return;
        showSnackBarr(res, context);
      } else {
        if (!mounted) return;
        showSnackBarr(
            'Account created successfully! Please verify your email.', context);

        // Update user display name locally if needed
        await FirebaseAuth.instance.currentUser?.reload();

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Verify()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackbar('An error occurred: ${e.toString()}', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    String res = await _authController.signinWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res != 'success') {
      _showSnackbar(res, isError: true);
    } else {
      _showSnackbar('Signed in successfully!');
      Navigator.pushReplacementNamed(context, '/bottom');
    }
  }
}
