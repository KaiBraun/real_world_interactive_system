import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_app/shared/constants.dart';
import 'package:party_app/shared/utils.dart';
import 'package:party_app/ui/role_dice.dart';

import '../entities/player.dart';

class SelectDrinkingLevelView extends StatefulWidget {
  final List<Player> currentPlayers;

  SelectDrinkingLevelView({required this.currentPlayers});

  @override
  _SelectDrinkingLevelState createState() => _SelectDrinkingLevelState();
}

class _SelectDrinkingLevelState extends State<SelectDrinkingLevelView> {
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
                Expanded(
                    child: ListView.builder(
                        itemCount: widget.currentPlayers.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Container();
                          }
                          return buildPlayerCard(widget.currentPlayers[index]);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(player.name),
        DropdownButton<DrinkingLevel>(
            value: player.drinkingLevel,
            items: DrinkingLevel.values.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level.name),
              );
            }).toList(),
            onChanged: (newLevel) {
              if (newLevel != null) {
                setState(() {
                  player.drinkingLevel = newLevel;
                });
              }
            }),
      ],
    );
  }

  Widget buildNextAndBackButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () => {Navigator.pop(context)},
            child: AutoSizeText("Back")),
        ElevatedButton(
            onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RoleDiceView()))
                },
            child: AutoSizeText("Start Game"))
      ],
    );
  }
}
