import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';
import 'package:whatapp_clone/pages/landing_page.dart';
import 'package:whatapp_clone/pages/mobile_chat_page.dart';
import 'package:whatapp_clone/pages/user_information_page.dart';
import 'package:whatapp_clone/router.dart';
import 'package:whatapp_clone/utils/color_utils.dart';
import 'package:whatapp_clone/widgets/loader_widgets.dart';

import 'layout/mobile_layout.dart';
import 'layout/responsive_layout.dart';
import 'layout/web_layout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Whatapp",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          color: appBarColor
        )
      ),
      onGenerateRoute: (settings)=> generateRoute(settings),
      // home: MobileLayout(),
      home: ref.watch(userDataAuthProvider).when(data: (user){
        if(user==null){
          return LadingPage();
        }
        return MobileLayout();
      }, error: (err, trace){
        return ErrorWidget( err.toString());
      }, loading: ()=>LoaderWidget())

      );

  }
}
