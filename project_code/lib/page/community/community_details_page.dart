import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityDetailsPage extends StatefulWidget {
  final CommunityModel community;

  const CommunityDetailsPage({super.key, required this.community});

  @override
  State<CommunityDetailsPage> createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  late SharedPreferences _prefs;
  Map<String, int> _zikirCounts = {};

  @override
  void initState() {
    super.initState();
    _loadZikirCounts();
  }

  Future<void> _loadZikirCounts() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _zikirCounts = {
        for (var zikir in widget.community.zikirs)
          zikir.id: _prefs.getInt(zikir.id) ?? 0,
      };
    });
  }

  Future<void> _incrementZikirCount(String zikirId) async {
    setState(() {
      _zikirCounts[zikirId] = (_zikirCounts[zikirId] ?? 0) + 1;
    });
    await _prefs.setInt(zikirId, _zikirCounts[zikirId]!);
  }

  Future<void> _resetZikirCount(String zikirId) async {
    setState(() {
      _zikirCounts[zikirId] = 0;
    });
    await _prefs.setInt(zikirId, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Description'),
            subtitle: Text(widget.community.description),
          ),
          const Divider(),
          const ListTile(
            title: Text('Hatim Programs'),
          ),
          if (widget.community.hatimPrograms.isEmpty)
            const ListTile(
              title: Text('No Hatim programs in this community yet.'),
            )
          else
            ...widget.community.hatimPrograms.map(
              (hatim) => ListTile(
                title: Text(hatim.id), // Assuming HatimModel has a 'name' property
                // TODO: Add navigation to Hatim details page
              ),
            ),
          const Divider(),
          const ListTile(
            title: Text('Zikirs'),
          ),
          if (widget.community.zikirs.isEmpty)
            const ListTile(
              title: Text('No Zikirs in this community yet.'),
            )
          else
            ...widget.community.zikirs.map(
              (zikir) {
                final currentCount = _zikirCounts[zikir.id] ?? 0;
                final targetCount = zikir.targetCount;
                final isCompleted = targetCount != null && currentCount >= targetCount;

                return ListTile(
                  title: Text(zikir.title),
                  subtitle: Text(zikir.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Count: $currentCount'),
                      if (isCompleted)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _resetZikirCount(zikir.id),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _incrementZikirCount(zikir.id),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
