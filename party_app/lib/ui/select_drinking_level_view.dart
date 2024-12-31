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
        child: Column(
          children: [
            SizedBox(height: Utils.getHeight(context) * 0.1),
            Text(
              'Select Knights of 3',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lemon',
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.currentPlayers.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildPlayerCard(widget.currentPlayers[index]);
                },
              ),
            ),
            buildNextAndBackButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerCard(Player player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(player.name),
        Row(
          children: [
            Text("Knight of 3"),
            Checkbox(
              value: player.isKnightOf3,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    player.isKnightOf3 = value;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildNextAndBackButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Back"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoleDiceView(players: widget.currentPlayers),
            ),
          ),
          child: Text("Start Game"),
        ),
      ],
    );
  }
}
