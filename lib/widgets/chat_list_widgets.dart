


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import 'package:whatapp_clone/models/chat_contact_models.dart';
import 'package:whatapp_clone/models/message_models.dart';
import 'package:whatapp_clone/provider/message_reply_provider.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';
import 'package:whatapp_clone/widgets/sender_message_card_widget.dart';

import '../controller/chats_controller.dart';
import 'info_widget.dart';
import 'my_message_card_widget.dart';


class ChatListWidget extends ConsumerStatefulWidget  {
  const ChatListWidget({Key? key, required this.reciverUserId}) : super(key: key);
final String reciverUserId;

  @override
  ConsumerState<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends ConsumerState<ChatListWidget> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }
  
  
  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum

      ){
    ref.read(messageReplyProvider.notifier)
        .update((state) => MessageReply(isMe, message, messageEnum));
  }
  
  @override
  Widget build(BuildContext context,) {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).getChatStream(widget.reciverUserId),
      builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return LoaderWidget();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(
              messageController.position.maxScrollExtent
            );
          });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var messageData  = snapshot.data![index];
            var timeSent= DateFormat.Hm().format(messageData.timeSent);
            if (messageData.senderId==FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCardWidget(
                message: messageData.text,
                date: timeSent,
              type: messageData.type,
            repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,

onLeftSwipe: (){
                  onMessageSwipe(messageData.text, true,
                      messageData.type);
},

              );


            }
            return SenderMessageCardWidget(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: ()=>onMessageSwipe(
                  messageData.text,
                  false,
                  messageData.type),
              repliedText: messageData.repliedMessage,
            );
          },
        );
      }
    );
  }
}

