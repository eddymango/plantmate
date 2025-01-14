import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plantmate/screens/group_screen.dart';
import 'package:plantmate/screens/home_screen.dart';
import 'package:plantmate/screens/profile_screen.dart';



final List<BottomNavigationBarItem> tabs = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.group),label: 'Groups'),
  BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: 'Profile'),
];


final List<Widget> myTabItems = [
  HomeScreen(),
  GroupScreen(),
  ProfileScreen(),
];




class PlantMateApp extends StatefulWidget {
  const PlantMateApp({super.key});

  @override
  State<PlantMateApp> createState() => _PlantMateAppState();
}

class _PlantMateAppState extends State<PlantMateApp> {

  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {

      log("index: $index");
      _selectedIndex = index;
    });
  }



 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantmate',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(length: tabs.length, child: Scaffold(
        appBar: AppBar(
          title: const Text('Plantmate'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: tabs,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: myTabItems,
        ),
      )),
    );
  }
}