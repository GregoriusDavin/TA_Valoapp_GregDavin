import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String uuid;
  final String title;

  const DetailPage({Key? key, required this.uuid, required this.title})
      : super(key: key);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  late Future<Agent> agent;

  @override
  void initState() {
    super.initState();
    agent = fetchAgent(widget.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 101, 101),
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<Agent>(
            future: agent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Agent agentData = snapshot.data!;
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(agentData.fullPortrait),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          agentData.displayName,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'TungstenBold',
                            color: const Color.fromRGBO(249, 52, 69, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        'Role: ${agentData.role.displayName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TungstenBold',
                          color: const Color.fromARGB(255, 190, 190, 190),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 20),
                        child: Text(
                          agentData.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 190, 190, 190),
                          ),
                        ),
                      ),
                      Text(
                        'Abilities',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TungstenBold',
                          color: const Color.fromRGBO(249, 52, 69, 1),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (Ability ability in agentData.abilities)
                        ListTile(
                          leading: ability.displayIcon != null
                              ? Image.network(
                                  ability.displayIcon,
                                  width: 40,
                                  height: 40,
                                )
                              : Container(), // Display nothing if displayIcon is null
                          title: Text(
                            '// ${ability.displayName}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 190, 190, 190),
                            ),
                          ),
                          subtitle: Text(
                            ability.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 190, 190, 190),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
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
  final String fullPortrait;
  final List<Ability> abilities;
  final String description;

  Agent({
    required this.uuid,
    required this.displayName,
    required this.role,
    required this.displayIconSmall,
    required this.fullPortrait,
    required this.abilities,
    required this.description,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      uuid: json['uuid'] ?? '',
      displayName: json['displayName'] ?? '',
      role: Role.fromJson(json['role'] ?? {}),
      displayIconSmall: json['displayIconSmall'] ?? '',
      fullPortrait: json['fullPortrait'] ?? '',
      abilities: List<Ability>.from(
          json['abilities']?.map((x) => Ability.fromJson(x)) ?? []),
      description: json['description'] ?? '',
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

class Ability {
  final String displayName;
  final String description;
  final String displayIcon;

  Ability({
    required this.displayName,
    required this.description,
    required this.displayIcon,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      displayIcon: json['displayIcon'] ?? '',
    );
  }
}

Future<Agent> fetchAgent(uuid) async {
  final response =
      await http.get(Uri.parse('https://valorant-api.com/v1/agents/$uuid'));

  if (response.statusCode == 200) {
    return Agent.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Failed to load agent details');
  }
}
