import 'dart:io' as io;

import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:better_video_player/screens/trim_video.dart';
import 'package:better_video_player/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class ChooseVideoForTrim extends StatefulWidget {
 

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
      final direct = io.Directory("/storage/emulated/0/VidComp/Trim");
      if(!(await direct.exists())){
        await direct.create(recursive: true);
      }
    directory = (await getExternalStorageDirectory())!.path;
    setState(() {
      listFiles = io.Directory("/storage/emulated/0/VidComp/Trim").listSync();
    });

    print(listFiles.toString());
  }
  
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15,top: 40),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TRIM",
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
          Expanded(child: SingleChildScrollView(child: Container(child: Column(
            children: [
               SizedBox(
                        height: 50,
                      ),
                Text(
              "Upload Your Video",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
             Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trim Videos",
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
                      ],
                    ),
            listFiles==null?Container(): Container(
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
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
            ],
          ),),))
          ],
        ),
      ),
    );
  }
}



class VideoItemWidget extends StatefulWidget {
  const VideoItemWidget({Key? key, required this.file}) : super(key: key);

  final io.FileSystemEntity file;

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  Uint8List? thumbnailBytes;

  Future generateThumbnail() async {
    final thumbnailBytes =
        await VideoCompress.getByteThumbnail(widget.file.path);
    setState(() {
      this.thumbnailBytes = thumbnailBytes;
    });
  }

  io.File? videofile;
  int? videoSize;

  _initPlayer() {
    final file = io.File(widget.file.path);
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
    final sizee = size / 1024;
    var mb = sizee.toStringAsFixed(1);
    return Text(
      "$mb MB",
      // "3,6MB",
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
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
          child: thumbnailBytes == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(thumbnailBytes!), fit: BoxFit.cover),
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
          child: buildVideoSize(),
        )
      ],
    );
  }
}
