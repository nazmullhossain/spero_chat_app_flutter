import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatapp_clone/controller/auth_controller.dart';
import 'package:whatapp_clone/utils/color_utils.dart';
import 'package:whatapp_clone/utils/utils_utils.dart';

import '../widgets/custom_button_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = "/login";
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }


  void sendPhoneNumber(){
    String phoneNumber=_phoneNumberController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authContorllerProvider).signInWithPhone( context,'+${country!.phoneCode} $phoneNumber' );
    }
    showSnackBar(context: context, content: "Please wait a few secconds");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your Phone number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("WhatApp will need to verify your phone number"),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: const Text("Pick country")),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (country != null) Text("+ ${country!.phoneCode}"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(


                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.10,
            ),
            SizedBox(
              width: 90,
              child: CustomButtonWidget(
                text: 'Next',
                onPress: () {
                  sendPhoneNumber();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
