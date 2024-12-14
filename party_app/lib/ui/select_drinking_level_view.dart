import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_app/shared/constants.dart';
import 'package:party_app/shared/utils.dart';

import '../entities/player.dart';

class SelectDrinkingLevelView extends StatelessWidget {
  final List<Player> currentPlayers;

  SelectDrinkingLevelView({required this.currentPlayers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: Utils.getWidth(context) * 0.8,
            child: Column(
              children: [
                SizedBox(height: Utils.getHeight(context) * 0.1),
                Container(
                  height: Utils.getHeight(context) * 0.15,
                  color: Constants.accentColor2,
                  child: Text("Level of responsibility"),
                ),
                Expanded(child: ListView.builder(
                  itemCount: currentPlayers.length,
                    itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container();
                  }
                  return buildPlayerCard(currentPlayers[index]);
                })),
                buildNextAndBackButtons(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget buildPlayerCard(Player player) {
    //TODO: show player name and dropdown with drinking level
    return Text(player.name);
  }

  Widget buildNextAndBackButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () => {Navigator.pop(context)},
            child: AutoSizeText("Back")),
        ElevatedButton(onPressed: () => {}, child: AutoSizeText("Start Game"))
      ],
    );
  }
}
