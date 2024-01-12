import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/controllers/db-service.dart';
import 'package:test/models/user.dart';

class ProfileFill extends StatefulWidget {
  const ProfileFill({super.key, required String title});

  @override
  State<ProfileFill> createState() => _ProfileFillState();
}

class _ProfileFillState extends State<ProfileFill> {
  final dbService _service = dbService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hearingLossLeftController =
      TextEditingController();
  final TextEditingController _hearingLossRightController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayUserForm,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'Users',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messagesListView(),
        ],
      ),
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _service.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading users"),
            );
          }

          List users = snapshot.data?.docs ?? [];
          if (users.isEmpty) {
            return const Center(
              child: Text("add user"),
            );
          }
          // print(users);
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              dbUser user = users[index].data();
              String uid = users[index].id;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(user.name),
                  subtitle: Text(
                    DateFormat('dd-MM-yyyy h:mm a').format(
                      user.updatedOn.toDate(),
                    ),
                  ),
                  trailing: Checkbox(
                      value: user.darkMode,
                      onChanged: (value) {
                        dbUser updatedUser = user.copyWith(
                            darkMode: !user.darkMode,
                            updatedOn: Timestamp.now());
                        _service.updateUser(uid, updatedUser);
                      }),
                  onLongPress: () {
                    _service.deleteUser(uid);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayUserForm() async {
    String name = "";
    int hearingLossLevelLeft = 0;
    int hearingLossLevelRight = 0;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a User'),
            content: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  controller: _hearingLossLeftController,
                  decoration: const InputDecoration(
                      labelText: "Hearing Loss Level Left"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Parse the input as an integer; you may want to add additional validation.
                    hearingLossLevelLeft = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  controller: _hearingLossRightController,
                  decoration: const InputDecoration(
                      labelText: "Hearing Loss Level Left"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Parse the input as an integer; you may want to add additional validation.
                    hearingLossLevelRight = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text('ok'),
                onPressed: () {
                  dbUser user = dbUser(
                    name: name,
                    email: 'null',
                    hearingLossLevelLeft: hearingLossLevelLeft,
                    hearingLossLevelRight: hearingLossLevelRight,
                    eventsHappened: 0,
                    mileage: 0,
                    tripTime: 0,
                    darkMode: false,
                    createdOn: Timestamp.now(),
                    updatedOn: Timestamp.now(),
                  );
                  _service.addUser(user);
                  Navigator.pop(context);
                  _nameController.clear();
                  _hearingLossLeftController.clear();
                  _hearingLossRightController.clear();
                },
              ),
            ],
          );
        });
  }
}
