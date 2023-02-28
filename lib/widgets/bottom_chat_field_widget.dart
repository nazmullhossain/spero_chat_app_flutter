import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import '../controller/chats_controller.dart';

import '../utils/color_utils.dart';
import '../utils/utils_utils.dart';

class BottomChatFieldWidget extends ConsumerStatefulWidget {
  const BottomChatFieldWidget({Key? key, required this.recieverUserId})
      : super(key: key);
  final String recieverUserId;
  @override
  ConsumerState<BottomChatFieldWidget> createState() =>
      _BottomChatFieldWidgetState();
}

class _BottomChatFieldWidgetState extends ConsumerState<BottomChatFieldWidget> {
  final TextEditingController _messageController = TextEditingController();

  bool isShowSendButton = false;
  // void sendTextMessage()async{
  //   if (isShowSendButton) {
  //     ref.read(chatControllerProvider).sendTextMessage(
  //       context,
  //       _messageController.text.trim(),
  //       widget.recieverUserId,
  //
  //
  //     );
  //
  //     setState(() {
  //       _messageController.text = '';
  //     });
  //   }
  // }
  //

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }
  
  void sendFileMesssge(File file,
      MessageEnum messageEnum,
      ){
    ref.read(chatControllerProvider).sendFileMessage(context,
        file, widget.recieverUserId,
        messageEnum);
  }

  void selectImage()async{
    File?image=await pickImageFromGallery(context);

    if(image!=null){
sendFileMesssge(image, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
          child: CircleAvatar(
            backgroundColor: Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onTap: sendTextMessage,
            ),
          ),
        )
      ],
    );
  }
}
