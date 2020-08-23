import 'package:flutter/material.dart';
import 'package:my_todo/constants.dart';
import 'package:my_todo/size_config.dart';

class DeleteTaskDialog extends StatelessWidget {
  DeleteTaskDialog({this.onDeleteTaskCallback});

  final Function onDeleteTaskCallback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        width: SizeConfig.screenWidth * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(0, 2),
                    color: Colors.grey.shade300,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.05,
                top: SizeConfig.screenHeight * 0.02,
                bottom: SizeConfig.screenHeight * 0.02,
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.04,
                  ),
                  Text(
                    'Delete this task?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: SizeConfig.screenHeight * 0.05,
              ),
              child: Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: SizeConfig.blockSizeVertical * 2,
                ),
                textAlign: TextAlign.start,
              ),
            ),
//            FlatButton(
//              child: Container(
//                padding: EdgeInsets.symmetric(
//                  vertical: 5,
//                ),
////                width: double.infinity,
////                decoration: BoxDecoration(
////                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
////                    border: Border.all(
////                      color: kGrey,
////                      width: 0.5,
////                    )),
//                child: Text(
//                  'Delete',
//                  style: TextStyle(
//                    fontSize: SizeConfig.blockSizeVertical * 2.2,
//                    color: Colors.red,
//                  ),
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              onPressed: () {},
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.2,
                        color: kBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'cancelled');
                  },
                ),
                FlatButton(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.2,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      onDeleteTaskCallback();
                      Navigator.pop(context, 'deleted');
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
