import 'dart:math';
import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

class DuelView extends StatefulWidget {
  final Player currentPlayer;
  final List<Player> players;
  final Function(int penalty, Player loser) onDuelComplete;
  final String die1Image; // Path to die1 image
  final String die2Image; // Path to die2 image
  final int triggeringValue; // The value forming the pair triggering the duel

  const DuelView({
    super.key,
    required this.currentPlayer,
    required this.players,
    required this.onDuelComplete,
    required this.die1Image,
    required this.die2Image,
    required this.triggeringValue,
  });

  @override
  State<DuelView> createState() => _DuelViewState();
}

class _DuelViewState extends State<DuelView> {
  late Player rival;
  int penalty = 0;
  int doubleChain = 0; // Accumulated penalty from doubles
  Random random = Random();
  bool isChoosingRival = true;
  bool isCounterattackPhase = false;
  String message = "Choose your rival for the duel!";

  void rollDiceForCounterattack() {
    int die1 = random.nextInt(6) + 1;
    int die2 = random.nextInt(6) + 1;
    bool isDouble = die1 == die2;

    setState(() {
      if (isDouble) {
        doubleChain += die1; // Accumulate penalty from the double value.
        message = "Doubles rolled! ${rival.name}, decide your fate again! (Current penalty: $doubleChain sips)";
      } else {
        penalty = doubleChain + min(die1, die2); // Add smallest die value to penalty.
        message = "${rival.name} failed to roll doubles! Penalty: $penalty sips.";
        endDuel();
      }
    });
  }

  void acceptFate() {
    setState(() {
      penalty = doubleChain > 0 ? doubleChain : widget.triggeringValue; // Apply initial penalty or accumulated value.
      message = "${rival.name} accepts their fate! Penalty: $penalty sips.";
      endDuel();
    });
  }

  void endDuel() {
    Future.delayed(Duration(seconds: 2), () {
      widget.onDuelComplete(penalty, rival);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.die1Image, height: 100), // Display die1 image
                SizedBox(width: 20),
                Image.asset(widget.die2Image, height: 100), // Display die2 image
              ],
            ),
            if (isChoosingRival)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    Player player = widget.players[index];
                    if (player == widget.currentPlayer) return Container(); // Skip current player.
                    return ListTile(
                      title: Text(
                        player.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          rival = player;
                          isChoosingRival = false;
                          isCounterattackPhase = true;
                          doubleChain = widget.triggeringValue; // Set initial penalty to the triggering value.
                          message = "${rival.name}, do you accept your fate or counterattack? (Initial penalty: $doubleChain sips)";
                        });
                      },
                    );
                  },
                ),
              ),
            if (isCounterattackPhase)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: acceptFate,
                    child: Text("Accept Fate"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        message = "${rival.name}, roll the dice to defend your honor!";
                        isCounterattackPhase = false;
                      });
                    },
                    child: Text("Counterattack"),
                  ),
                ],
              ),
            if (!isChoosingRival && !isCounterattackPhase)
              Column(
                children: [
                  GestureDetector(
                    onTap: rollDiceForCounterattack,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/die_${random.nextInt(6) + 1}.png', height: 100),
                        SizedBox(width: 20),
                        Image.asset('assets/images/die_${random.nextInt(6) + 1}.png', height: 100),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tap the dice to roll!",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
