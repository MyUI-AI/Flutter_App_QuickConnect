import 'package:flutter/material.dart';
import 'login_page.dart';

class ScreenSaver extends StatefulWidget {
  @override
  _ScreenSaverState createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Loop the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Navigate to login page when clicked
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 180),
              child: Image.asset(
                'assets/images/MyUI_logo.png', // Your logo path
                height: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
