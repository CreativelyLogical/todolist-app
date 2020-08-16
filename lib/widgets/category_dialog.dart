import 'package:flutter/material.dart';
import 'package:my_todo/size_config.dart';
import 'package:my_todo/constants.dart';
import 'package:flutter/cupertino.dart';

class CategoryDialog extends StatelessWidget {
  CategoryDialog({this.category, this.newCategoryCallback});

  final String category;

  final Function newCategoryCallback;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                    'Select category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.screenHeight * 0.01,
              ),
              child:
                  CategorySelection('Personal', category, newCategoryCallback),
            ),
            Divider(
              thickness: 0.5,
            ),
            CategorySelection('Work', category, newCategoryCallback),
            Divider(
              thickness: 0.5,
            ),
            CategorySelection('School', category, newCategoryCallback),
            Divider(
              thickness: 0.5,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.01),
              child:
                  CategorySelection('Business', category, newCategoryCallback),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelection extends StatelessWidget {
  CategorySelection(this.selection, this.currentCategory, this.callback);

  final String selection;

  final String currentCategory;

  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.05,
        vertical: SizeConfig.screenHeight * 0.01,
      ),
      child: InkWell(
        onTap: () {
          print('$selection pressed');
          callback(selection);
          Navigator.pop(context);
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                selection,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Spacer(),
              selection == currentCategory
                  ? Icon(
                      Icons.check,
                      color: kBlue,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
