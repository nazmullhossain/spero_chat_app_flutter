import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import 'package:whatapp_clone/widgets/video_player_widget.dart';

class DisplayImageWidget extends StatelessWidget {
  const DisplayImageWidget({Key? key,
  required this.type,
  required this.message}) : super(key: key);
final String message;
final MessageEnum type;
  @override
  Widget build(BuildContext context) {
    return type==MessageEnum.text?Text(message):
        type==MessageEnum.video?VideoPlayerWidget(videoUrl: message,):
    CachedNetworkImage(
      imageUrl: message,
    );

  }
}
