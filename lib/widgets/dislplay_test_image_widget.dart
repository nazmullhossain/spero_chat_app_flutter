import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import 'package:whatapp_clone/widgets/video_player_widget.dart';

class DisplayImageWidget extends StatelessWidget {
  const DisplayImageWidget(
      {Key? key, required this.type, required this.message})
      : super(key: key);
  final String message;
  final MessageEnum type;
  @override
  Widget build(BuildContext context) {
    bool isPlaying=false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(message)
        : type == MessageEnum.audio
            ? StatefulBuilder(

              builder: (context, setState) {
                return IconButton(
                    constraints: BoxConstraints(minHeight: 100),
                    onPressed: ()async {
                      if(isPlaying){
                        await audioPlayer.pause();
                        setState((){
                          isPlaying=false;
                        });
                      }else{
                        // await audioPlayer.play(UrlSource(message));
                        await audioPlayer.play(UrlSource(message));
                        setState((){
                          isPlaying=true;
                        });
                      }
                    },
                    icon: Icon(isPlaying?Icons.pause_circle: Icons.play_circle));
              }
            )
            : type == MessageEnum.video
                ? VideoPlayerWidget(
                    videoUrl: message,
                  )
                : CachedNetworkImage(
                    imageUrl: message,
                  );
  }
}
