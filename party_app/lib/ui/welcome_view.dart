import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixed,

      ),
      body: Column(
        children: [
          Text("Test123423412",style: TextStyle(color: Colors.red),),
          ElevatedButton(
              onPressed: () => {

              },
              child: Text("New Player")
          )
        ],
      )

    );
  }
}

