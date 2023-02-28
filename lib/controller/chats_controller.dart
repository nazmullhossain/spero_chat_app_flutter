import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/enums/message_enum.dart';

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
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!));

    print("chat controler");

  }


  void sendFileMessage(
      BuildContext context,
      File file,
      String reciverUserId,
      MessageEnum messageEnum
      ){
ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendFileMessage(
    context: context,
    file: file,
    reciverUserId: reciverUserId,
    senderUserData: value!,
    ref: ref,
    messageEnum: messageEnum));
  }
}
