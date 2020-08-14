import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/constants.dart';
import 'custom_flag_icon_icons.dart';

class PriorityButtons extends StatelessWidget {
  PriorityButtons(
      {this.selectedPriority, this.priority, this.onTap, this.screen});

  final String priority;

  final String selectedPriority;

  final Function onTap;

  final String screen;

  Color getPriorityColor() {
    if (priority == 'none')
      return Colors.grey.shade500;
    else if (priority == 'low')
      return Colors.green;
    else if (priority == 'medium')
      return Colors.orange;
    else if (priority == 'high') return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 3.0),
        child: CircleAvatar(
          backgroundColor: getPriorityColor(),
          radius: screen == 'add_task'
              ? SizeConfig.blockSizeVertical * 3.0
              : SizeConfig.blockSizeVertical * 3.0,
          child: selectedPriority == priority
              ? Icon(
                  CustomFlagIcon.flag,
                  color: kWhite,
                  size: SizeConfig.blockSizeVertical * 3.5,
                )
              : Container(),
//          child: Icon(
//            CustomFlagIcon.flag,
//            color:
//                selectedPriority == priority ? kWhite : kWhite.withOpacity(0),
//            size: screen == 'add_task'
//                ? SizeConfig.blockSizeVertical * 3.5
//                : SizeConfig.blockSizeVertical * 3.5,
//          ),
        ),
      ),
    );
  }
}
