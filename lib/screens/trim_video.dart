import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:better_video_player/screens/uploadvideo.dart';
import 'package:better_video_player/screens/uploadvideo_for_trim.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as path;

class TrimVideo extends StatefulWidget {
  TrimVideo(this.videoPath);

  final String videoPath;
  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  late BetterPlayerController _betterPlayerController;

  bool _loading = false;
  String _counter = "video";

  VideoQuality _quality = VideoQuality.DefaultQuality;

  // _compress() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   await VideoCompress.setLogLevel(0);

  //   final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
  //     widget.videoPath,
  //     quality: _quality,
  //     deleteOrigin: false,
  //     includeAudio: true,
  //     startTime: 0,
  //     duration: 30,
  //   );

  //   setState(() {
  //     _loading = false;
  //   });
  //   //  print(mediaInfo!.path);
  //   if (mediaInfo != null) {
  //     setState(() {
  //       _counter = mediaInfo.path!;
  //     });

  //     print("compressed");

  //     var file = File('${mediaInfo.path}');
  //     await file.copy(
  //         '/storage/emulated/0/Download/${path.basename(mediaInfo.path!)}');

  //     setState(() {
  //       _loading = false;
  //     });

  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (Context) => ChooseVideoForTrim()));

  //     Fluttertoast.showToast(msg: "Compression Completed ");
  //   } else {
  //     VideoCompress.cancelCompression();
  //     Fluttertoast.showToast(msg: "Compression Cancelled");
  //     print("Compression Cancelled");
  //   }
  // }

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

  // double _value = 0;

  // bool click = false;
  // _tap() {
  //   setState(() {
  //     click = !click;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState

    _grantPermission();
    super.initState();
    // trimfunction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    VideoCompress.cancelCompression();
    super.dispose();
  }

  void trimfunction(int type) async {
    setState(() {
      _loading = false;
    });
    final MediaInfo? videoInfo =
        await VideoCompress.getMediaInfo(widget.videoPath);
    var Video_cut_length = 10;
    if (type == 1) {
      Video_cut_length = 30;
    }
    if (type == 2) {
      Video_cut_length = 10;
    }
    var seconds = (videoInfo!.duration! / 1000).ceil();
    print('Seconds : ${seconds}');
    var div = seconds / Video_cut_length;
    print('Division : ${div}');
    var ceil = div.ceil();
    print('ceil ${ceil}');
    for (var i = 0; i < ceil; i++) {
      var st = i * Video_cut_length;
      print('Start Time : ${st}');
      var duration = seconds - st - Video_cut_length;
      var du = duration < 0 ? 0 : duration;

      print('Duration : ${du}');
      setState(() {
        _loading = true;
      });
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        widget.videoPath,
        quality: _quality,
        deleteOrigin: false,
        includeAudio: true,
        startTime: st,
        duration: du,
      );
      var file = File('${mediaInfo!.path}');
      await file.copy(
          '/storage/emulated/0/Download/${path.basename(mediaInfo.path!)}');
    }
    setState(() {
      _loading = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (Context) => ChooseVideoForTrim()));
    Fluttertoast.showToast(msg: "Compression Completed ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Stack(
            children: [
              Column(
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
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Buttons(
                        path: widget.videoPath,
                        img: "assets/icons/whatsapp.png",
                        onPressed: () {
                          trimfunction(1);
                        },
                      ),
                      Buttons(
                        path: widget.videoPath,
                        img: "assets/icons/instagram (2).png",
                        onPressed: () {
                          trimfunction(2);
                        },
                      )
                    ],
                  )
                ],
              ),
              _loading
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Compressing Video....",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              LinearProgressIndicator(
                                semanticsLabel: 'Linear progress indicator',
                                color: AppColors.appColor,
                                backgroundColor: AppColors.appcolorwithop,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      VideoCompress.cancelCompression();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.appColor,
                                        // color: Colors.white,
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }
}

class Buttons extends StatefulWidget {
  const Buttons({required this.img, required this.path, this.onPressed})
      : super();
  final String path;
  final String img;
  final Function? onPressed;

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed?.call();
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: AppColors.appColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.img,
                  height: 30,
                  width: 30,
                ),
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
    );
  }
}
