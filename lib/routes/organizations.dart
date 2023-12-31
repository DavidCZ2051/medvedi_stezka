// packages
import 'package:flutter/material.dart';
import 'package:medvedi_stezka/functions.dart';
import 'package:medvedi_stezka/globals.dart';

class Organizations extends StatefulWidget {
  const Organizations({super.key});

  @override
  State<Organizations> createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  final _newOrganizationFormKey = GlobalKey<FormState>();

  String newOrganization = "";

  void createOrganizationDialog() {
    newOrganization = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Přidat jednotu"),
        content: Form(
          key: _newOrganizationFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Název jednoty",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Zadejte název jednoty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      newOrganization = value!;
                    });
                  },
                ),
              ],
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
              if (_newOrganizationFormKey.currentState!.validate()) {
                _newOrganizationFormKey.currentState!.save();

                selectedCompetition!.organizations.add(newOrganization);

                selectedCompetition!.organizations.sort(
                  (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "createOrganization",
        tooltip: "Přidat jednotu",
        onPressed: createOrganizationDialog,
        child: const Icon(Icons.add),
      ),
      body: selectedCompetition!.organizations.isEmpty
          ? const Center(
              child: Text(
                "Zatím žádné jednoty...",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Počet jednot: ${selectedCompetition!.organizations.length}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  for (String organization
                      in selectedCompetition!.organizations)
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
                          title: Text(organization),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
