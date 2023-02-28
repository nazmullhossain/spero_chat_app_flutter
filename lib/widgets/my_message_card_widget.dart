import 'package:flutter/material.dart';
import '../enums/message_enum.dart';

import '../utils/color_utils.dart';
import 'dislplay_test_image_widget.dart';


class MyMessageCardWidget extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;

  const MyMessageCardWidget({Key? key,
    required this.message, required this.date,
  required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: type==MessageEnum.text? EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ):EdgeInsets.only(
            left: 5,
          top: 5,
          right: 5,
          bottom: 25
        ),
                child: DisplayImageWidget(
                  type: type,
                  message: message,)
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style:const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}