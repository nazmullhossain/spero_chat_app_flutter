import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatapp_clone/pages/confirm_page.dart';
import 'package:whatapp_clone/pages/group_page.dart';
import 'package:whatapp_clone/pages/login_pages.dart';
import 'package:whatapp_clone/pages/mobile_chat_page.dart';
import 'package:whatapp_clone/pages/otp_pages.dart';
import 'package:whatapp_clone/pages/select_contact_pages.dart';
import 'package:whatapp_clone/pages/user_information_page.dart';
import 'package:whatapp_clone/widgets/error_widgets.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (context) => const LoginPage());

    case OTPPage.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPPage(
                verificationId: verificationId,
              ));

    case MobileChatPage.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatPage(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case ConfirmStatusPage.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusPage(
          file: file,
        ),
      );

    case GroupPage.routeName:
      return MaterialPageRoute(
        builder: (context) => GroupPage(),
      );

    case UserInformationPage.routeName:
      // final verificationId =settings.arguments as String;
      return MaterialPageRoute(builder: (context) => UserInformationPage());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorWidgets(
                  error: 'This Page does not exit',
                ),
              ));
  }
}
