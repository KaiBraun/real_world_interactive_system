import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_app/application_logic/game_logic.dart';

import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

class RoleDiceView extends StatefulWidget {
  RoleDiceView({super.key, required this.players});

  final List<Player> players;

  @override
  State<RoleDiceView> createState() => _RoleDiceState();
}

class _RoleDiceState extends State<RoleDiceView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Random random = Random();
  int die1Value = 1;
  int die2Value = 1;
  int sum = 0;
  List<String> gameEvents = [];
  int currentPlayerIndex = 0;
  int consecutiveThrows = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          die1Value = random.nextInt(6) + 1;
          die2Value = random.nextInt(6) + 1;
          sum = die1Value + die2Value;

          String eventMessage = "${widget.players[currentPlayerIndex].name} rolled $die1Value and $die2Value (Sum: $sum).";

          // Check rules for retaining turn
          bool retainTurn = false;
          if (die1Value == die2Value) {
            eventMessage += " Rolled doubles, they play again!";
            retainTurn = true;
          } else if (sum == 7) {
            eventMessage += " Previous player drinks!";
            retainTurn = true;
          } else if (sum == 8) {
            eventMessage += " Everyone drinks!";
            retainTurn = true;
          } else if (sum == 9) {
            eventMessage += " Next player drinks!";
            retainTurn = true;
          }

          gameEvents.add(eventMessage);
          if (gameEvents.length > 10) {
            gameEvents.removeAt(0);
          }

          // Increment consecutive throws or reset
          if (retainTurn) {
            consecutiveThrows++;
          } else {
            consecutiveThrows = 0;
          }

          // Handle new rule creation if conditions are met
          if (consecutiveThrows == 3 && retainTurn) {
            int ruleSetterIndex = (currentPlayerIndex + 1 + widget.players.length) % widget.players.length;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController ruleController = TextEditingController();
                return AlertDialog(
                  title: Text("New Rule Opportunity"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${widget.players[ruleSetterIndex].name} has managed to roll 3 drink-makers in a row, so they can set a new rule that everyone should follow!"),
                      SizedBox(height: 10),
                      TextField(
                        controller: ruleController,
                        decoration: InputDecoration(
                          labelText: "Enter your rule",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        String newRule = ruleController.text.trim();
                        if (newRule.isNotEmpty) {
                          gameEvents.add("New Rule: $newRule");
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("Done"),
                    ),
                  ],
                );
              },
            );
          }

          // Pass turn if consecutive throws exceed 3 or retainTurn is false
          if (!retainTurn || consecutiveThrows >= 3) {
            currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
            consecutiveThrows = 0; // Reset for the next player
          }
        });
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Utils.getHeight(context) * 0.1),
            Text(
              "Current Player: ${widget.players[currentPlayerIndex].name}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Utils.getHeight(context) * 0.2),
            GestureDetector(
              onTap: () => _controller.forward(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value * 2 * pi,
                        child: Image.asset(
                          'assets/images/die_$die1Value.png',
                          height: 100,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 20),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value * 2 * pi,
                        child: Image.asset(
                          'assets/images/die_$die2Value.png',
                          height: 100,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Utils.getHeight(context) * 0.1),
            Expanded(
              child: ListView.builder(
                itemCount: gameEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      gameEvents[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
