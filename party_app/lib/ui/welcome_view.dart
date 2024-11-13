import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixed,
      ),
      body:  Text("Test",style: TextStyle(color: Colors.red),),
    );
  }
}