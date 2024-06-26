// packages
import 'package:flutter/material.dart';
import 'package:medvedi_stezka/functions.dart';
import 'package:medvedi_stezka/globals.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final _newTeamFormKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> newTeam = {};

  List<Team> search() {
    if (searchController.text.isEmpty || searchController.text == "") {
      return selectedCompetition!.teams;
    }

    return selectedCompetition!.teams.where((team) {
      return team.category
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.organization
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.members[0].firstName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.members[0].lastName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.members[1].firstName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.members[1].lastName
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          team.number.toString().contains(searchController.text);
    }).toList();
  }

  void createTeamDialog() {
    newTeam = {};
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Přidat hlídku"),
        content: Form(
          key: _newTeamFormKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Kategorie",
                    ),
                    value: newTeam["category"],
                    items: <DropdownMenuItem>[
                      for (TeamCategory category in TeamCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                color: category.getColor(),
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 8),
                              Text("$category"),
                            ],
                          ),
                        ),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return "Vyberte kategorii hlídky";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newTeam["category"] = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        newTeam["category"] = value;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Jednota",
                    ),
                    value: newTeam["organization"],
                    items: <DropdownMenuItem>[
                      for (String organization
                          in selectedCompetition!.organizations)
                        DropdownMenuItem(
                          value: organization,
                          child: Text(organization),
                        ),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return "Vyberte organizaci hlídky";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newTeam["organization"] = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        newTeam["organization"] = value;
                      });
                    },
                  ),
                  for (int i = 0; i < 2; i++)
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Příjmení",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Zadejte příjmení";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                newTeam["lastName$i"] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Jméno",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Zadejte jméno";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                newTeam["firstName$i"] = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Rok narození",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Zadejte rok narození";
                              } else if (int.tryParse(value) == null) {
                                return "Zadejte platné číslo";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                newTeam["birthYear$i"] = int.parse(value!);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Zrušit"),
          ),
          OutlinedButton(
            onPressed: () {
              if (_newTeamFormKey.currentState!.validate()) {
                _newTeamFormKey.currentState!.save();

                selectedCompetition!.teams.add(
                  Team(
                    // every team has a number of 0 when created
                    // it is changed when adding their CompetitionCard
                    number: 0,
                    category: newTeam["category"],
                    organization: newTeam["organization"],
                    members: <TeamMember>[
                      TeamMember(
                        firstName: newTeam["firstName0"],
                        lastName: newTeam["lastName0"],
                        birthYear: newTeam["birthYear0"],
                      ),
                      TeamMember(
                        firstName: newTeam["firstName1"],
                        lastName: newTeam["lastName1"],
                        birthYear: newTeam["birthYear1"],
                      ),
                    ],
                  ),
                );

                saveData();

                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text("Přidat"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "createTeam",
        tooltip: "Přidat hlídku",
        onPressed: createTeamDialog,
        child: const Icon(Icons.add),
      ),
      body: selectedCompetition!.teams.isEmpty
          ? const Center(
              child: Text(
                "Zatím žádné hlídky...",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Počet hlídek: ${search().length}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: "Hledat",
                              prefixIcon: const Icon(Icons.search),
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (Team team in search())
                    Card(
                      child: InkWell(
                        onSecondaryTapDown: (TapDownDetails tap) {
                          // TODO
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              tap.globalPosition.dx,
                              tap.globalPosition.dy,
                              tap.globalPosition.dx,
                              tap.globalPosition.dy,
                            ),
                            items: <PopupMenuItem>[
                              PopupMenuItem(
                                onTap: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {});
                                },
                                child: const Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                    ),
                                    SizedBox(width: 8),
                                    Text("Upravit"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: const Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                    ),
                                    SizedBox(width: 8),
                                    Text("Smazat"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        child: ListTile(
                          leading: Text(
                            "${team.number == 0 ? "?" : team.number}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          title: Text("${team.category}"),
                          subtitle: Text(
                            "${team.organization}: ${team.members[0].firstName} ${team.members[0].lastName}, ${team.members[1].firstName} ${team.members[1].lastName}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
