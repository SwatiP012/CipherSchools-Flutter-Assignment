import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cipherx/screens/auth/login_screen.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    // final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF7B61FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Padding(
              padding: const EdgeInsets.only(top: 37, left: 16),
              child: Image.asset(
                "assets/app_logo.png",
                width: 59,
                height: 59,
                fit: BoxFit.contain,
              ),
            ),

            // Main Content
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Texts
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: 'ABeeZee',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.8,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'CipherX.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'Bruno Ace SC',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.72,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Forward Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const ShapeDecoration(
                        color: Color(0xBFECE1E1),
                        shape: OvalBorder(),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/forward_arrow.svg",
                          width: 25,
                          height: 48,
                          placeholderBuilder: (_) => const Icon(
                              Icons.arrow_forward,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tagline
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'The best way to track your expenses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.4,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
