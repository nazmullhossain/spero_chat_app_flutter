import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key,
  required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay=false;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  videoPlayerController=CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value) {
    videoPlayerController.setVolume(1);
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 16/9,
    child: Stack(
      children: [
     CachedVideoPlayer(videoPlayerController),
        
        Align(
            alignment: Alignment.center,
            child: IconButton(onPressed: (){
              if(isPlay){
                videoPlayerController.pause();
              }else{
                videoPlayerController.play();
              }
              setState(() {
                isPlay=!isPlay;
              });

            }, icon: Icon(isPlay? Icons.pause_circle:Icons.play_circle)))
      ],
    ),
    );
  }
}
