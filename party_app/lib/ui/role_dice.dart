import 'dart:math';
import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';
import 'duel_view.dart';

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
  late int ruleSetterIndex;
  List<String> currentRules = [];
  bool duelInProgress = false;
  String kingOfTheCastle = "";
  String houseElf = "";

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

          String eventMessage =
              "${widget.players[currentPlayerIndex].name} rolled $die1Value and $die2Value (Sum: $sum).";

          if (die1Value == 3 || die2Value == 3) {
            List<Player> knights = widget.players
                .where((player) => player.isKnightOf3)
                .toList();

            if (knights.isNotEmpty) {
              for (var knight in knights) {
                knight.numberOfSips++;
              }
              eventMessage +=
              " Knights of 3 (${knights.map((knight) => knight.name).join(", ")}) drink!";
              updateDrinkingStatus(); // Update roles after Knights of 3 drink
            }
          }

          bool retainTurn = false;

          if (die1Value == die2Value) {
            retainTurn = true;
            eventMessage += " Doubles rolled! Initiating a duel.";
            gameEvents.add(eventMessage);
            duelInProgress = true;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DuelView(
                  currentPlayer: widget.players[currentPlayerIndex],
                  players: widget.players,
                  die1Image: 'assets/images/die_$die1Value.png',
                  die2Image: 'assets/images/die_$die2Value.png',
                  triggeringValue: die1Value,
                  onDuelComplete: (int penalty, Player loser) {
                    setState(() {
                      loser.numberOfSips += penalty;
                      gameEvents.add(
                          "${loser.name} drinks $penalty times as a result of the duel!");
                      duelInProgress = false;
                      updateDrinkingStatus(); // Update roles after duel
                    });
                  },
                ),
              ),
            );
          } else if (sum == 7) {
            retainTurn = true;
            int previousPlayerIndex =
            (currentPlayerIndex == 0) ? widget.players.length - 1 : currentPlayerIndex - 1;
            Player previousPlayer = widget.players[previousPlayerIndex];
            previousPlayer.numberOfSips++;
            eventMessage +=
            " ${previousPlayer.name}, you drink as you are the previous player!";
            updateDrinkingStatus(); // Update roles after previous player drinks
          } else if (sum == 8) {
            retainTurn = true;
            for (var player in widget.players) {
              player.numberOfSips++;
            }
            eventMessage += " Everyone drinks!";
            updateDrinkingStatus(); // Update roles after everyone drinks
          } else if (sum == 9) {
            retainTurn = true;
            int nextPlayerIndex =
                (currentPlayerIndex + 1) % widget.players.length;
            Player nextPlayer = widget.players[nextPlayerIndex];
            nextPlayer.numberOfSips++;
            eventMessage +=
            " ${nextPlayer.name}, you drink as you are the next player!";
            updateDrinkingStatus(); // Update roles after next player drinks
          }

          gameEvents.add(eventMessage);
          if (gameEvents.length > 10) {
            gameEvents.removeAt(0);
          }

          if (retainTurn) {
            consecutiveThrows++;
          } else {
            consecutiveThrows = 0;
          }

          if (consecutiveThrows == 3) {
            ruleSetterIndex = currentPlayerIndex;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController ruleController = TextEditingController();
                return AlertDialog(
                  title: Text("New Rule Opportunity"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "${widget.players[ruleSetterIndex].name} has rolled 3 drink-makers in a row and can set a new rule!"),
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
                          setState(() {
                            if (currentRules.length >= 3) {
                              currentRules.removeAt(0);
                            }
                            currentRules.add(newRule);
                            gameEvents.add(
                                "New Rule by ${widget.players[ruleSetterIndex].name}: $newRule");
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("Done"),
                    ),
                  ],
                );
              },
            );

            currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
            consecutiveThrows = 0;
          }

          if (!retainTurn || consecutiveThrows >= 3) {
            currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
            consecutiveThrows = 0;
          }
        });
        _controller.reset();
      }
    });
  }

  void updateDrinkingStatus() {
    if (widget.players.isNotEmpty) {
      int maxSips = widget.players.map((p) => p.numberOfSips).reduce((a, b) => a > b ? a : b);
      int minSips = widget.players.map((p) => p.numberOfSips).reduce((a, b) => a < b ? a : b);

      List<Player> mostDrunk = widget.players.where((p) => p.numberOfSips == maxSips).toList();
      List<Player> leastDrunk = widget.players.where((p) => p.numberOfSips == minSips).toList();

      if (mostDrunk.length == 1) {
        houseElf = mostDrunk.first.name;
      } else {
        houseElf = "";
      }

      if (leastDrunk.length == 1) {
        kingOfTheCastle = leastDrunk.first.name;
      } else {
        kingOfTheCastle = "";
      }
    }
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
            SizedBox(height: Utils.getHeight(context) * 0.02),
            Text(
              widget.players
                  .map((player) => "${player.name}: ${player.numberOfSips} sips${player.name == kingOfTheCastle ? " (King of the Castle)" : player.name == houseElf ? " (House Elf)" : ""}")
                  .join(" | "),
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (currentRules.isNotEmpty) ...[
              SizedBox(height: Utils.getHeight(context) * 0.01),
              Column(
                children: currentRules.map((rule) => Text(
                  rule,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                )).toList(),
              ),
            ],
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
