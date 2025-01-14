import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const <Widget>[
            Text('Welcome to Group!'),
          ],
        ),
      ),
    );
  }
}