import 'package:flutter/material.dart';

class backButton extends StatelessWidget {
  const backButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.all(10.0),
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}
