import 'package:better_video_player/screens/uploadvideo.dart';
import 'package:better_video_player/screens/uploadvideo_for_trim.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:better_video_player/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (Context) => UploadVideo()));
                },
                child: ButtonWidget(buttonname: "Compress Video"),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Or",
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (Context) => ChooseVideoForTrim()));
                  },
                  child: ButtonWidget(buttonname: "Trim Video")),
            ],
          ),
        ),
      ),
    );
  }
}
