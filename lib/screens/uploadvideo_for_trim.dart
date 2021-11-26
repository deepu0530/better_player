import 'package:better_player/better_player.dart';
import 'package:better_video_player/screens/trim_video.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChooseVideoForTrim extends StatefulWidget {
  const ChooseVideoForTrim({ Key? key }) : super(key: key);

  @override
  _ChooseVideoForTrimState createState() => _ChooseVideoForTrimState();
}

class _ChooseVideoForTrimState extends State<ChooseVideoForTrim> {


 final picker = ImagePicker();
  _pickVideo() async {
    XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (Context) => TrimVideo(video.path)));
    }
  }
  late BetterPlayerController _betterPlayerController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: AppColors.blackColor,
   body: Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
            Text(
                      "Upload Your Video",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w700),
                    ),
                    // SizedBox(height: 10,),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 15),
                      child: Text(
                        "Tap the \"Choose Video button\" to select your video file",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
           GestureDetector(
                      onTap: () {
                         _pickVideo();
                      },
                      child: Container(
                          width: 230,
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
                                  "assets/icons/cloud-computing.png",
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
                                  "Choose Video",
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
     ),
   ),
    );
  }
}