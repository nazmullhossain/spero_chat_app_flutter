import 'package:flutter/material.dart';
import 'package:whatapp_clone/utils/color_utils.dart';

import '../widgets/custom_button_widgets.dart';
import 'login_pages.dart';

class LadingPage extends StatelessWidget {
  const LadingPage({Key? key}) : super(key: key);
void navigateToLoginScreen(BuildContext context){
  Navigator.pushNamed(context, LoginPage.routeName);
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome to WhatsApp",
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Image.asset(
              "assets/images/bg.png",
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(

                "Read our Privacy policy,Tap Agree and continue to \n accepte the terms of siervices",
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10,),

         SizedBox(
             width: size.width*0.75,
             child: CustomButtonWidget(text: "AGREE AND CONTINUE", onPress: (){
               navigateToLoginScreen(context);
             }))
          ],
        ),
      ),
    );
  }
}
