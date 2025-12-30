import 'package:flutter/material.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/hatim_model.dart';
import 'package:hatim_program/models/zikir_model.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CommunityViewPage extends StatefulWidget {
  final CommunityModel community;

  const CommunityViewPage({super.key, required this.community});

  @override
  State<CommunityViewPage> createState() => _CommunityViewPageState();
}

class _CommunityViewPageState extends State<CommunityViewPage> {
  final CommunityServices _communityServices = CommunityServices();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetCountController = TextEditingController();
  final _hatimIdController = TextEditingController();
  late SharedPreferences _prefs;
  Map<String, int> _zikirCounts = {};
  // TODO: Replace with actual user ID from auth service
  final String _currentUserId = 'user_placeholder';

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
                  final newHatim = HatimModel(
                    id: _hatimIdController.text,
                  );
                  _communityServices
                      .addHatimToCommunity(widget.community.id, newHatim)
                      .then((_) {
                    setState(() {
                      widget.community.hatimPrograms.add(newHatim);
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
    final member = widget.community.members
        .firstWhere((m) => m.userId == _currentUserId);
    final canCreateHatim = member.permissions?.canCreateHatim ?? false;
    final canCreateZikir = member.permissions?.canCreateZikir ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Description'),
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
                title: Text('Hatim Program ${hatim.id}'), // Placeholder
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
                final isCompleted =
                    targetCount != null && currentCount >= targetCount;

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
      floatingActionButton: (canCreateHatim || canCreateZikir)
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        if (canCreateZikir)
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('Create Zikir'),
                            onTap: () {
                              Navigator.pop(context);
                              _showCreateZikirDialog();
                            },
                          ),
                        if (canCreateHatim)
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
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
