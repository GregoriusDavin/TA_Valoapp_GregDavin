import 'package:flutter/material.dart';
import 'dart:convert';
import 'detail.dart';
import 'profile.dart'; // Import the ProfilePage
import 'package:http/http.dart' as http;

class AllAgentsScreen extends StatefulWidget {
  @override
  _AllAgentsScreenState createState() => _AllAgentsScreenState();
}

class _AllAgentsScreenState extends State<AllAgentsScreen> {
  late Future<List<Agent>> allAgents;

  @override
  void initState() {
    super.initState();
    allAgents = fetchAllAgents();
  }

  Future<List<Agent>> fetchAllAgents() async {
    final response =
        await http.get(Uri.parse('https://valorant-api.com/v1/agents'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Agent> agents = (data['data'] as List)
          .map((agentData) => Agent.fromJson(agentData))
          .toList();

      return agents;
    } else {
      throw Exception('Failed to load agent data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Agents'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Agent>>(
        future: allAgents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No agents found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Agent agent = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: {
                        'uuid': agent.uuid,
                        'title': agent.displayName,
                      },
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(agent.displayIconSmall),
                      backgroundColor: const Color.fromRGBO(15, 25, 35, 1),
                    ),
                    title: Text(
                      agent.displayName,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'TungstenBold',
                        color: const Color.fromARGB(255, 190, 190, 190),
                      ),
                    ),
                  ),
                  splashColor: Color.fromRGBO(249, 52, 69, 1),
                );
              },
            );
          }
        },
      ),
      backgroundColor: const Color.fromRGBO(15, 25, 35, 1),
    );
  }
}

class Agent {
  final String uuid;
  final String displayName;
  final Role role;
  final String displayIconSmall;
  final List<String> characterTags;

  Agent({
    required this.uuid,
    required this.displayName,
    required this.role,
    required this.displayIconSmall,
    required this.characterTags,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
      role: Role.fromJson(json['role'] ?? {}),
      displayIconSmall: json['displayIconSmall'] ?? '',
      characterTags: List<String>.from(json['characterTags'] ?? []),
    );
  }
}

class Role {
  final String uuid;
  final String displayName;

  Role({
    required this.uuid,
    required this.displayName,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }
}
