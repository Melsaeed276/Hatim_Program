import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/user_model.dart';

class PermissionsDialog extends StatefulWidget {
  final CommunityMemberModel member;
  final UserModel user;
  final Function(CommunityMemberModel) onSave;

  const PermissionsDialog({
    super.key,
    required this.member,
    required this.user,
    required this.onSave,
  });

  @override
  State<PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog> {
  late CommunityMemberModel _editedMember;

  @override
  void initState() {
    super.initState();
    _editedMember = CommunityMemberModel.fromJson(widget.member.toJson());
    _editedMember.permissions ??= CommunityAdminPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Permissions for ${widget.user.name}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            CheckboxListTile(
              title: const Text('Can Create Hatim'),
              value: _editedMember.permissions!.canCreateHatim,
              onChanged: (value) {
                setState(() {
                  _editedMember.permissions!.canCreateHatim = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Can Create Zikir'),
              value: _editedMember.permissions!.canCreateZikir,
              onChanged: (value) {
                setState(() {
                  _editedMember.permissions!.canCreateZikir = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Can Send Notifications'),
              value: _editedMember.permissions!.canSendNotifications,
              onChanged: (value) {
                setState(() {
                  _editedMember.permissions!.canSendNotifications = value!;
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
            widget.onSave(_editedMember);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
