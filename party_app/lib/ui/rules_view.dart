import 'package:flutter/material.dart';

class RulesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> rules = [
      "The Knights of 3 have to drink every time a player rolls the number 3!",
      "The House Elf is the player who has drunk the most. He cannot look anyone in the eye",
      "The King of the castle is the player who has drunk least no one is allowed to look him in the eyes",
      "Every time someone rolls a total sum of 7, the previous player has to drink, and the current player rolls the dice again.",
      "Every time someone rolls a total sum of 8, everyone has to drink, and the current player rolls the dice again.",
      "Every time someone rolls a total sum of 9, the previous player has to drink, and the current player rolls the dice again.",
      "Every time someone makes people drink three times in a row, a new rule for the game must be set by this player.",
      "Every time a player rolls double, a duel between two players is set.",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Game Rules",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lemon',
            color: Colors.red,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: rules.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\u2022', // Unicode for bullet point
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(width: 10), // Spacing between bullet and text
                  Expanded(
                    child: Text(
                      rules[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SofadiOne',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
