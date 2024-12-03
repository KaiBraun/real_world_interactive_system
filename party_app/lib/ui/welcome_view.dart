import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../shared/utils.dart';
import 'add_players_view.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Constants.primaryColor,
      height: Utils.getHeight(context),
      width: Utils.getWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Warning: This game may cause questionable life choices!"),
          ElevatedButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPlayersView())),
                  },
              child: Text("Start new game"))
        ],
      ),
    ));
  }
}
