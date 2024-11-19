import 'package:flutter/material.dart';

import '../shared/utils.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Theme.of(context).colorScheme.primary,
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Test123423412",style: TextStyle(color: Colors.black12),),
            ElevatedButton(
                onPressed: () => {

                },
                child: Text("Start new game")
            )
          ],
        ),
      )

    );
  }
}

