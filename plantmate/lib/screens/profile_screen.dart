import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            Text('Welcome to Profile!'),
          ],
        ),
      ),
    );
  }
}