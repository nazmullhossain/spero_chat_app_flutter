import 'package:flutter/material.dart';
import 'package:whatapp_clone/utils/color_utils.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({Key? key, required this.text, required this.onPress}) : super(key: key);
final VoidCallback onPress;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: tabColor,
          minimumSize: Size(double.infinity, 50)
        ) ,
        onPressed: onPress, child: Text(text,
    style: TextStyle(
      color: Colors.black,
    ),));
  }
}
