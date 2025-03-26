import 'package:flutter/material.dart';
import 'package:cipherx/screens/add_screen.dart';
import 'package:cipherx/screens/home_screen.dart';
import 'package:cipherx/screens/profile_screen.dart';
import 'package:cipherx/screens/statistics_screen.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexcolor = 0;
  List screen = [
    const Home(),
    const Statistics(),
    const Home(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[indexcolor],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddScreen()));
        },
        backgroundColor: const Color(0xff7F3DFF),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexcolor = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: indexcolor == 0
                      ? const Color(0xff7F3DFF)
                      : const Color(0xffC6C6C6),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexcolor = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: indexcolor == 1
                      ? const Color(0xff7F3DFF)
                      : const Color(0xffC6C6C6),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexcolor = 2;
                  });
                },
                child: Icon(
                  Icons.pie_chart,
                  size: 30,
                  color: indexcolor == 2
                      ? const Color(0xff7F3DFF)
                      : const Color(0xffC6C6C6),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexcolor = 3;
                  });
                },
                child: Icon(
                  Icons.person_sharp,
                  size: 30,
                  color: indexcolor == 3
                      ? const Color(0xff7F3DFF)
                      : const Color(0xffC6C6C6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
