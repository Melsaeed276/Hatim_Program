import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/page/community/community_view_page.dart';
import 'package:hatim_program/service/community_services.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  final CommunityServices _communityServices = CommunityServices();
  // TODO: Replace with actual user ID from auth service
  final String _currentUserId = 'user_placeholder';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search communities...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CommunityModel>>(
              future: _communityServices.getCommunitiesForUser(_currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('You have not joined any communities yet.'));
                } else {
                  final myCommunities = snapshot.data!
                      .where((community) => community.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'My Communities',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: myCommunities.length,
                          itemBuilder: (context, index) {
                            final community = myCommunities[index];
                            return ListTile(
                              title: Text(community.name),
                              subtitle: Text(community.description),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommunityViewPage(
                                            community: community),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<CommunityModel>>(
              future: _communityServices.getAllCommunities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No communities found.'));
                } else {
                  // Filter out communities the user has already joined
                  final allCommunities = snapshot.data!
                      .where((community) => !community.members
                          .any((member) => member.userId == _currentUserId) && !community.pendingMembers.contains(_currentUserId))
                      .where((community) => community.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Discover Communities',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allCommunities.length,
                          itemBuilder: (context, index) {
                            final community = allCommunities[index];
                            return ListTile(
                              title: Text(community.name),
                              subtitle: Text(community.description),
                              trailing: ElevatedButton(
                                child: const Text('Request to Join'),
                                onPressed: () {
                                  _communityServices
                                      .requestToJoinCommunity(
                                          community.id, _currentUserId)
                                      .then((_) => setState(() {}));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
