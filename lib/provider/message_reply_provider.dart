import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/message_enum.dart';

class MessageReply {
  final bool isMe;

  final String message;
  final MessageEnum messageEnum;


  MessageReply(this.isMe, this.message, this.messageEnum);
}
final messageReplyProvider=StateProvider<MessageReply?>((ref)=>null);