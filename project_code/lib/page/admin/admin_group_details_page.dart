import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../../service/user_services.dart';
import '../../utils/calendar_conversion.dart';

/// Admin Group Details Page with Material 3 design
/// Contains tabs for Edit, Members, and Rounds management
class AdminGroupDetailsPage extends StatefulWidget {
  final GroupModel group;

  const AdminGroupDetailsPage({
    super.key,
    required this.group,
  });

  @override
  State<AdminGroupDetailsPage> createState() => _AdminGroupDetailsPageState();
}

class _AdminGroupDetailsPageState extends State<AdminGroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GroupModel _group;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _group = widget.group;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshGroup(GroupModel updatedGroup) {
    setState(() {
      _group = updatedGroup;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final _ = theme.colorScheme; // Available for use in child widgets
    final lang = Provider.of<LocalizationController>(context).getLanguage();

    return Scaffold(
      appBar: AppBar(
        title: Text(_group.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.edit),
              text: lang.editLabel ?? 'Edit',
            ),
            Tab(
              icon: const Icon(Icons.people),
              text: lang.usersLabel ?? 'Members',
            ),
            Tab(
              icon: const Icon(Icons.list_alt),
              text: lang.roundsLabel ?? 'Rounds',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GroupEditTab(group: _group, onGroupUpdated: _refreshGroup),
          _GroupMembersTab(group: _group, onGroupUpdated: _refreshGroup),
          _GroupRoundsTab(group: _group),
        ],
      ),
    );
  }
}

/// Edit Tab - allows admin to modify group properties
class _GroupEditTab extends StatefulWidget {
  final GroupModel group;
  final Function(GroupModel) onGroupUpdated;

  const _GroupEditTab({
    required this.group,
    required this.onGroupUpdated,
  });

  @override
  State<_GroupEditTab> createState() => _GroupEditTabState();
}

class _GroupEditTabState extends State<_GroupEditTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _userCountController;
  late TextEditingController _roundCountController;
  late GroupDateType _dateType;
  
  // Hijri date fields
  late int _hijriYear;
  late int _hijriMonth;
  late int _hijriDay;
  late int _startHour;
  late int _startMinute;
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _userCountController = TextEditingController(
      text: widget.group.userCount.toString(),
    );
    _roundCountController = TextEditingController(
      text: widget.group.groupDateCount.toString(),
    );
    _dateType = widget.group.dateType;
    
    // Initialize Hijri date fields
    if (widget.group.hijriStartYear != null) {
      _hijriYear = widget.group.hijriStartYear!;
      _hijriMonth = widget.group.hijriStartMonth ?? 1;
      _hijriDay = widget.group.hijriStartDay ?? 1;
    } else if (widget.group.plannedStartDate != null) {
      // Convert existing Gregorian date to Hijri
      final hijri = CalendarConversion.gregorianToHijri(widget.group.plannedStartDate!);
      _hijriYear = hijri.year;
      _hijriMonth = hijri.month;
      _hijriDay = hijri.day;
    } else if (widget.group.startDate != null) {
      final hijri = CalendarConversion.gregorianToHijri(widget.group.startDate!);
      _hijriYear = hijri.year;
      _hijriMonth = hijri.month;
      _hijriDay = hijri.day;
    } else {
      // Default to current Hijri date
      final now = CalendarConversion.getCurrentHijriDate();
      _hijriYear = now.year;
      _hijriMonth = now.month;
      _hijriDay = now.day;
    }
    
    _startHour = widget.group.startHour ?? 0;
    _startMinute = widget.group.startMinute ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userCountController.dispose();
    _roundCountController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final groupController = Provider.of<GroupController>(context, listen: false);
      final lang = Provider.of<LocalizationController>(context, listen: false).getLanguage();
      
      final newUserCount = int.parse(_userCountController.text);
      final newRoundCount = int.parse(_roundCountController.text);
      
      // Validate user count against current members
      if (newUserCount < widget.group.usersID.length) {
        setState(() {
          _errorMessage = lang.cannotReduceUserCountBelowCurrentMembers ?? 
              'Cannot reduce user count below current members (${widget.group.usersID.length})';
          _isLoading = false;
        });
        return;
      }

      // Compute the Gregorian start date from Hijri
      final gregorianStartDate = CalendarConversion.hijriToGregorian(
        hijriYear: _hijriYear,
        hijriMonth: _hijriMonth,
        hijriDay: _hijriDay,
        hour: _startHour,
        minute: _startMinute,
      );

      // Update the group model
      // Note: We need to update the group through the controller
      await groupController.updateGroupDetails(
        groupId: widget.group.groupID,
        name: _nameController.text.trim(),
        userCount: newUserCount,
        groupDateCount: newRoundCount,
        dateType: _dateType,
        plannedStartDate: gregorianStartDate,
        hijriStartYear: _hijriYear,
        hijriStartMonth: _hijriMonth,
        hijriStartDay: _hijriDay,
        startHour: _startHour,
        startMinute: _startMinute,
      );

      // Fetch the updated group
      final updatedGroup = await groupController.getGroupByID(widget.group.groupID);
      
      if (updatedGroup != null && mounted) {
        widget.onGroupUpdated(updatedGroup);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.groupUpdatedSuccessfully ?? 'Group updated successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lang = Provider.of<LocalizationController>(context).getLanguage();

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Calendar Type Badge (Read-only)
          Card(
            elevation: 0,
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.calendarTypeLabel ?? 'Calendar Type',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.group.calendarType.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(
                      lang.immutableLabel ?? 'Immutable',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    backgroundColor: colorScheme.secondaryContainer,
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Group Name
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    lang.groupDetailsSection ?? 'Group Details',
                    Icons.info_outline,
                    colorScheme,
                    theme,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: lang.groupName ?? 'Group Name',
                      prefixIcon: const Icon(Icons.group),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return lang.groupNameIsEmpty ?? 'Group name is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Start Date/Time Section
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    lang.startDateTimeSection ?? 'Start Date & Time',
                    Icons.schedule,
                    colorScheme,
                    theme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Hijri Date Picker
                  if (widget.group.calendarType == GroupCalendarType.hijri)
                    _buildHijriDatePicker(theme, colorScheme, lang)
                  else
                    _buildGregorianDatePicker(theme, colorScheme, lang),
                  
                  const SizedBox(height: 16),
                  
                  // Time Picker
                  _buildTimePicker(theme, colorScheme, lang),
                  
                  const SizedBox(height: 12),
                  
                  // Show both calendar displays
                  _buildDualCalendarDisplay(theme, colorScheme, lang),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Configuration Section
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    lang.configurationSection ?? 'Configuration',
                    Icons.settings,
                    colorScheme,
                    theme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Duration Type
                  DropdownButtonFormField<GroupDateType>(
                    initialValue: _dateType,
                    decoration: InputDecoration(
                      labelText: lang.groupDateTypeLabel ?? 'Duration Type',
                      prefixIcon: const Icon(Icons.timer),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    items: GroupDateType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type == GroupDateType.week
                              ? (lang.groupDateTypeWeek ?? 'Week')
                              : (lang.groupDateTypeDay ?? 'Day'),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _dateType = value;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // User Count
                  TextFormField(
                    controller: _userCountController,
                    decoration: InputDecoration(
                      labelText: lang.maxMembersLabel ?? 'Max Members',
                      prefixIcon: const Icon(Icons.people),
                      filled: true,
                      fillColor: colorScheme.surface,
                      helperText: '${lang.currentMembersLabel ?? 'Current members'}: ${widget.group.usersID.length}',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.pleaseEnterValidNumber ?? 'Please enter a number';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 1) {
                        return lang.pleaseEnterValidNumber ?? 'Please enter a valid number';
                      }
                      if (n < widget.group.usersID.length) {
                        return '${lang.minimumLabel ?? 'Minimum'}: ${widget.group.usersID.length}';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Round Count
                  TextFormField(
                    controller: _roundCountController,
                    decoration: InputDecoration(
                      labelText: lang.roundCountLabel ?? 'Round Count',
                      prefixIcon: const Icon(Icons.repeat),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.pleaseEnterValidNumber ?? 'Please enter a number';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 1) {
                        return lang.pleaseEnterValidNumber ?? 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Error Message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Save Button
          FilledButton.icon(
            onPressed: _isLoading ? null : _saveChanges,
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(_isLoading ? '' : (lang.saveChanges ?? 'Save Changes')),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHijriDatePicker(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic lang,
  ) {
    final months = CalendarConversion.getHijriMonthNames();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.hijriDateLabel ?? 'Hijri Date',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Day
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                isExpanded: true,
                initialValue: _hijriDay,
                decoration: InputDecoration(
                  labelText: lang.dayLabel ?? 'Day',
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(30, (i) => i + 1).map((day) {
                  return DropdownMenuItem(value: day, child: Text('$day'));
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _hijriDay = value);
                },
              ),
            ),
            const SizedBox(width: 8),
            // Month
            Expanded(
              flex: 4,
              child: DropdownButtonFormField<int>(
                isExpanded: true,
                initialValue: _hijriMonth,
                decoration: InputDecoration(
                  labelText: lang.monthLabel ?? 'Month',
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(12, (i) => i + 1).map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(
                      months[month - 1],
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _hijriMonth = value);
                },
              ),
            ),
            const SizedBox(width: 8),
            // Year
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: _hijriYear.toString(),
                decoration: InputDecoration(
                  labelText: lang.yearLabel ?? 'Year',
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year > 0) {
                    setState(() => _hijriYear = year);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGregorianDatePicker(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic lang,
  ) {
    // Compute current Gregorian date from Hijri
    final gregorianDate = CalendarConversion.hijriToGregorian(
      hijriYear: _hijriYear,
      hijriMonth: _hijriMonth,
      hijriDay: _hijriDay,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.gregorianDateLabel ?? 'Gregorian Date',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: gregorianDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              final hijri = CalendarConversion.gregorianToHijri(picked);
              setState(() {
                _hijriYear = hijri.year;
                _hijriMonth = hijri.month;
                _hijriDay = hijri.day;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  CalendarConversion.formatGregorianDate(gregorianDate),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(Icons.edit, color: colorScheme.onSurfaceVariant, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.timeLabel ?? 'Time',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: _startHour, minute: _startMinute),
            );
            if (picked != null) {
              setState(() {
                _startHour = picked.hour;
                _startMinute = picked.minute;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  CalendarConversion.formatTime(_startHour, _startMinute),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(Icons.edit, color: colorScheme.onSurfaceVariant, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDualCalendarDisplay(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic lang,
  ) {
    final gregorianDate = CalendarConversion.hijriToGregorian(
      hijriYear: _hijriYear,
      hijriMonth: _hijriMonth,
      hijriDay: _hijriDay,
      hour: _startHour,
      minute: _startMinute,
    );
    
    final hijriFormatted = CalendarConversion.formatHijriDate(
      year: _hijriYear,
      month: _hijriMonth,
      day: _hijriDay,
    );
    
    final gregorianFormatted = CalendarConversion.formatGregorianDate(gregorianDate);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                lang.dualCalendarDisplay ?? 'Date Display',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hijri',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(hijriFormatted, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gregorian',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(gregorianFormatted, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Members Tab - shows all members with remove capability
class _GroupMembersTab extends StatefulWidget {
  final GroupModel group;
  final Function(GroupModel) onGroupUpdated;

  const _GroupMembersTab({
    required this.group,
    required this.onGroupUpdated,
  });

  @override
  State<_GroupMembersTab> createState() => _GroupMembersTabState();
}

class _GroupMembersTabState extends State<_GroupMembersTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final Map<String, UserModel?> _userCache = {};
  final _userServices = UserServices();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    for (final userId in widget.group.usersID) {
      try {
        final user = await _userServices.getUserByPhoneNumber(userId);
        if (mounted) {
          setState(() {
            _userCache[userId] = user;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _userCache[userId] = null;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRemoveUser(String userId, String displayName) async {
    final lang = Provider.of<LocalizationController>(context, listen: false).getLanguage();
    final groupController = Provider.of<GroupController>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.removeUserTitle ?? 'Remove User'),
        content: Text(
          '${lang.removeUserConfirmation ?? 'Are you sure you want to remove'} $displayName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(lang.close ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(lang.removeButton ?? 'Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await groupController.removeUserFromGroup(widget.group.groupID, userId);

      final user = await _userServices.getUserByPhoneNumber(userId);
      if (user != null) {
        user.groups.remove(widget.group.groupID);
        await _userServices.updateUser(user);
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        setState(() {
          _userCache.remove(userId);
          widget.group.usersID.remove(userId);
        });

        // Refresh the group
        final updatedGroup = await groupController.getGroupByID(widget.group.groupID);
        if (updatedGroup != null) {
          widget.onGroupUpdated(updatedGroup);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.userRemovedSuccessfully ?? 'User removed successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lang = Provider.of<LocalizationController>(context).getLanguage();

    if (widget.group.usersID.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              lang.noUsersInGroup ?? 'No users in this group yet',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    if (_isLoading && _userCache.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.group.usersID.length,
      itemBuilder: (context, index) {
        final userId = widget.group.usersID[index];
        final user = _userCache[userId];
        final displayName = user?.name ?? userId;
        final isLoading = !_userCache.containsKey(userId);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ),
            title: Text(displayName),
            subtitle: Text(
              userId,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle, color: colorScheme.error),
              onPressed: isLoading ? null : () => _handleRemoveUser(userId, displayName),
              tooltip: lang.removeUser ?? 'Remove User',
            ),
          ),
        );
      },
    );
  }
}

/// Rounds Tab - shows all rounds with drill-down capability
class _GroupRoundsTab extends StatelessWidget {
  final GroupModel group;

  const _GroupRoundsTab({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lang = Provider.of<LocalizationController>(context).getLanguage();

    if (group.hatimRounds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 80,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              lang.noRoundsYet ?? 'No rounds yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              lang.roundsWillAppearWhenGroupActive ?? 
                  'Rounds will appear when the group becomes active',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final sortedRounds = group.getHatimGroups();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedRounds.length,
      itemBuilder: (context, index) {
        final round = sortedRounds[index];
        final completedCount = round.completedUserIDs.length;
        final totalUsers = group.usersID.length;
        final progress = totalUsers > 0 ? completedCount / totalUsers : 0.0;
        final isCompleted = completedCount == totalUsers && totalUsers > 0;
        
        // Get start and end dates for this round
        final startDate = round.getStartDate(group.plannedStartDate ?? group.startDate ?? DateTime.now(), group.dateType);
        final endDate = round.getEndDate(group.plannedStartDate ?? group.startDate ?? DateTime.now(), group.dateType);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminRoundDetailsPage(
                    group: group,
                    round: round,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: colorScheme.onPrimaryContainer)
                              : Text(
                                  '${round.roundID}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${lang.roundLabel ?? 'Round'} ${round.roundID}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedCount / $totalUsers ${lang.completedLabel ?? 'completed'}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        isCompleted ? colorScheme.primary : colorScheme.tertiary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Start and End dates
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.startDateLabel ?? 'Start Date',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                CalendarConversion.formatGregorianDate(startDate),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.endDateLabel ?? 'End Date',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                CalendarConversion.formatGregorianDate(endDate),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Admin Round Details Page - shows detailed round information
class AdminRoundDetailsPage extends StatefulWidget {
  final GroupModel group;
  final HatimRoundModel round;

  const AdminRoundDetailsPage({
    super.key,
    required this.group,
    required this.round,
  });

  @override
  State<AdminRoundDetailsPage> createState() => _AdminRoundDetailsPageState();
}

class _AdminRoundDetailsPageState extends State<AdminRoundDetailsPage> {
  final Map<String, UserModel?> _userCache = {};
  final _userServices = UserServices();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    for (final userId in widget.group.usersID) {
      try {
        final user = await _userServices.getUserByPhoneNumber(userId);
        if (mounted) {
          setState(() {
            _userCache[userId] = user;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _userCache[userId] = null;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lang = Provider.of<LocalizationController>(context).getLanguage();

    final completedUsers = widget.group.usersID
        .where((id) => widget.round.completedUserIDs.contains(id))
        .toList();
    final notCompletedUsers = widget.group.usersID
        .where((id) => !widget.round.completedUserIDs.contains(id))
        .toList();
    final sortedUsers = [...completedUsers, ...notCompletedUsers];
    
    // Get start and end dates for this round
    final startDate = widget.round.getStartDate(
      widget.group.plannedStartDate ?? widget.group.startDate ?? DateTime.now(),
      widget.group.dateType,
    );
    final endDate = widget.round.getEndDate(
      widget.group.plannedStartDate ?? widget.group.startDate ?? DateTime.now(),
      widget.group.dateType,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${lang.roundLabel ?? 'Round'} ${widget.round.roundID}'),
      ),
      body: _isLoading && _userCache.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Start and End Dates Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            lang.roundDurationLabel ?? 'Round Duration',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.startDateLabel ?? 'Start Date',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  CalendarConversion.formatGregorianDate(startDate),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.endDateLabel ?? 'End Date',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  CalendarConversion.formatGregorianDate(endDate),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Summary Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            theme,
                            colorScheme,
                            Icons.check_circle,
                            completedUsers.length.toString(),
                            lang.completedLabel ?? 'Completed',
                            colorScheme.primary,
                          ),
                          _buildStatItem(
                            theme,
                            colorScheme,
                            Icons.pending,
                            notCompletedUsers.length.toString(),
                            lang.pendingLabel ?? 'Pending',
                            colorScheme.tertiary,
                          ),
                          _buildStatItem(
                            theme,
                            colorScheme,
                            Icons.people,
                            widget.group.usersID.length.toString(),
                            lang.totalLabel ?? 'Total',
                            colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Users List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedUsers.length,
                    itemBuilder: (context, index) {
                      final userId = sortedUsers[index];
                      final user = _userCache[userId];
                      final userName = user?.name ?? lang.unknown ?? 'Unknown';
                      final isCompleted = widget.round.completedUserIDs.contains(userId);
                      final juz = widget.round.getJuzForUser(
                        userId,
                        widget.group.usersID,
                        widget.group.hatimStyle,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isCompleted
                            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                            : colorScheme.errorContainer.withValues(alpha: 0.3),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.surface,
                            child: isCompleted
                                ? Icon(Icons.check, color: Colors.green)
                                : Icon(Icons.close, color: Colors.red),
                          ),
                          title: Text(userName),
                          subtitle: Text(
                            '${lang.juzLabel ?? 'Juz'}: $juz',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: Chip(
                            label: Text(
                              isCompleted
                                  ? (lang.completedLabel ?? 'Completed')
                                  : (lang.pendingLabel ?? 'Pending'),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isCompleted
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onErrorContainer,
                              ),
                            ),
                            backgroundColor: isCompleted
                                ? colorScheme.primaryContainer
                                : colorScheme.errorContainer,
                            side: BorderSide.none,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
