import 'package:flutter/material.dart';
import 'package:valoapp/screens/profile.dart';
import 'duelist.dart';
import 'initiator.dart';
import 'controller.dart';
import 'sentinel.dart';
import 'agent.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  static final List<Widget> _widgetOptions = <Widget>[
    InitiatorScreen(),
    DuelistScreen(),
    AllAgentsScreen(),
    ControllerScreen(),
    SentinelScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 113, 112, 112),
        selectedItemColor: Color.fromRGBO(249, 52, 69, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Initiator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_kabaddi),
            label: 'Duelist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Agent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portable_wifi_off),
            label: 'Controller',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Sentinel',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
