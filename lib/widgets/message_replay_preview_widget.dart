import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/widgets/dislplay_test_image_widget.dart';

import '../provider/message_reply_provider.dart';

class MessageReplayPreviewWidget extends ConsumerWidget {
  const MessageReplayPreviewWidget({Key? key}) : super(key: key);


  void cancelReply(WidgetRef ref){
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final messageReply=ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12)
        )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(messageReply!.isMe? "Me":"opposite pe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),)),
              GestureDetector(
                onTap: (){
                  cancelReply(ref);
                },
                child: Icon(Icons.close,size: 16,),
              )
            ],
          ),
          SizedBox(height: 8,),
        DisplayImageWidget(type: messageReply.messageEnum,
            message: messageReply.message)
        ],
      ),
    );
  }
}
