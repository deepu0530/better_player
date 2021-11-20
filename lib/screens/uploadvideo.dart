import 'dart:ffi';
import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';

import 'package:better_video_player/screens/compress_video.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideo extends StatefulWidget {
// const UploadVideo(this.cmediainfo );

// final MediaInfo cmediainfo;

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final picker = ImagePicker();
  _pickVideo() async {
    XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (Context) => CompressVideo(video.path)));
    }
  }

  var files;

  late String directory;
  List listFiles = <io.FileSystemEntity>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    setState(() {
      listFiles = io.Directory("/storage/emulated/0/Download/").listSync();
    });

    print(listFiles.toString());
  }
  // Widget buildThumbNail() => thumbnailBytes == null
  //     ? Center(child: CircularProgressIndicator())
  //     : ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Image.memory(
  //           thumbnailBytes!,
  //           width: 150,
  //           height: 150,
  //           fit: BoxFit.cover,
  //         ),
  //       );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "COMPR",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[700],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
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
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compressed Videos",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Image.asset(
                  "assets/icons/grid.png",
                  height: 30,
                  width: 30,
                  color: Colors.white,
                )
                // Icon(
                //   Icons.all_inbox,
                //   color: Colors.white,
                //   size: 30,
                // )
              ],
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemCount: listFiles.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return VideoItemWidget(file: listFiles[index]);
                    }),
              ),
            ),

            // Expanded(
            //     child: ListView.builder(
            //         scrollDirection: Axis.vertical,
            //         itemCount: file.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           return
            //          Text('${file[index]}',style: TextStyle(color: Colors.white,fontSize: 20),);
            //         }))

            // for (var i = 0; i < file.length; i++)
            //   Column(
            //     children: [
            //       //buildThumbNail(),

            //       Text(
            //         file[i].path,
            //         style: TextStyle(color: Colors.white, fontSize: 20),
            //       )
            //     ],
            //   )

            // buildThumbNail(),
          ],
        ),
      ),
    );
  }
}

class VideoItemWidget extends StatefulWidget {
  const VideoItemWidget({Key? key, this.file}) : super(key: key);

  final io.FileSystemEntity? file;

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  Uint8List? thumbnailBytes;

  Future generateThumbnail() async {
      final thumbnailBytes = await VideoCompress.getByteThumbnail(
          widget.file!.path);
      setState(() {
        this.thumbnailBytes = thumbnailBytes;
      });
  }
 io.File? videofile;
  int? videoSize;

  _initPlayer() {
    final file = io.File(widget.file!.path);
    setState(() {
      videofile = file;
    });
   
    getVideoSize(videofile!);
  }

 

  Future getVideoSize(io.File file) async {
    final vsize = await file.length();
    setState(() {
      videoSize = vsize;
    });
    print(videoSize);
  }



  Widget buildVideoSize() {
    if (videoSize == null) return Container();
    final size = videoSize! / 1000;
   final sizee = size/1024; 
 var mb=sizee.toStringAsFixed(1);
    return Text(
      "$mb MB",
      // "3,6MB",
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
    );
  }
  @override
  void initState() {
    super.initState();
    generateThumbnail();
    _initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: thumbnailBytes == null ? Center(child: CircularProgressIndicator(),) : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(thumbnailBytes!),
                  // image: AssetImage("assets/images/image.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.6),
                    Colors.black.withOpacity(.1),
                    Colors.black.withOpacity(0),
                  ],
                  stops: [0, .3, 1],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 5,
          bottom: 10,
           child:
           buildVideoSize(),
          //  Text(
          //   "670 MB",
          //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          // ),
        )
      ],
    );
  }
}
