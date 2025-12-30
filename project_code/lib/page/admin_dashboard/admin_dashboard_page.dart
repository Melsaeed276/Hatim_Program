import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:uuid/uuid.dart';

import 'community_management_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final CommunityServices _communityServices = CommunityServices();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _showCreateCommunityDialog() async {
    // TODO: Replace with actual superadmin ID from auth service
    const String superAdminId = 'superadmin_placeholder';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Community'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
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
                  final newCommunity = CommunityModel(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    description: _descriptionController.text,
                    createdBy: superAdminId,
                  );
                  _communityServices.createCommunity(newCommunity).then((_) {
                    setState(() {});
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
        title: const Text('SuperAdmin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateCommunityDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<CommunityModel>>(
        future: _communityServices.getAllCommunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No communities found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final community = snapshot.data![index];
                return ListTile(
                  title: Text(community.name),
                  subtitle: Text(community.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommunityManagementPage(community: community),
                      ),
                    ).then((_) => setState(() {}));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
