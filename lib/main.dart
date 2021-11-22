
import 'package:better_video_player/screens/uploadvideo.dart';
import 'package:better_video_player/screens/uploadvideo_for_trim.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
         unselectedWidgetColor:Colors.grey[600],
      ),
      home:ChooseVideoForTrim()
    );
  }
}

