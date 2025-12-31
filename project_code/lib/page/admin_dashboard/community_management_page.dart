import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/group_model.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/models/zikir_model.dart';
import 'package:hatim_program/page/admin_dashboard/permissions_dialog.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:hatim_program/service/user_services.dart';
import 'package:uuid/uuid.dart';


class CommunityManagementPage extends StatefulWidget {
  final CommunityModel community;

  const CommunityManagementPage({super.key, required this.community});

  @override
  State<CommunityManagementPage> createState() =>
      _CommunityManagementPageState();
}

class _CommunityManagementPageState extends State<CommunityManagementPage> {
  final CommunityServices _communityServices = CommunityServices();
  final UserServices _userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController();
  final _hatimIdController = TextEditingController();

  late CommunityModel _community;

  @override
  void initState() {
    super.initState();
    _community = widget.community;
  }

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
                      .addZikirToCommunity(_community.id, newZikir)
                      .then((_) {
                    setState(() {
                      _community.zikirs.add(newZikir);
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

  Future<void> _showCreateHatimDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Hatim'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _hatimIdController,
                    decoration: const InputDecoration(
                      labelText: 'Hatim ID',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Hatim ID';
                      }
                      return null;
                    },
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
                  final newHatim = GroupModel(
                    groupID: _hatimIdController.text,
                  );
                  _communityServices
                      .addHatimToCommunity(_community.id, newHatim)
                      .then((_) {
                    setState(() {
                      _community.hatimPrograms.add(newHatim);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_community.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Create Zikir'),
                        onTap: () {
                          Navigator.pop(context);
                          _showCreateZikirDialog();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Create Hatim'),
                        onTap: () {
                          Navigator.pop(context);
                          _showCreateHatimDialog();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _userServices.getUsersByIds(
          _community.members.map((m) => m.userId).toList()
            ..addAll(_community.pendingMembers),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            final members = _community.members;
            final pendingMembers = _community.pendingMembers;

            return ListView(
              children: [
                ListTile(
                  title: const Text('Description'),
                  subtitle: Text(_community.description),
                ),
                const Divider(),
                if (pendingMembers.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Pending Members'),
                  ),
                  ...pendingMembers.map(
                    (userId) {
                      final user = users.firstWhere((u) => u.id == userId,
                          orElse: () => UserModel(
                              name: 'Unknown', phoneNumber: 'Unknown'));
                      return ListTile(
                        title: Text(user.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _communityServices
                                    .approveJoinRequest(
                                        _community.id, userId)
                                    .then((_) {
                                  setState(() {
                                    _community.pendingMembers
                                        .remove(userId);
                                    _community.members.add(
                                        CommunityMemberModel(
                                            userId: userId,
                                            communityId:
                                                _community.id));
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _communityServices
                                    .rejectJoinRequest(
                                        _community.id, userId)
                                    .then((_) {
                                  setState(() {
                                    _community.pendingMembers
                                        .remove(userId);
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
                const ListTile(
                  title: Text('Members'),
                ),
                ...members.map(
                  (member) {
                    final user = users.firstWhere((u) => u.id == member.userId,
                        orElse: () => UserModel(
                            name: 'Unknown', phoneNumber: 'Unknown'));
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(member.role.toString().split('.').last),
                      onTap: () {
                        if (member.role == CommunityRole.admin) {
                          showDialog(
                            context: context,
                            builder: (context) => PermissionsDialog(
                              member: member,
                              user: user,
                              onSave: (updatedMember) {
                                _communityServices.updateMember(
                                    _community.id, updatedMember);
                              },
                            ),
                          );
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
                              _community.id, member);
                        },
                      ),
                    );
                  },
                ),
                const Divider(),
                const ListTile(
                  title: Text('Zikirs'),
                ),
                ..._community.zikirs.map(
                  (zikir) => ListTile(
                    title: Text(zikir.title),
                    subtitle: Text(zikir.description),
                  ),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Hatim Programs'),
                ),
                ..._community.hatimPrograms.map(
                  (hatim) => ListTile(
                    title: Text(hatim.groupID),
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
