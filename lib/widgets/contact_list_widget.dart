import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatapp_clone/controller/chats_controller.dart';
import 'package:whatapp_clone/models/chat_contact_models.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';

import '../pages/mobile_chat_page.dart';
import '../utils/color_utils.dart';
import 'info_widget.dart';


class ContactsListWidget extends ConsumerWidget {
  const ContactsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return LoaderWidget();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {

             var chatContactData= snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
              Navigator.pushNamed(context, MobileChatPage.routeName,
              arguments:{
                'name':chatContactData.name,
                "uid": chatContactData.contactId
              });

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          chatContactData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                           chatContactData.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                          chatContactData.profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactData.timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      ),
    );
  }
}