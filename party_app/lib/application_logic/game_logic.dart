import 'dart:math';

import 'package:flutter/material.dart';
import 'package:party_app/entities/player.dart';

List<int> rollDice() {
  // Roll two dice and return their values and sum as a list.
  final random = Random();
  int die1 = random.nextInt(6)+1; // Random value between 1 and 6
  int die2 = random.nextInt(6)+1;
  int sum = die1 + die2;

  return [die1, die2, sum];
}

class GameHandler {
  List<Player> players;

  GameHandler({required this.players});

  Future handleSips(int die1, int die2, BuildContext context) {
    List<String> instructions = [];


    Future? knights = handleKnights(die1, die2, context);
    if(knights != null) {
      return knights;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dice Roll Completed"),
          content: Text("Nothing happens"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

   Future? handleKnights(int die1, int die2, BuildContext context) {
    if (die1 == 3 || die2 == 3) {
      //for( Player player in players) {
      //  if(player.drinkingLevel == DrinkingLevel.nuclear) player.numberOfSips++;
      //}
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Dice Roll Completed"),
            content: Text("All knights drink"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
    return null;
  }
}




