import 'package:celebrare/home.dart';
import 'package:flutter/material.dart';

class YourAnimatedSplashWidget extends StatefulWidget {
  @override
  _YourAnimatedSplashWidgetState createState() =>
      _YourAnimatedSplashWidgetState();
}

class _YourAnimatedSplashWidgetState extends State<YourAnimatedSplashWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1), // Adjust the duration as needed
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'images/celebrare.jpg', // Replace with your image asset path
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds and then navigate to the next screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YourAnimatedSplashWidget(),
      ),
    );
  }
}
