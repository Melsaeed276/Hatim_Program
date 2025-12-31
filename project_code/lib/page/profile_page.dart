import 'package:flutter/material.dart';
import 'package:hatim_program/controller/contollers.dart';
import 'package:hatim_program/models/group_model.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: true);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: userController.getUserByPhoneNumber(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found.'));
          } else {
            final user = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  title: const Text('Phone Number'),
                  subtitle: Text(user.phoneNumber),
                ),
                const Divider(),
                const ListTile(
                  title: Text('My Groups'),
                ),
                if (user.groups.isEmpty)
                  const ListTile(
                    title: Text('You have not joined any groups yet.'),
                  )
                else
                  FutureBuilder<List<GroupModel>>(
                    future: userController.getAllGroupsOfUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No groups found.'));
                      } else {
                        final groups = snapshot.data!;
                        return Column(
                          children: groups
                              .map(
                                (group) => ListTile(
                                  title: Text('Group ${group.groupID}'),
                                  subtitle: Text('Status: ${group.status.name} - ${group.usersID.length}/${group.userCount} members'),
                                  trailing: Text('Round ${group.round}'),
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
