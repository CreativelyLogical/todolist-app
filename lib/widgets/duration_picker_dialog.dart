import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';

class DurationPicker extends StatefulWidget {
  @override
  _DurationPickerState createState() => _DurationPickerState();

  DurationPicker({this.setReminderCallback});

  final Function setReminderCallback;
}

class _DurationPickerState extends State<DurationPicker> {
  List<DropdownMenuItem> timeUnitsList = [
    DropdownMenuItem(
      child: Text(
        'Minutes before',
      ),
      value: 'Minutes before',
    ),
    DropdownMenuItem(
      child: Text(
        'Hours before',
      ),
      value: 'Hours before',
    ),
    DropdownMenuItem(
      child: Text(
        'Days before',
      ),
      value: 'Days before',
    ),
    DropdownMenuItem(
      child: Text(
        'Weeks before',
      ),
      value: 'Weeks before',
    ),
  ];

  String selectedTimeUnit = 'Minutes before';

  TextEditingController dialogTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        height: SizeConfig.screenHeight * 0.3,
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.1),
              child: Text(
                'Add reminder',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.03,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.1),
                  width: 70.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: dialogTextFieldController,
                  ),
                ),
                DropdownButton(
                  items: timeUnitsList,
                  value: selectedTimeUnit,
                  onChanged: (newTimeUnit) {
                    setState(() {
                      selectedTimeUnit = newTimeUnit;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    child: SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      right: 20,
                    ),
                    child: SimpleDialogOption(
                      onPressed: () {
                        if (dialogTextFieldController.text == '1')
                          selectedTimeUnit =
                              selectedTimeUnit.replaceFirst('s', '');
                        String newReminder =
                            '${dialogTextFieldController.text} $selectedTimeUnit';
                        widget.setReminderCallback(newReminder);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
