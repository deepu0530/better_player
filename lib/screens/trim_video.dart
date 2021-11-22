import 'package:better_player/better_player.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';

class TrimVideo extends StatefulWidget {
TrimVideo(this.videoPath);

  final String videoPath;
  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.blackColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Center(
                  child: Container(
                    height: 200,
                    //width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: BetterPlayer.file(
                      "${widget.videoPath}",
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        // aspectRatio: 16/9,
                         aspectRatio: 1.6,
                        looping: false,
                        autoPlay: false,
                        fit: BoxFit.contain,
                      ),
                    
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Row(
                  children: [
                     GestureDetector(
                        onTap: () {
                          // _pickVideo();
                        },
                        child: Container(
                            // width: 230,
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            margin: EdgeInsets.only(top: 30, bottom: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: AppColors.appColor,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/whatspp.png",
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                  // Icon(
                                  //   Icons.file_upload,
                                  //   size: 30,
                                  //   color: Colors.white,
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Trim Video",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(width: 20,),
                       GestureDetector(
                        onTap: () {
                          // _pickVideo();
                        },
                        child: Container(
                            // width: 230,
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            margin: EdgeInsets.only(top: 30, bottom: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: AppColors.appColor,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/instagram (2).png",
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                  // Icon(
                                  //   Icons.file_upload,
                                  //   size: 30,
                                  //   color: Colors.white,
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Trim Video",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                      ),
                  ],
                )
          ],
        ),
      ),
    );

  }
}
