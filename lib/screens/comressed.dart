import 'dart:typed_data';

import 'package:better_video_player/screens/uploadvideo.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:better_video_player/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class Compressed extends StatefulWidget {
  const Compressed(this.videofilepath,this.cmediainfo );

  final String videofilepath;
final MediaInfo cmediainfo;
  @override
  _CompressedState createState() => _CompressedState();
}

class _CompressedState extends State<Compressed> {
  Uint8List? thumbnailBytes;
  Future generateThumbnail() async {
    final thumbnailBytes =
        await VideoCompress.getByteThumbnail(widget.videofilepath);
    setState(() {
      this.thumbnailBytes = thumbnailBytes;
    });
  }

MediaInfo? CompressedVideoInfo;

  Future generateCompressedVideoInfo() async {
   
    setState(() {
      CompressedVideoInfo = widget.cmediainfo;
    });
  }
  Widget buildCompressedVideoInfo(){
    if (CompressedVideoInfo == null) return Container();
    final size = CompressedVideoInfo!.filesize! / 1000;
       final sizee = size/1024; 
 var mb=sizee.toStringAsFixed(1);
    return  Text(
                  "$mb MB",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                );
  }

  Widget buildThumbNail() => thumbnailBytes == null
      ? CircularProgressIndicator()
      : ClipRRect(
         borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            thumbnailBytes!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        );






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateThumbnail();
    generateCompressedVideoInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(left: 10),
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[700],
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.5, color: Colors.green)),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Compressed",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                buildCompressedVideoInfo(),
                // Text(
                //   "1,2MB",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w700),
                // ),
                SizedBox(
                  height: 50,
                ),
                buildThumbNail(),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Your Video has been saved in photos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (Context) => Compressed()));
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                            top: 50, bottom: 20, left: 10, right: 10),
                        child: ButtonWidget(
                          buttonname: "Compress new video",
                        ))),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (Context) => UploadVideo()));
                  },
                  child: Text(
                    "Back to Home",
                    style: TextStyle(
                        color: AppColors.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
