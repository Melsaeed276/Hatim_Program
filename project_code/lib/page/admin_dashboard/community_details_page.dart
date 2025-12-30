import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/models/zikir_model.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:hatim_program/service/user_services.dart';
import 'package:uuid/uuid.dart';

class CommunityDetailsPage extends StatefulWidget {
  final CommunityModel community;

  const CommunityDetailsPage({super.key, required this.community});

  @override
  State<CommunityDetailsPage> createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  final CommunityServices _communityServices = CommunityServices();
  final UserServices _userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController();

  Future<void> _showCreateZikirDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Zikir'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _targetCountController,
                    decoration: const InputDecoration(
                      labelText: 'Target Count (optional)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newZikir = ZikirModel(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    targetCount: _targetCountController.text.isNotEmpty
                        ? int.parse(_targetCountController.text)
                        : null,
                  );
                  _communityServices
                      .addZikirToCommunity(widget.community.id, newZikir)
                      .then((_) {
                    setState(() {
                      widget.community.zikirs.add(newZikir);
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermissionsDialog(
      CommunityMemberModel member, UserModel user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissions for ${user.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CheckboxListTile(
                  title: const Text('Can Create Hatim'),
                  value: member.permissions?.canCreateHatim ?? false,
                  onChanged: (value) {
                    setState(() {
                      member.permissions?.canCreateHatim = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Can Create Zikir'),
                  value: member.permissions?.canCreateZikir ?? false,
                  onChanged: (value) {
                    setState(() {
                      member.permissions?.canCreateZikir = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Can Send Notifications'),
                  value: member.permissions?.canSendNotifications ?? false,
                  onChanged: (value) {
                    setState(() {
                      member.permissions?.canSendNotifications = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _communityServices
                    .updateMember(widget.community.id, member)
                    .then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateZikirDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _userServices.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final allUsers = snapshot.data!;
            final members = widget.community.members;

            return ListView(
              children: [
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(widget.community.description),
                ),
                const Divider(),
                ListTile(
                  title: Text('Members'),
                ),
                ...members.map(
                  (member) {
                    final user = allUsers.firstWhere(
                        (u) => u.id == member.userId,
                        orElse: () => UserModel(
                            name: 'Unknown', phoneNumber: 'Unknown'));
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(member.role.toString().split('.').last),
                      onTap: () {
                        if (member.role == CommunityRole.admin) {
                          _showPermissionsDialog(member, user);
                        }
                      },
                      trailing: Switch(
                        value: member.role == CommunityRole.admin,
                        onChanged: (value) {
                          setState(() {
                            member.role = value
                                ? CommunityRole.admin
                                : CommunityRole.member;
                            if (member.role == CommunityRole.admin) {
                              member.permissions =
                                  CommunityAdminPermissions();
                            } else {
                              member.permissions = null;
                            }
                          });
                          _communityServices.updateMember(
                              widget.community.id, member);
                        },
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text('Zikirs'),
                ),
                ...widget.community.zikirs.map(
                  (zikir) => ListTile(
                    title: Text(zikir.title),
                    subtitle: Text(zikir.description),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
