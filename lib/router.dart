import 'package:flutter/material.dart';
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
final arguments=settings.arguments as Map<String,dynamic>;
final name=arguments['name'];
final uid=arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatPage(
          name: name,
          uid: uid,
        ),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
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
