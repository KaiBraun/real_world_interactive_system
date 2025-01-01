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
            List<String> knightsNames = widget.players
                .where((player) => player.isKnightOf3)
                .map((player) => player.name)
                .toList();

            if (knightsNames.isNotEmpty) {
              eventMessage +=
              " Knights of 3: ${knightsNames.join(", ")}, commit to your vow and drink!";
            }
          }

          bool retainTurn = false;

          if (die1Value == die2Value) {
            eventMessage += " Doubles rolled! Initiating a duel.";
            gameEvents.add(eventMessage);

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
                      gameEvents.add(
                          "${loser.name} drinks $penalty times as a result of the duel!");
                    });
                  },
                ),
              ),
            );

            return;
          } else if (sum == 7) {
            int previousPlayerIndex =
            (currentPlayerIndex == 0) ? widget.players.length - 1 : currentPlayerIndex - 1;
            String previousPlayerName = widget.players[previousPlayerIndex].name;
            eventMessage +=
            " $previousPlayerName, you drink as you are the previous player!";
            retainTurn = true;
          } else if (sum == 8) {
            eventMessage += " Everyone drinks!";
            retainTurn = true;
          } else if (sum == 9) {
            int nextPlayerIndex =
                (currentPlayerIndex + 1) % widget.players.length;
            String nextPlayerName = widget.players[nextPlayerIndex].name;
            eventMessage +=
            " $nextPlayerName, you drink as you are the next player!";
            retainTurn = true;
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

          if (consecutiveThrows == 3 && retainTurn) {
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
                          gameEvents.add(
                              "New Rule by ${widget.players[ruleSetterIndex].name}: $newRule");
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

          if (!retainTurn || consecutiveThrows >= 3) {
            currentPlayerIndex =
                (currentPlayerIndex + 1) % widget.players.length;
            consecutiveThrows = 0;
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
          children: [
            SizedBox(height: Utils.getHeight(context) * 0.1),
            Text(
              "Current Player: ${widget.players[currentPlayerIndex].name}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Utils.getHeight(context) * 0.1),
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
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
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
