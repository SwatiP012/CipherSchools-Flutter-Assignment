import 'package:flutter/material.dart';
import 'package:cipherx/widgets/profile_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cipherx/screens/auth/login_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/05.png"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0xFFAD00FF),
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: Color(0xFFF5F5F5),
                          blurRadius: 0,
                          offset: Offset(0, 0),
                          spreadRadius: 4,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          color: Color(0xFF90909F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            user?.displayName ?? 'Swati Patel',
                            style: const TextStyle(
                              color: Color(0xFF161719),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // TODO: Implement edit profile functionality
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ProfileMenu(
                    text: "Account",
                    icon: "assets/wallet 3.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Setting",
                    icon: "assets/settings.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Export Data",
                    icon: "assets/upload.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "LogOut",
                    icon: "assets/logout.svg",
                    press: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
