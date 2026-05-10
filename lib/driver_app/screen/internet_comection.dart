import 'package:flutter/material.dart';
import 'package:ride_booking/driver_app/screen/splash_screen.dart';

import '../constent/String.dart';


class LostInternetComection extends StatelessWidget {
  const LostInternetComection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/No connection.png",
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Whoops!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black54),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "NO internet connection found. Check your connection or try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Try again",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
