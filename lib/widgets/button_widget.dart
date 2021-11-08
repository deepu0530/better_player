import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';


class ButtonWidget extends StatefulWidget {
  const ButtonWidget({ required this.buttonname}) ;
final String buttonname;
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        // margin: EdgeInsets.only(top: 50, bottom: 50,left: 10,right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: AppColors.appColor,
                        ),
                        child: Center(
                          child: Text(
                            widget.buttonname,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ));
  }
}