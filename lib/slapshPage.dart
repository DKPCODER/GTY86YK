import 'package:assgn1/homePage.dart';
import 'package:assgn1/login_page.dart';
import 'package:assgn1/sharedPreference.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool login = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  void islogin() async {
    login = await SharedPreference.isLoggedIn;
  }

  @override
  void initState() {
    super.initState();
    islogin();
    Future.delayed(Duration(seconds: 3), () {
      if (login) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust duration as needed
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1, 0), // Start position (top of the screen)
      end: Offset.zero, // End position (center of the screen)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(65, 75, 68, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: size.width * 1,
                  // height: 100,
                  child: Image.asset('assets/logo1.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
