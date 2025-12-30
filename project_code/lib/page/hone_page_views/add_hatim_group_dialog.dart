import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatim_program/controller/contollers.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../localization/localization.dart';

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

                                      final result = await groupController
                                          .addNewGroup(
                                            trimmedGroupID,
                                            name: trimmedGroupName,
                                            groupDateType: groupDateType,
                                            hatimStyle: hatimStyle,
                                            count: validatedCount,
                                            adminId: widget.adminId,
                                            userId:
                                                userController.getCurrentUserID,
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
