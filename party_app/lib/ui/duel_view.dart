import 'dart:math';
import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

class DuelView extends StatefulWidget {
  final Player currentPlayer; // The player who initiated the duel.
  final List<Player> players; // List of all players in the game.
  final Function(int penalty, Player loser) onDuelComplete; // Callback when the duel is over.
  final String die1Image; // Path to the image of the first die.
  final String die2Image; // Path to the image of the second die.
  final int triggeringValue; // The value of the dice pair that initiated the duel.

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
  late Player currentAttacker; // The player initiating the counterattack.
  late Player currentDefender; // The player deciding whether to counterattack.
  int doubleChain = 0; // Accumulated penalty from doubles.
  int penalty = 0; // Final penalty applied to the losing player.
  Random random = Random(); // Random number generator for dice rolls.
  bool isChoosingRival = true; // Whether the current phase is selecting the rival.
  bool isCounterattackPhase = false; // Whether it's the counterattack decision phase.
  String message = "Choose your rival for the duel!"; // Message displayed to the user.

  @override
  void initState() {
    super.initState();
    currentAttacker = widget.currentPlayer; // The initiator starts as the attacker.
  }

  // Rolls dice for a counterattack attempt.
  void rollDiceForCounterattack() {
    int die1 = random.nextInt(6) + 1; // Random number for die 1 (1 to 6).
    int die2 = random.nextInt(6) + 1; // Random number for die 2 (1 to 6).
    bool isDouble = die1 == die2; // Checks if the roll is a double.

    setState(() {
      if (isDouble) {
        // If doubles are rolled, add the die value to the penalty chain.
        doubleChain += die1;

        // Swap roles: current defender becomes attacker, attacker becomes defender.
        Player temp = currentAttacker;
        currentAttacker = currentDefender;
        currentDefender = temp;

        // Return to counterattack decision phase for the new defender.
        isCounterattackPhase = true;
        message =
        "${currentDefender.name}, doubles rolled! Do you accept your fate or counterattack? (Current penalty: $doubleChain sips)";
      } else {
        // If doubles are not rolled, calculate the penalty.
        penalty = doubleChain + min(die1, die2); // Add smallest die value to the chain.
        message =
        "${currentDefender.name} failed to roll doubles! Penalty: $penalty sips.";
        endDuel();
      }
    });
  }

  // Called when the defender accepts the penalty and does not counterattack.
  void acceptFate() {
    setState(() {
      // Apply the accumulated penalty (or initial value if no doubles).
      penalty = doubleChain > 0 ? doubleChain : widget.triggeringValue;
      message = "${currentDefender.name} accepts their fate! Penalty: $penalty sips.";
      endDuel();
    });
  }

  // Ends the duel and notifies the parent widget.
  void endDuel() {
    Future.delayed(Duration(seconds: 2), () {
      widget.onDuelComplete(penalty, currentDefender); // Notify about the result.
      Navigator.pop(context); // Close the DuelView.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Red background to signify the intensity of a duel.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displays the current message to the players.
            Text(
              message,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Spacing between elements.

            // Displays the dice images.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.die1Image, height: 100), // First die image.
                SizedBox(width: 20), // Spacing between dice.
                Image.asset(widget.die2Image, height: 100), // Second die image.
              ],
            ),

            // If a rival is being chosen, show the list of players to choose from.
            if (isChoosingRival)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    Player player = widget.players[index];
                    if (player == widget.currentPlayer) return Container(); // Skip the current player.
                    return ListTile(
                      title: Text(
                        player.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          // Set the selected player as the rival.
                          currentDefender = player;
                          isChoosingRival = false;
                          isCounterattackPhase = true;
                          doubleChain = widget.triggeringValue; // Initialize penalty with triggering value.
                          message =
                          "${currentDefender.name}, do you accept your fate or counterattack? (Initial penalty: $doubleChain sips)";
                        });
                      },
                    );
                  },
                ),
              ),

            // If it's the counterattack phase, show the "Accept Fate" and "Counterattack" options.
            if (isCounterattackPhase)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: acceptFate,
                    child: Text("Accept Fate"),
                  ),
                  SizedBox(height: 10), // Spacing between buttons.

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        message = "${currentDefender.name}, roll the dice to defend your honor!";
                        isCounterattackPhase = false; // Move to the dice-rolling phase.
                      });
                    },
                    child: Text("Counterattack"),
                  ),
                ],
              ),

            // If the counterattack phase has started, allow the rival to tap and roll the dice.
            if (!isChoosingRival && !isCounterattackPhase)
              Column(
                children: [
                  GestureDetector(
                    onTap: rollDiceForCounterattack, // Handles the dice roll when tapped.
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/die_${random.nextInt(6) + 1}.png', height: 100),
                        SizedBox(width: 20), // Spacing between dice.
                        Image.asset('assets/images/die_${random.nextInt(6) + 1}.png', height: 100),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Spacing.

                  // Instruction to tap the dice.
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