import 'package:flutter/material.dart';
import 'screens/detail.dart';
import 'screens/duelist.dart';
import 'screens/controller.dart';
import 'screens/initiator.dart';
import 'screens/sentinel.dart';
import 'screens/profile.dart';
import 'screens/home.dart';
import 'screens/agent.dart';

void main() {
  runApp(ValoApp());
}

class ValoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAL AGENT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfilePage(),
        '/duelist': (context) => DuelistScreen(),
        '/initiator': (context) => InitiatorScreen(),
        '/controller': (context) => ControllerScreen(),
        '/sentinel': (context) => SentinelScreen(),
        '/agent': (context) => AllAgentsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetailPage(
              uuid: args['uuid'],
              title: args['title'],
            ),
          );
        }
        return null;
      },
    );
  }
}
