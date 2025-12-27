import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatim_program/controller/contollers.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';

class AddHatimGroupDialog extends StatefulWidget {
  const AddHatimGroupDialog({super.key});

  @override
  State<AddHatimGroupDialog> createState() => _AddHatimGroupDialogState();
}

class _AddHatimGroupDialogState extends State<AddHatimGroupDialog> {
  // GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  //TextEditingController
  final TextEditingController groupName = TextEditingController();
  final TextEditingController countController = TextEditingController();
  // date type controller
  late GroupDateType groupDateType = GroupDateType.week;
  // hatim style
  late HatimStyle hatimStyle = HatimStyle.allTogetherInOneHatim;
  bool isExistMessage = false;


  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context, listen: true);
    //theme
    final theme = Theme.of(context);
    //colorScheme
    final themeColor = Theme.of(context).colorScheme;

    // language controller
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();


    /// in this dialog it  will add a new group to the hatim
    ///
    void dismissDialog() {
      // dismiss the dialog
      Navigator.pop(context);
    }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 350,
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text(lang.addGroup!),

                TextFormField(
                  controller: groupName,
                  decoration: InputDecoration(
                    // make it rounded
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: lang.groupName,
                    // make the help text small or 2 line
                    helperStyle: theme.textTheme.bodySmall,
                    helperMaxLines: 2,
                  ),
                  keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.pleaseEnterYourGroupName;
                    }
                    return null;
                  },
                ),

// add the group count text filed that only accept numbers and by default it is 30 max 100
                TextFormField(
                  controller: countController,
                  decoration: InputDecoration(
                    // make it rounded
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Group count default:  30',
                    // make the help text small or 2 line
                    helperStyle: theme.textTheme.bodySmall,
                    helperMaxLines: 2,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                       return null;
                    } else if (value.isNotEmpty) {
                      final n = num.tryParse(value);
                      if (n == null) {
                        return 'Please enter a valid number';
                      }else if (n > 100) {
                        return 'Please enter a number less than 100';
                      }

                    }
                    return null;
                  },
                ),

                // drop down for the group date type and by default it is week
                // drop down for the group date type and by default it is week
                DropdownButtonFormField<GroupDateType>(
                  decoration: InputDecoration(
                    // make it rounded
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Group date type',
                    // make the help text small or 2 line
                    helperStyle: theme.textTheme.bodySmall,
                    helperMaxLines: 2,
                  ),
                  value: groupDateType,
                  onChanged: (GroupDateType? newValue) {
                    setState(() {
                      groupDateType = newValue!;
                    });
                  },
                  items: GroupDateType.values
                      .map<DropdownMenuItem<GroupDateType>>(
                        (GroupDateType value) => DropdownMenuItem<GroupDateType>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        ),
                      )
                      .toList(),
                ),

                // drop down for the hatim style and by default it is all together in one hatim
                DropdownButtonFormField<HatimStyle>(
                  decoration: InputDecoration(
                    // make it rounded
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Hatim style',
                    // make the help text small or 2 line
                    helperStyle: theme.textTheme.bodySmall,
                    helperMaxLines: 2,
                  ),
                  value: hatimStyle,
                  onChanged: (HatimStyle? newValue) {
                    setState(() {
                      hatimStyle = newValue!;
                    });
                  },
                  items: HatimStyle.values
                      .map<DropdownMenuItem<HatimStyle>>(
                        (HatimStyle value) => DropdownMenuItem<HatimStyle>(
                          value: value,
                          child: Text(value.name),
                        ),
                      )
                      .toList(),
                ),

                if (isExistMessage)
                  Text(
                    'The group name is already exist please generate a new one',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: themeColor.error,
                    ),
                  ),

                //add with random ID button
                ElevatedButton(
                    // style make it primary
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeColor.onSurfaceVariant,
                      backgroundColor: themeColor.surfaceContainerHighest,
                    ),
                    onPressed: () {
                      // dismiss the dialog
                      ///check the current group name if it is the same as the generated one then generate a new one

                      groupName.text =
                          GroupModel.generateRandomGroupID().toString();
                    },
                    child: const Text('Add with random ID')),

                // add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: themeColor.onSecondary,
                        backgroundColor: themeColor.secondary,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          /// check if the group name is exist from the repo if it is exist then show the error message to generate new one
                          if (await groupController.getGroupByID(groupName.text) != null) {
                              setState(() {
                                isExistMessage = true;
                              });
                          } else {
                            setState(() {
                              isExistMessage = false;
                            });
                            groupController.addNewGroup(groupName.text,
                                groupDateType: groupDateType,
                                hatimStyle: hatimStyle,
                                count: int.parse(countController.text));
                            dismissDialog();
                          }
                        }
                        // add the group
                      },
                      child: const Text('Add'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: themeColor.onErrorContainer,
                        backgroundColor: themeColor.errorContainer,
                      ),
                      onPressed: () {
                        // cancel the dialog
                        dismissDialog();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                //add with  randum ID
                // cancel button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
