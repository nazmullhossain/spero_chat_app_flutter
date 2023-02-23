import 'package:flutter/material.dart';

class ErrorWidgets extends StatelessWidget {
  const ErrorWidgets({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
