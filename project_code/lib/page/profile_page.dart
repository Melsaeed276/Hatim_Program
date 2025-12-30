import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:hatim_program/service/user_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserServices _userServices = UserServices();
  final CommunityServices _communityServices = CommunityServices();
  // TODO: Replace with actual user ID from auth service
  final String _currentUserId = 'user_placeholder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userServices.getUserByPhoneNumber(_currentUserId),
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
                  title: Text('My Communities'),
                ),
                if (user.communityIds.isEmpty)
                  const ListTile(
                    title: Text('You have not joined any communities yet.'),
                  )
                else
                  FutureBuilder<List<CommunityModel>>(
                    future: _communityServices.getCommunitiesForUser(user.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No communities found.'));
                      } else {
                        final communities = snapshot.data!;
                        return Column(
                          children: communities
                              .map(
                                (community) => ListTile(
                                  title: Text(community.name),
                                  subtitle: Text(community.description),
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
