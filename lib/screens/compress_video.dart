import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:better_video_player/screens/custom.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:better_video_player/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class CompressVideo extends StatefulWidget {
  CompressVideo(this.videoPath);

  final String videoPath;

  @override
  _CompressVideoState createState() => _CompressVideoState();
}

class _CompressVideoState extends State<CompressVideo> {

  bool _loading = true;
  File? videofile;
  int? videoSize;

  _initPlayer() {
    final file = File(widget.videoPath);
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

  late BetterPlayerController _betterPlayerController;

  String idx = "Basic Compression";

  List<String> typesList = [
    "Basic Compression",
    "Strong Compression",
    "Custom",
  ];
  List<String> descList = [
    "Medium file size, high Quality",
    "Smallest file size, best quality",
    "Choose your own settings",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
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
          "Compress Video",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Column(
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
                      aspectRatio: 16/9,
                      looping: false,
                      autoPlay: false,
                      fit: BoxFit.contain,
                    ),
                  
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 40, bottom: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildVideoSize(),
                    Column(
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
                          "1,2MB",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: typesList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            idx = typesList[index];
                          });
                        },
                        child: CompressionTypeListWidget(
                          typename: typesList[index],
                          desc: descList[index],
                          boxposition: idx,
                        ));
                  },
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (Context) => Custom(
                                  
                                  widget.videoPath,
                                  
                                  //'${videoSize}',
                                )));
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                          top: 50, bottom: 50, left: 10, right: 10),
                      child: ButtonWidget(
                        buttonname: "Continue",
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class CompressionTypeListWidget extends StatefulWidget {
  const CompressionTypeListWidget(
      {required this.typename, required this.desc, required this.boxposition});

  final String typename;
  final String desc;
  final String boxposition;

  @override
  _CompressionTypeListWidgetState createState() =>
      _CompressionTypeListWidgetState();
}

class _CompressionTypeListWidgetState extends State<CompressionTypeListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      decoration: widget.boxposition == widget.typename
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.appcolorwithop)
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.typename,
                // "Basic Compression",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.desc,
                // "Medium file size, best quality",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          widget.boxposition == widget.typename
              ? Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
