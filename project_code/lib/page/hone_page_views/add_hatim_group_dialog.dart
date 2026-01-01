import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatim_program/controller/contollers.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../localization/localization.dart';
import '../../utils/calendar_conversion.dart';

/// Shows the Add Group UI as a full-screen Material 3 bottom sheet
Future<T?> showAddHatimGroupSheet<T>(BuildContext context, {String? adminId}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddHatimGroupSheet(adminId: adminId),
  );
}

class AddHatimGroupDialog extends StatefulWidget {
  final String? adminId;

  const AddHatimGroupDialog({super.key, this.adminId});

  @override
  State<AddHatimGroupDialog> createState() => _AddHatimGroupDialogState();
}

/// New Material 3 full-screen bottom sheet implementation
class AddHatimGroupSheet extends StatefulWidget {
  final String? adminId;

  const AddHatimGroupSheet({super.key, this.adminId});

  @override
  State<AddHatimGroupSheet> createState() => _AddHatimGroupSheetState();
}

class _AddHatimGroupDialogState extends State<AddHatimGroupDialog> {
  // GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  //TextEditingController
  final TextEditingController groupIDController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  // date type controller
  late GroupDateType groupDateType = GroupDateType.week;
  // hatim style
  late HatimStyle hatimStyle = HatimStyle.allTogetherInOneHatim;
  bool isExistMessage = false;
  bool isLoading = false;
  String? errorMessage;

  // Helper function to get localized hatim style name
  String _getHatimStyleName(HatimStyle style, Localization lang) {
    switch (style) {
      case HatimStyle.allTogetherInOneHatim:
        return lang.hatimStyleAllTogetherInOneHatim ??
            'All Together in One Hatim';
      case HatimStyle.byRounds:
        return lang.hatimStyleByRounds ?? 'By Rounds';
      case HatimStyle.byChallenge:
        return lang.hatimStyleByChallenge ?? 'By Challenge';
    }
  }

  // Helper function to get localized hatim style description
  String _getHatimStyleDescription(HatimStyle style, Localization lang) {
    switch (style) {
      case HatimStyle.allTogetherInOneHatim:
        return lang.hatimStyleAllTogetherInOneHatimDescription ??
            'All group members read the same hatim together. The group must have exactly 30 members.';
      case HatimStyle.byRounds:
        return lang.hatimStyleByRoundsDescription ??
            'Group members read hatim in rounds. Each round has a different distribution.';
      case HatimStyle.byChallenge:
        return lang.hatimStyleByChallengeDescription ??
            'Group members read hatim in a challenge format. Provides a more flexible distribution.';
    }
  }

  // Helper function to get localized group date type name
  String _getGroupDateTypeName(GroupDateType dateType, Localization lang) {
    switch (dateType) {
      case GroupDateType.week:
        return lang.groupDateTypeWeek ?? 'Week';
      case GroupDateType.day:
        return lang.groupDateTypeDay ?? 'Day';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context, listen: true);
    //theme
    final theme = Theme.of(context);
    //colorScheme
    final themeColor = Theme.of(context).colorScheme;

    // language controller
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();

    // user controller to get current user ID
    final userController = Provider.of<UserController>(context, listen: false);

    /// in this dialog it  will add a new group to the hatim
    ///
    void dismissDialog() {
      // dismiss the dialog
      Navigator.pop(context);
    }

    Widget buildSectionHeader(String title, IconData icon) {
      return Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: themeColor.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    children: [
                      Icon(
                        Icons.group_add_rounded,
                        size: 28,
                        color: themeColor.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        lang.addGroup!,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: themeColor.onSurface,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Basic Information Section
                  buildSectionHeader(
                    lang.groupDetailsSection ?? 'Group Details',
                    Icons.info_outline,
                  ),
                  const SizedBox(height: 16),

                  // Group Name Field
                  TextFormField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: themeColor.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      labelText: lang.groupName ?? 'Group Name',
                      hintText:
                          lang.groupNameHelperText ??
                          'Enter a name for your group',
                      prefixIcon: Icon(
                        Icons.group,
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperText:
                          lang.groupNameHelperText ??
                          'This name will be shown to users',
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperMaxLines: 2,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.groupNameIsEmpty ??
                            'Group name is required';
                      }
                      final trimmed = value.trim();
                      if (trimmed.isEmpty) {
                        return lang.groupNameIsEmpty ??
                            'Group name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Group ID Section
                  buildSectionHeader(
                    lang.groupIdentificationSection ?? 'Group Identification',
                    Icons.tag,
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: themeColor.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeColor.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.groupIDHelperText ??
                              'Unique 6-digit identifier for your group',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: themeColor.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: groupIDController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: themeColor.surface,
                                  labelText: '6-digit ID',
                                  hintText: '123456',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return lang.groupIDMustBe6Digits ??
                                        'Group ID is required';
                                  }
                                  final trimmed = value.trim();
                                  if (trimmed.isEmpty) {
                                    return lang.groupIDMustBe6Digits ??
                                        'Group ID is required';
                                  }
                                  // Check if it's exactly 6 digits
                                  if (trimmed.length != 6) {
                                    return lang.groupIDMustBe6Digits ??
                                        'Must be exactly 6 digits';
                                  }
                                  // Ensure it's digits only (formatter should handle this, but double-check)
                                  if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
                                    return lang.groupIDMustContainOnlyNumbers ??
                                        'Must contain only numbers';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: themeColor.secondaryContainer,
                                foregroundColor:
                                    themeColor.onSecondaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setState(() {
                                        isLoading = true;
                                        errorMessage = null;
                                        isExistMessage = false;
                                      });

                                      try {
                                        final randomID = await groupController
                                            .generateUniqueRandomGroupID();
                                        groupIDController.text = randomID;
                                        setState(() {
                                          isLoading = false;
                                          isExistMessage = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          errorMessage =
                                              '${lang.failedToGenerateRandomID ?? 'Failed to generate ID'}: ${e.toString()}';
                                          isLoading = false;
                                        });
                                      }
                                    },
                              icon: isLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: themeColor.onSecondaryContainer,
                                      ),
                                    )
                                  : const Icon(Icons.shuffle, size: 16),
                              label: Text(isLoading ? '' : 'Generate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Hatim Configuration Section
                  buildSectionHeader(
                    lang.hatimConfigurationSection ?? 'Hatim Configuration',
                    Icons.settings,
                  ),
                  const SizedBox(height: 16),

                  // Hatim Style Dropdown (First)
                  DropdownButtonFormField<HatimStyle>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: themeColor.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      labelText: lang.hatimStyleLabel ?? 'Reading Style',
                      prefixIcon: Icon(
                        Icons.book,
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperText: _getHatimStyleDescription(hatimStyle, lang),
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperMaxLines: 3,
                    ),
                    initialValue: hatimStyle,
                    onChanged: (HatimStyle? newValue) {
                      setState(() {
                        hatimStyle = newValue!;
                        // If switching to allTogetherInOneHatim, set count to 30
                        if (hatimStyle == HatimStyle.allTogetherInOneHatim) {
                          countController.text = '30';
                        }
                      });
                      // Revalidate the form to show/hide error messages
                      _formKey.currentState?.validate();
                    },
                    items: HatimStyle.values
                        .map<DropdownMenuItem<HatimStyle>>(
                          (HatimStyle value) => DropdownMenuItem<HatimStyle>(
                            value: value,
                            child: Text(
                              _getHatimStyleName(value, lang),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Date Type Dropdown (Second)
                  DropdownButtonFormField<GroupDateType>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: themeColor.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      labelText: lang.groupDateTypeLabel ?? 'Duration Type',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperText:
                          lang.durationTypeHelperText ??
                          'Choose how long members have to complete their portions',
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: themeColor.onSurfaceVariant,
                      ),
                    ),
                    initialValue: groupDateType,
                    onChanged: (GroupDateType? newValue) {
                      setState(() {
                        groupDateType = newValue!;
                      });
                    },
                    items: GroupDateType.values
                        .map<DropdownMenuItem<GroupDateType>>(
                          (GroupDateType value) =>
                              DropdownMenuItem<GroupDateType>(
                                value: value,
                                child: Text(
                                  _getGroupDateTypeName(value, lang),
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Group Count Field (Third)
                  TextFormField(
                    controller: countController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: themeColor.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      labelText: lang.groupCountDefault!,
                      hintText: hatimStyle == HatimStyle.allTogetherInOneHatim
                          ? '30'
                          : '1-100',
                      prefixIcon: Icon(
                        Icons.people,
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperText: hatimStyle == HatimStyle.allTogetherInOneHatim
                          ? lang.allTogetherInOneHatimMustBe30Description
                          : lang.otherStylesCanBeFlexible,
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: themeColor.onSurfaceVariant,
                      ),
                      helperMaxLines: 2,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (hatimStyle == HatimStyle.allTogetherInOneHatim) {
                          return lang.allTogetherInOneHatimMustBe30;
                        }
                        return null;
                      } else if (value.isNotEmpty) {
                        final n = num.tryParse(value);
                        if (n == null) {
                          return lang.pleaseEnterValidNumber!;
                        }

                        if (hatimStyle == HatimStyle.allTogetherInOneHatim) {
                          if (n != 30) {
                            return lang.allTogetherInOneHatimMustBe30;
                          }
                        } else {
                          if (n < 1) {
                            return lang.pleaseEnterValidNumber!;
                          } else if (n > 100) {
                            return lang.pleaseEnterNumberLessThan100!;
                          }
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Error Messages
                  if (isExistMessage)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeColor.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: themeColor.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: themeColor.onErrorContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lang.groupNameAlreadyExists!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: themeColor.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: themeColor.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: themeColor.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: themeColor.onErrorContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: themeColor.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => dismissDialog(),
                        child: Text(
                          lang.close!,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: themeColor.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: themeColor.primary,
                          foregroundColor: themeColor.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && !isLoading) {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                              isExistMessage = false;
                            });

                            try {
                              // Trim the group ID and name before checking
                              final trimmedGroupID = groupIDController.text
                                  .trim();
                              final trimmedGroupName = groupNameController.text
                                  .trim();

                              /// check if the group ID is exist from the repo if it is exist then show the error message to generate new one
                              if (await groupController.getGroupByID(
                                    trimmedGroupID,
                                  ) !=
                                  null) {
                                setState(() {
                                  isExistMessage = true;
                                  isLoading = false;
                                });
                                return;
                              }

                              // Default to 30 if count is empty
                              final count = countController.text.isEmpty
                                  ? 30
                                  : int.parse(countController.text);
                              // Ensure count is at least 1
                              final validatedCount = count < 1
                                  ? 30
                                  : (count > 100 ? 100 : count);

                              final result = await groupController.addNewGroup(
                                trimmedGroupID,
                                name: trimmedGroupName,
                                groupDateType: groupDateType,
                                hatimStyle: hatimStyle,
                                count: validatedCount,
                                adminId: widget.adminId,
                                userId: userController.getCurrentUserID,
                              );

                              if (result.isSuccess) {
                                dismissDialog();
                              } else {
                                setState(() {
                                  errorMessage =
                                      result.error ??
                                      (lang.failedToCreateGroup ??
                                          'Failed to create group');
                                  isLoading = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                errorMessage =
                                    '${lang.unexpectedErrorOccurred ?? 'An unexpected error occurred'}: ${e.toString()}';
                                isLoading = false;
                              });
                            }
                          }
                        },
                        icon: isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: themeColor.onPrimary,
                                ),
                              )
                            : const Icon(Icons.add, size: 18),
                        label: Text(isLoading ? '' : lang.add!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddHatimGroupSheetState extends State<AddHatimGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController groupIDController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  late GroupDateType groupDateType = GroupDateType.week;
  late HatimStyle hatimStyle = HatimStyle.allTogetherInOneHatim;
  bool isExistMessage = false;
  bool isLoading = false;
  String? errorMessage;

  // Calendar type and date/time fields
  GroupCalendarType calendarType = GroupCalendarType.hijri;
  DateTime? selectedGregorianDate;
  // Hijri date components
  int? hijriYear;
  int? hijriMonth;
  int? hijriDay;
  TimeOfDay? selectedTime;

  // Helper function to get localized hatim style name
  String _getHatimStyleName(HatimStyle style, Localization lang) {
    switch (style) {
      case HatimStyle.allTogetherInOneHatim:
        return lang.hatimStyleAllTogetherInOneHatim ??
            'All Together in One Hatim';
      case HatimStyle.byRounds:
        return lang.hatimStyleByRounds ?? 'By Rounds';
      case HatimStyle.byChallenge:
        return lang.hatimStyleByChallenge ?? 'By Challenge';
    }
  }

  // Helper function to get localized hatim style description
  String _getHatimStyleDescription(HatimStyle style, Localization lang) {
    switch (style) {
      case HatimStyle.allTogetherInOneHatim:
        return lang.hatimStyleAllTogetherInOneHatimDescription ??
            'All group members read the same hatim together. The group must have exactly 30 members.';
      case HatimStyle.byRounds:
        return lang.hatimStyleByRoundsDescription ??
            'Group members read hatim in rounds. Each round has a different distribution.';
      case HatimStyle.byChallenge:
        return lang.hatimStyleByChallengeDescription ??
            'Group members read hatim in a challenge format. Provides a more flexible distribution.';
    }
  }

  // Helper function to get localized group date type name
  String _getGroupDateTypeName(GroupDateType dateType, Localization lang) {
    switch (dateType) {
      case GroupDateType.week:
        return lang.groupDateTypeWeek ?? 'Week';
      case GroupDateType.day:
        return lang.groupDateTypeDay ?? 'Day';
    }
  }

  @override
  void dispose() {
    groupIDController.dispose();
    groupNameController.dispose();
    countController.dispose();
    super.dispose();
  }

  void _dismissSheet([bool? success]) {
    Navigator.pop(context, success ?? false);
  }

  Future<void> _pickGregorianDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedGregorianDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != selectedGregorianDate) {
      setState(() {
        selectedGregorianDate = picked;
      });
    }
  }

  Future<void> _pickHijriDate() async {
    final lang = Provider.of<LocalizationController>(context, listen: false).getLanguage();
    final currentHijri = CalendarConversion.getCurrentHijriDate();
    
    int tempYear = hijriYear ?? currentHijri.year;
    int tempMonth = hijriMonth ?? currentHijri.month;
    int tempDay = hijriDay ?? currentHijri.day;
    
    final months = CalendarConversion.getHijriMonthNames();
    
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(lang.selectHijriDate ?? 'Select Hijri Date'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Day
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          initialValue: tempDay,
                          decoration: InputDecoration(
                            labelText: 'Day',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          items: List.generate(30, (i) => i + 1).map((day) {
                            return DropdownMenuItem(value: day, child: Text('$day'));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setDialogState(() => tempDay = value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Month
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField<int>(
                          initialValue: tempMonth,
                          decoration: InputDecoration(
                            labelText: 'Month',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          items: List.generate(12, (i) => i + 1).map((month) {
                            return DropdownMenuItem(
                              value: month,
                              child: Text(months[month - 1]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setDialogState(() => tempMonth = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Year
                  TextFormField(
                    initialValue: tempYear.toString(),
                    decoration: InputDecoration(
                      labelText: 'Year',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final year = int.tryParse(value);
                      if (year != null && year > 0) {
                        tempYear = year;
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(lang.cancel ?? 'Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(lang.done ?? 'Done'),
                  onPressed: () {
                    Navigator.of(context).pop({
                      'year': tempYear,
                      'month': tempMonth,
                      'day': tempDay,
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
    
    if (result != null) {
      setState(() {
        hijriYear = result['year'];
        hijriMonth = result['month'];
        hijriDay = result['day'];
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String _getConvertedDateText(Localization lang) {
    if (calendarType == GroupCalendarType.hijri && hijriYear != null && hijriMonth != null && hijriDay != null) {
      // Convert Hijri to Gregorian for display
      final gregorian = CalendarConversion.hijriToGregorian(
        hijriYear: hijriYear!,
        hijriMonth: hijriMonth!,
        hijriDay: hijriDay!,
      );
      return '${lang.gregorianEquivalent ?? 'Gregorian equivalent'}: ${gregorian.day}/${gregorian.month}/${gregorian.year}';
    } else if (calendarType == GroupCalendarType.gregorian && selectedGregorianDate != null) {
      // Convert Gregorian to Hijri for display
      final hijri = CalendarConversion.gregorianToHijri(selectedGregorianDate!);
      return '${lang.hijriEquivalent ?? 'Hijri equivalent'}: ${hijri.day}/${hijri.month}/${hijri.year}';
    }
    return '';
  }
  
  bool get _hasHijriDate => hijriYear != null && hijriMonth != null && hijriDay != null;
  
  String _formatHijriDate() {
    if (!_hasHijriDate) return '';
    final months = CalendarConversion.getHijriMonthNames();
    return '$hijriDay ${months[hijriMonth! - 1]} $hijriYear';
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Group ID copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context, listen: true);
    final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme;
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final userController = Provider.of<UserController>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: themeColor.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: themeColor.outline.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group_add_rounded,
                        size: 28,
                        color: themeColor.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lang.addGroup!,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: themeColor.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _dismissSheet,
                        tooltip: lang.close,
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Group Details Card
                        Card(
                          elevation: 0,
                          color: themeColor.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: themeColor.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lang.groupDetailsSection ??
                                          'Group Details',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: themeColor.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: groupNameController,
                                  decoration: InputDecoration(
                                    labelText: lang.groupName ?? 'Group Name',
                                    hintText:
                                        lang.groupNameHelperText ??
                                        'Enter a name for your group',
                                    prefixIcon: Icon(
                                      Icons.group,
                                      color: themeColor.onSurfaceVariant,
                                    ),
                                    helperText:
                                        lang.groupNameHelperText ??
                                        'This name will be shown to users',
                                    helperMaxLines: 2,
                                    filled: true,
                                    fillColor: themeColor.surface,
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return lang.groupNameIsEmpty ??
                                          'Group name is required';
                                    }
                                    final trimmed = value.trim();
                                    if (trimmed.isEmpty) {
                                      return lang.groupNameIsEmpty ??
                                          'Group name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Group ID Card
                        Card(
                          elevation: 0,
                          color: themeColor.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.tag,
                                      size: 20,
                                      color: themeColor.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lang.groupIdentificationSection ??
                                          'Group Identification',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: themeColor.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  lang.groupIDHelperText ??
                                      'Unique 6-digit identifier for your group',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: themeColor.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: groupIDController,
                                        decoration: InputDecoration(
                                          labelText: '6-digit ID',
                                          hintText: '123456',
                                          filled: true,
                                          fillColor: themeColor.surface,
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return lang.groupIDMustBe6Digits ??
                                                'Group ID is required';
                                          }
                                          final trimmed = value.trim();
                                          if (trimmed.isEmpty) {
                                            return lang.groupIDMustBe6Digits ??
                                                'Group ID is required';
                                          }
                                          if (trimmed.length != 6) {
                                            return lang.groupIDMustBe6Digits ??
                                                'Must be exactly 6 digits';
                                          }
                                          if (!RegExp(
                                            r'^\d+$',
                                          ).hasMatch(trimmed)) {
                                            return lang
                                                    .groupIDMustContainOnlyNumbers ??
                                                'Must contain only numbers';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: groupIDController,
                                      builder: (context, value, child) {
                                        if (value.text.isEmpty) {
                                          return const SizedBox.shrink();
                                        }
                                        return IconButton(
                                          icon: const Icon(Icons.copy),
                                          onPressed: () =>
                                              _copyToClipboard(value.text),
                                          tooltip: 'Copy ID',
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                themeColor.secondaryContainer,
                                            foregroundColor:
                                                themeColor.onSecondaryContainer,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            themeColor.secondaryContainer,
                                        foregroundColor:
                                            themeColor.onSecondaryContainer,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                isLoading = true;
                                                errorMessage = null;
                                                isExistMessage = false;
                                              });

                                              try {
                                                final randomID =
                                                    await groupController
                                                        .generateUniqueRandomGroupID();
                                                groupIDController.text =
                                                    randomID;
                                                setState(() {
                                                  isLoading = false;
                                                  isExistMessage = false;
                                                });
                                              } catch (e) {
                                                setState(() {
                                                  errorMessage =
                                                      '${lang.failedToGenerateRandomID ?? 'Failed to generate ID'}: ${e.toString()}';
                                                  isLoading = false;
                                                });
                                              }
                                            },
                                      icon: isLoading
                                          ? SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: themeColor
                                                    .onSecondaryContainer,
                                              ),
                                            )
                                          : const Icon(Icons.shuffle, size: 16),
                                      label: Text(isLoading ? '' : 'Generate'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Hatim Configuration Card
                        Card(
                          elevation: 0,
                          color: themeColor.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 20,
                                      color: themeColor.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lang.hatimConfigurationSection ??
                                          'Hatim Configuration',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: themeColor.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Hatim Style Dropdown (First)
                                DropdownButtonFormField<HatimStyle>(
                                  decoration: InputDecoration(
                                    labelText:
                                        lang.hatimStyleLabel ?? 'Reading Style',
                                    prefixIcon: Icon(
                                      Icons.book,
                                      color: themeColor.onSurfaceVariant,
                                    ),
                                    helperText: _getHatimStyleDescription(
                                      hatimStyle,
                                      lang,
                                    ),
                                    helperMaxLines: 3,
                                    filled: true,
                                    fillColor: themeColor.surface,
                                  ),
                                  initialValue: hatimStyle,
                                  onChanged: (HatimStyle? newValue) {
                                    setState(() {
                                      hatimStyle = newValue!;
                                      // If switching to allTogetherInOneHatim, set count to 30
                                      if (hatimStyle ==
                                          HatimStyle.allTogetherInOneHatim) {
                                        countController.text = '30';
                                      }
                                    });
                                    // Revalidate the form to show/hide error messages
                                    _formKey.currentState?.validate();
                                  },
                                  items: HatimStyle.values
                                      .map<DropdownMenuItem<HatimStyle>>(
                                        (HatimStyle value) =>
                                            DropdownMenuItem<HatimStyle>(
                                              value: value,
                                              child: Text(
                                                _getHatimStyleName(value, lang),
                                                style:
                                                    theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 16),

                                // Date Type Dropdown (Second)
                                DropdownButtonFormField<GroupDateType>(
                                  decoration: InputDecoration(
                                    labelText:
                                        lang.groupDateTypeLabel ??
                                        'Duration Type',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: themeColor.onSurfaceVariant,
                                    ),
                                    helperText:
                                        lang.durationTypeHelperText ??
                                        'Choose how long members have to complete their portions',
                                    helperStyle: theme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: themeColor.onSurfaceVariant,
                                        ),
                                    helperMaxLines: 3,
                                    filled: true,
                                    fillColor: themeColor.surface,
                                  ),
                                  initialValue: groupDateType,
                                  onChanged: (GroupDateType? newValue) {
                                    setState(() {
                                      groupDateType = newValue!;
                                    });
                                  },
                                  items: GroupDateType.values
                                      .map<DropdownMenuItem<GroupDateType>>(
                                        (
                                          GroupDateType value,
                                        ) => DropdownMenuItem<GroupDateType>(
                                          value: value,
                                          child: Text(
                                            _getGroupDateTypeName(value, lang),
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 16),

                                // Group Count Field (Third)
                                TextFormField(
                                  controller: countController,
                                  enabled:
                                      hatimStyle !=
                                      HatimStyle.allTogetherInOneHatim,
                                  decoration: InputDecoration(
                                    labelText: lang.groupCountDefault!,
                                    hintText:
                                        hatimStyle ==
                                            HatimStyle.allTogetherInOneHatim
                                        ? '30'
                                        : '1-100',
                                    prefixIcon: Icon(
                                      Icons.people,
                                      color: themeColor.onSurfaceVariant,
                                    ),
                                    helperText:
                                        hatimStyle ==
                                            HatimStyle.allTogetherInOneHatim
                                        ? lang.allTogetherInOneHatimMustBe30Description
                                        : lang.otherStylesCanBeFlexible,
                                    helperMaxLines: 2,
                                    filled: true,
                                    fillColor:
                                        hatimStyle ==
                                            HatimStyle.allTogetherInOneHatim
                                        ? themeColor.surfaceContainerHighest
                                              .withValues(alpha: 0.5)
                                        : themeColor.surface,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      if (hatimStyle ==
                                          HatimStyle.allTogetherInOneHatim) {
                                        return lang
                                            .allTogetherInOneHatimMustBe30;
                                      }
                                      return null;
                                    } else if (value.isNotEmpty) {
                                      final n = num.tryParse(value);
                                      if (n == null) {
                                        return lang.pleaseEnterValidNumber!;
                                      }

                                      if (hatimStyle ==
                                          HatimStyle.allTogetherInOneHatim) {
                                        if (n != 30) {
                                          return lang
                                              .allTogetherInOneHatimMustBe30;
                                        }
                                      } else {
                                        if (n < 1) {
                                          return lang.pleaseEnterValidNumber!;
                                        } else if (n > 100) {
                                          return lang
                                              .pleaseEnterNumberLessThan100!;
                                        }
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Schedule Configuration Card (Calendar Type + Start Date/Time)
                        Card(
                          elevation: 0,
                          color: themeColor.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 20,
                                      color: themeColor.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      lang.startDateTimeSection ??
                                          'Schedule Configuration',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: themeColor.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Calendar Type Selection
                                Text(
                                  lang.calendarTypeLabel ?? 'Calendar Type',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: themeColor.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang.calendarTypeHelperText ??
                                      'Choose the calendar system for this group. This cannot be changed later.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: themeColor.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SegmentedButton<GroupCalendarType>(
                                  segments: [
                                    ButtonSegment<GroupCalendarType>(
                                      value: GroupCalendarType.hijri,
                                      label: Text(lang.hijriCalendar ?? 'Hijri'),
                                      icon: const Icon(Icons.calendar_month),
                                    ),
                                    ButtonSegment<GroupCalendarType>(
                                      value: GroupCalendarType.gregorian,
                                      label: Text(lang.gregorianCalendar ?? 'Gregorian'),
                                      icon: const Icon(Icons.calendar_today),
                                    ),
                                  ],
                                  selected: {calendarType},
                                  onSelectionChanged: (Set<GroupCalendarType> selected) {
                                    setState(() {
                                      calendarType = selected.first;
                                      // Clear the opposite date when switching
                                      if (calendarType == GroupCalendarType.hijri) {
                                        selectedGregorianDate = null;
                                      } else {
                                        hijriYear = null;
                                        hijriMonth = null;
                                        hijriDay = null;
                                      }
                                    });
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Start Date Selection
                                Text(
                                  lang.startDateLabel ?? 'Start Date (Optional)',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: themeColor.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang.startDateHelperText ??
                                      'When the hatim should start. Leave empty to start when group is full.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: themeColor.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                if (calendarType == GroupCalendarType.gregorian)
                                  ListTile(
                                    tileColor: themeColor.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: themeColor.outline.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.calendar_today,
                                      color: themeColor.primary,
                                    ),
                                    title: Text(
                                      selectedGregorianDate == null
                                          ? (lang.selectDate ?? 'Select Date')
                                          : '${selectedGregorianDate!.day}/${selectedGregorianDate!.month}/${selectedGregorianDate!.year}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    trailing: selectedGregorianDate != null
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                selectedGregorianDate = null;
                                              });
                                            },
                                          )
                                        : const Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: _pickGregorianDate,
                                  )
                                else
                                  ListTile(
                                    tileColor: themeColor.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: themeColor.outline.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.calendar_month,
                                      color: themeColor.primary,
                                    ),
                                    title: Text(
                                      !_hasHijriDate
                                          ? (lang.selectHijriDate ?? 'Select Hijri Date')
                                          : _formatHijriDate(),
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    trailing: _hasHijriDate
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                hijriYear = null;
                                                hijriMonth = null;
                                                hijriDay = null;
                                              });
                                            },
                                          )
                                        : const Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: _pickHijriDate,
                                  ),

                                const SizedBox(height: 16),

                                // Start Time Selection
                                Text(
                                  lang.startTimeLabel ?? 'Start Time (Optional)',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: themeColor.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListTile(
                                  tileColor: themeColor.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: themeColor.outline.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.access_time,
                                    color: themeColor.primary,
                                  ),
                                  title: Text(
                                    selectedTime == null
                                        ? (lang.selectTime ?? 'Select Time')
                                        : selectedTime!.format(context),
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  trailing: selectedTime != null
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              selectedTime = null;
                                            });
                                          },
                                        )
                                      : const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: _pickTime,
                                ),

                                // Show converted date if both calendars should be displayed
                                if ((calendarType == GroupCalendarType.hijri && _hasHijriDate) ||
                                    (calendarType == GroupCalendarType.gregorian && selectedGregorianDate != null))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: themeColor.primaryContainer.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: themeColor.onPrimaryContainer,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _getConvertedDateText(lang),
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: themeColor.onPrimaryContainer,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Error Messages
                        if (isExistMessage)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeColor.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeColor.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: themeColor.onErrorContainer,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    lang.groupNameAlreadyExists!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: themeColor.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: themeColor.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeColor.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: themeColor.onErrorContainer,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    errorMessage!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: themeColor.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Bottom spacing for action buttons
                        SizedBox(height: bottomPadding + 80),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Action Bar
                Container(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 12),
                  decoration: BoxDecoration(
                    color: themeColor.surface,
                    border: Border(
                      top: BorderSide(
                        color: themeColor.outline.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading ? null : _dismissSheet,
                          child: Text(lang.close!),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate() &&
                                      !isLoading) {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                      isExistMessage = false;
                                    });

                                    try {
                                      final trimmedGroupID = groupIDController
                                          .text
                                          .trim();
                                      final trimmedGroupName =
                                          groupNameController.text.trim();

                                      if (await groupController.getGroupByID(
                                            trimmedGroupID,
                                          ) !=
                                          null) {
                                        setState(() {
                                          isExistMessage = true;
                                          isLoading = false;
                                        });
                                        return;
                                      }

                                      final count = countController.text.isEmpty
                                          ? 30
                                          : int.parse(countController.text);
                                      final validatedCount = count < 1
                                          ? 30
                                          : (count > 100 ? 100 : count);

                                      // Prepare date/time values
                                      DateTime? plannedStartDate;
                                      int? hijriStartYear;
                                      int? hijriStartMonth;
                                      int? hijriStartDay;

                                      if (calendarType == GroupCalendarType.hijri && _hasHijriDate) {
                                        hijriStartYear = hijriYear;
                                        hijriStartMonth = hijriMonth;
                                        hijriStartDay = hijriDay;
                                        // Convert to Gregorian for plannedStartDate
                                        plannedStartDate = CalendarConversion.hijriToGregorian(
                                          hijriYear: hijriStartYear!,
                                          hijriMonth: hijriStartMonth!,
                                          hijriDay: hijriStartDay!,
                                          hour: selectedTime?.hour ?? 0,
                                          minute: selectedTime?.minute ?? 0,
                                        );
                                      } else if (calendarType == GroupCalendarType.gregorian && selectedGregorianDate != null) {
                                        plannedStartDate = DateTime(
                                          selectedGregorianDate!.year,
                                          selectedGregorianDate!.month,
                                          selectedGregorianDate!.day,
                                          selectedTime?.hour ?? 0,
                                          selectedTime?.minute ?? 0,
                                        );
                                        // Convert to Hijri for storage
                                        final hijriEquiv = CalendarConversion.gregorianToHijri(selectedGregorianDate!);
                                        hijriStartYear = hijriEquiv.year;
                                        hijriStartMonth = hijriEquiv.month;
                                        hijriStartDay = hijriEquiv.day;
                                      }

                                      final result = await groupController
                                          .addNewGroup(
                                            trimmedGroupID,
                                            name: trimmedGroupName,
                                            groupDateType: groupDateType,
                                            hatimStyle: hatimStyle,
                                            count: validatedCount,
                                            adminId: widget.adminId,
                                            userId: userController.getCurrentUserID,
                                            calendarType: calendarType,
                                            plannedStartDate: plannedStartDate,
                                            hijriStartYear: hijriStartYear,
                                            hijriStartMonth: hijriStartMonth,
                                            hijriStartDay: hijriStartDay,
                                            startHour: selectedTime?.hour,
                                            startMinute: selectedTime?.minute,
                                          );

                                      if (result.isSuccess) {
                                        _dismissSheet(true);
                                      } else {
                                        setState(() {
                                          errorMessage =
                                              result.error ??
                                              (lang.failedToCreateGroup ??
                                                  'Failed to create group');
                                          isLoading = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        errorMessage =
                                            '${lang.unexpectedErrorOccurred ?? 'An unexpected error occurred'}: ${e.toString()}';
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                          icon: isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: themeColor.onPrimary,
                                  ),
                                )
                              : const Icon(Icons.add, size: 18),
                          label: Text(isLoading ? '' : lang.add!),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
