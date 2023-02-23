import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';

import '../utils/color_utils.dart';

class OTPPage extends ConsumerWidget {
   OTPPage({Key? key,required this.verificationId}) : super(key: key);
  final String  verificationId;
static const routeName="/otp";


  void verifyOTP(WidgetRef ref,BuildContext context,String userOtp){
    ref.read(authContorllerProvider).verifyOTP(context, verificationId, userOtp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifying your number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text("We have send an sms "),
            SizedBox(
              height: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "------", hintStyle: TextStyle(fontSize: 30)),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if(val.length==6){
                   verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
