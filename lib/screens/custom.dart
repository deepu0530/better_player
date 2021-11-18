import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:better_video_player/screens/comressed.dart';
import 'package:better_video_player/utils/colors.dart';

import 'package:better_video_player/widgets/button_widget.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import 'package:video_compress/video_compress.dart';

class Custom extends StatefulWidget {
  Custom(
    this.videofilePath,
   // this.videosize,
  );

  final String videofilePath;
  //final String videosize;

  @override
  _CustomState createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  File? videofile;
  int? videoSize;

  _initPlayer() {
    final file = File(widget.videofilePath);
    setState(() {
      videofile = file;
    });

    getVideoSize(videofile!);
  }

  Future getVideoSize(File file) async {
    final vsize = await file.length();
    setState(() {
      videoSize = vsize;
    });
  }

  Widget buildVideoSize() {
    if (videoSize == null) return Container();
    final size = videoSize! / 1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Original Size",
          style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$size kb",
          // "3,6MB",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Uint8List? thumbnailBytes;

  Future generateThumbnail() async {
    final thumbnailBytes =
        await VideoCompress.getByteThumbnail(widget.videofilePath);
    setState(() {
      this.thumbnailBytes = thumbnailBytes;
    });
  }

  Widget buildThumbNail() => thumbnailBytes == null
      ? CircularProgressIndicator()
      :  ClipRRect(
        borderRadius: BorderRadius.circular(10),
          child: Image.memory(
          
            thumbnailBytes!,
            width: 120,
            height: 140,
            fit: BoxFit.cover,
          ),
        );

  bool _loading = false;
  String _counter = "video";

  VideoQuality _quality = VideoQuality.DefaultQuality;
  String name = "Default";
  


  _compress() async {
    Container(
      child: AlertDialog(
        title: Text("Alert Dialog Box"),
        content: LinearProgressIndicator(
          semanticsLabel: 'Linear progress indicator',
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("okay"),
          ),
        ],
      ),
    );
    setState(() {
      _loading = true;
    });
    await VideoCompress.setLogLevel(0);

    final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      widget.videofilePath,
      quality: _quality,
      deleteOrigin: false,
      includeAudio: click ? false : true,
    );
    setState(() {
      _loading = false;
    });
  //  print(mediaInfo!.path);
    if (mediaInfo != null) {
      setState(() {
        _counter = mediaInfo.path!;
      });

      print("compressed");

      var file = File('${mediaInfo.path}');
      await file.copy(
          '/storage/emulated/0/Download/${path.basename(mediaInfo.path!)}');

      setState(() {
        _loading = false;
      });


      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (Context) => Compressed(widget.videofilePath,mediaInfo)));
    } else {
      VideoCompress.cancelCompression();
       Fluttertoast.showToast(msg: "Compression Cancelled");
      print("Compression Cancelled");
    }
  }

  late final Permission _permission;
  void _grantPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
    } else {
      await Permission.storage.request();
      status = await Permission.storage.status;
      print(status);
    }
  }

  double _value = 0;

  bool click = false;
  _tap() {
    setState(() {
      click = !click;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    generateThumbnail();
    _initPlayer();
    _grantPermission();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    VideoCompress.cancelCompression();
    super.dispose();
    
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
        centerTitle: true,
        title: Text(
          "Custom",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    // height: 200,
                    // width: 100,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     // image: DecorationImage(
                    //     //     image:
                    //     //     AssetImage(
                    //     //       "assets/images/image.png",
                    //     //     ),
                    //     //     fit: BoxFit.cover),
                    //         ),
                    child: buildThumbNail()),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Original Size",
                        //       style: TextStyle(
                        //           color: Colors.white.withOpacity(0.5),
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     Text(

                        //       '${widget.videosize} kb',
                        //       // "3,6MB",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w700),
                        //     ),
                        //   ],
                        // ),
                        buildVideoSize(),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expected Size",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "1.2MB",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _tap(),
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: click
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    color: AppColors.appColor)
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                            child: Center(
                              child: click
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Remove audio",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              margin: EdgeInsets.only(top: 50, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Video Size",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Text(
                            "1.2MB",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "50%",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.lightGreen,
                      inactiveTrackColor: Colors.grey[600],
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 6.0,
                      thumbColor: Colors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: Slider(
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ),
                  // Text(
                  //   "1.2MB",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w400),
                  // ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quality",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        //  "High",
                        name,

                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Transform.scale(
                      //   scale: 0.7,
                      //   child: Radio(
                      //       activeColor: Colors.orangeAccent,
                      //       value: 0,
                      //       groupValue: select,
                      //       onChanged: (int? val) {
                      //         print("selected $val");
                      //         setState(() {
                      //           select = val;
                      //           name = "Low";
                      //         });
                      //       }),
                      // ),
                      Transform.scale(
                        scale: 0.8,
                        child: Radio(
                            activeColor: Colors.orangeAccent,
                            value: VideoQuality.LowQuality,
                            groupValue: _quality,
                            onChanged: (VideoQuality? val) {
                              setState(() {
                                _quality = val!;
                                name = "Low";
                              });
                            }),
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: Radio(
                            activeColor: Colors.orangeAccent,
                            value: VideoQuality.MediumQuality,
                            groupValue: _quality,
                            onChanged: (VideoQuality? val) {
                              setState(() {
                                _quality = val!;
                                name = "Medum";
                              });
                            }),
                      ),
                      Transform.scale(
                        scale: 1.0,
                        child: Radio(
                            activeColor: Colors.orangeAccent,
                            value: VideoQuality.DefaultQuality,
                            groupValue: _quality,
                            onChanged: (VideoQuality? val) {
                              setState(() {
                                _quality = val!;
                                name = "Default";
                              });
                            }),
                      ),
                      Transform.scale(
                        scale: 1.1,
                        child: Radio(
                            activeColor: Colors.orangeAccent,
                            value: VideoQuality.HighestQuality,
                            groupValue: _quality,
                            onChanged: (VideoQuality? val) {
                              setState(() {
                                _quality = val!;
                                name = "High";
                              });
                            }),
                      ),
                      // Transform.scale(
                      //   scale: 1.2,
                      //   child: Radio(
                      //       activeColor: Colors.orangeAccent,
                      //       value: 5,
                      //       groupValue: select,
                      //       onChanged: (val) {
                      //         print("selected $val");
                      //         setState(() {
                      //           select = val as int?;
                      //           name = "High1";
                      //         });
                      //       }),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Codec",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        "H.264",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey[600], size: 20)
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Resolution",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        "270p",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey[600], size: 20)
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Format",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        "MOV",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey[600], size: 20)
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  _compress();
                },
                child: 
                // _loading
                //     ? LinearProgressIndicator(
                //         semanticsLabel: 'Linear progress indicator',
                //       )
                    // :
                     Container(
                        margin: EdgeInsets.only(
                            top: 50, bottom: 50, left: 10, right: 10),
                        child: ButtonWidget(
                          buttonname: "Continue",
                        )))
          ],
        ),
      )),
     _loading?
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text("Compressing Video....",
              style: TextStyle(
                color:Colors.white,
                fontWeight:FontWeight.w700,
                fontSize: 20
              ),
              ),
              SizedBox(height: 30,),
              LinearProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
                color: AppColors.appColor,
                backgroundColor: AppColors.appcolorwithop,
                
              ),
               SizedBox(height: 30,),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   GestureDetector(
                     onTap: (){
                       VideoCompress.cancelCompression();
                       Navigator.pop(context);
                     },
                     child: Container(
                       padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: AppColors.appColor,
                        // color: Colors.white,
                       ),
                       child: Text("Cancel",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 16,
                         fontWeight: FontWeight.w700
                       ),
                       ),
                     ),
                   ),
                 ],
               )
            ]
          ),
        ),
      )
      :Container()
        ],
      )
    );
  }
}
