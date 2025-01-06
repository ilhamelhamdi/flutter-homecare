import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 10),
            Text('MedMapCare'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Simplify homecare bookings with expert Healthcare Specialists at your fingertips!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/illustration.png', // Ganti dengan path ilustrasi Anda
              width: 394,
              height: 394,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 357,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text('Get Started'),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle tap
              },
              child: Text(
                'Powered by MedMap',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
