import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/enums/message_enum.dart';
import 'package:whatapp_clone/provider/message_reply_provider.dart';

import '../models/chat_contact_models.dart';
import '../models/message_models.dart';
import '../services/chat_repostory_services.dart';
import 'auth_controller.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>>chatContacts(){
    return chatRepository.getChatContacts();
  }


  Stream<List<Message>>getChatStream(String recevierUserId){
    return chatRepository.getChatStream(recevierUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    final messageReply=ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            messageReply:  messageReply,
            senderUser: value!));
    ref.read(messageReplyProvider.notifier).update((state) => null);
    print("chat controler");

  }


  void sendFileMessage(
      BuildContext context,
      File file,
      String reciverUserId,
      MessageEnum messageEnum
      ){
    final messageReply=ref.read(messageReplyProvider);
ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendFileMessage(
    context: context,
    file: file,
    messageReply:  messageReply,
    reciverUserId: reciverUserId,
    senderUserData: value!,
    ref: ref,
    messageEnum: messageEnum));
ref.read(messageReplyProvider.notifier).update((state) => null);
  }

// void sendGIFMessage(
//     BuildContext context,
//     String gifUrl,
//     String recieverUserId
//     ){
//     ref.read(userDataAuthProvider)
//         .whenData((value) => chatRepository.sendGIFMessage(
//         context: context,
//         gifUrl: gifUrl,
//         recieverUserId: recieverUserId,
//         senderUser: value!));
// }
//



}
