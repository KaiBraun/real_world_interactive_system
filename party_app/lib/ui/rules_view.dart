import 'package:flutter/material.dart';


class RulesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Rules"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Game Rules:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "1. The Knights of 3 have to drink everytime a player rolls the number 3",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "2. The House Elf is the player who has drunk less and bla bla bla...",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "3. The King of the castle is the player who has drunk more and...",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "4. Everytime someone rolls a total sum of 7, the previous player as to drink and the current player rolls the dice again.",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "5. Everytime someone rolls a total sum of 8, everyone has to drink and the current player rolls the dice again ",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "6. Everytime someone rolls a total sum of 9, the previous player as to drink and the current player rolls the dice again.",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "7. Everytime someone makes people drink three times in a row, a new rule for the game must be set by this player",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "8. Everytime that a player rolls double, a duel between two players is set.",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
