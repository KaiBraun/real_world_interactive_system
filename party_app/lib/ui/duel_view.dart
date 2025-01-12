import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../application_logic/game_logic.dart';
import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

class DuelView extends StatefulWidget {
  final Player currentPlayer; // The player who initiated the duel.
  final List<Player> players; // List of all players in the game.
  final Function(int penalty, Player loser)
      onDuelComplete; // Callback when the duel is over.
  final String die1Image; // Path to the image of the first die.
  final String die2Image; // Path to the image of the second die.
  final int
      triggeringValue; // The value of the dice pair that initiated the duel.

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

class _DuelViewState extends State<DuelView>
    with SingleTickerProviderStateMixin {
  late Player currentAttacker; // The player initiating the counterattack.
  late Player currentDefender; // The player deciding whether to counterattack.
  int doubleChain = 0; // Accumulated penalty from doubles.
  int penalty = 0; // Final penalty applied to the losing player.
  Random random = Random(); // Random number generator for dice rolls.
  bool isChoosingRival =
      true; // Whether the current phase is selecting the rival.
  bool isCounterattackPhase =
      false; // Whether it's the counterattack decision phase.
  String message =
      "Choose your rival for the duel!"; // Message displayed to the user.

  late AnimationController _controller;
  late CurvedAnimation _animation;
  int die1 = 1;
  int die2 = 1;

  @override
  void initState() {
    super.initState();
    currentAttacker = widget.currentPlayer;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    _controller.addListener(() {
      onCounterAttackDiceThrown();
    });
  }

  void onCounterAttackDiceThrown() {
    if (_controller.isCompleted) {
      setState(() {
        List<int> results = rollDice();

        die1 = results[0];
        die2 = results[1];
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (die1 == die2) {
            // If doubles are rolled, add the die value to the penalty chain.
            doubleChain += die1;

            // Swap roles: current defender becomes attacker, attacker becomes defender.
            Player temp = currentAttacker;
            currentAttacker = currentDefender;
            currentDefender = temp;

            // Return to counterattack decision phase for the new defender.
            isCounterattackPhase = true;
            message = "${currentAttacker.name} rolled doubles!!";
            _controller.reset();
          } else {
            // If doubles are not rolled, calculate the penalty.
            penalty = doubleChain +
                min(die1, die2); // Add smallest die value to the chain.
            message =
            "${currentDefender.name} failed to roll doubles! Penalty: $penalty sips.";
            endDuel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      // Red background to signify the intensity of a duel.
      body: Center(
        child: Column(
          children: [
            SizedBox(height: Utils.getHeight(context) * 0.1),
            AutoSizeText(
              message,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Spacing between elements.

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
            if (isChoosingRival) buildChooseRivalView(),

            // If it's the counterattack phase, show the "Accept Fate" and "Counterattack" options.
            if (isCounterattackPhase) buildChooseCounterattackView(),

            // If the counterattack phase has started, allow the rival to tap and roll the dice.
            if (!isChoosingRival && !isCounterattackPhase)
              buildCounterattackPhaseView(),
          ],
        ),
      ),
    );
  }

  Column buildCounterattackPhaseView() {
    return Column(
      children: [
        SizedBox(height: Utils.getHeight(context) * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(currentDefender.characterImage),
                  // Displaying the character image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Flexible(
                child: Text(
              currentDefender.name,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ))
          ],
        ),
        SizedBox(height: Utils.getHeight(context) * 0.05),
        GestureDetector(
          onTap: ()=>_controller.forward(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * pi,
                    child: Image.asset(
                      'assets/images/die_$die1.png',
                      height: 120,
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
                      'assets/images/die_$die2.png',
                      height: 120,
                    ),
                  );
                },
              ),
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
    );
  }

  Widget buildChooseCounterattackView() {
    return SizedBox(
      width: Utils.getWidth(context) * 0.8,
      child: Column(
        children: [
          SizedBox(height: Utils.getHeight(context) * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(currentDefender.characterImage),
                    // Displaying the character image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                  child: Text(
                currentDefender.name,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ))
            ],
          ),
          AutoSizeText(
            "Do you accept your fate or counterattack?",
            style: TextStyle(color: Colors.white),
            maxFontSize: 20,
          ),
          Text(
            "(Penalty: $doubleChain sips)",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: Utils.getHeight(context) * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: acceptFate,
                child: Text("Accept Fate"),
              ),
              SizedBox(height: 10), // Spacing between buttons.

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    message =
                        "${currentDefender.name}, roll the dice to defend your honor!";
                    isCounterattackPhase =
                        false; // Move to the dice-rolling phase.
                  });
                },
                child: Text("Counterattack"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildChooseRivalView() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.players.length,
        itemBuilder: (context, index) {
          Player player = widget.players[index];
          if (player == widget.currentPlayer) {
            return Container(); // Skip the current player.
          }
          return Padding(
            padding: EdgeInsets.all(5),
            child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    // Adjust the size of the avatar
                    backgroundImage: AssetImage(player.characterImage),
                    // Path to the player's image
                    backgroundColor: Colors
                        .transparent, // Optional: Set a transparent background
                  ),
                  title: Text(
                    player.name,
                  ),
                  onTap: () {
                    setState(() {
                      // Set the selected player as the rival.
                      currentDefender = player;
                      isChoosingRival = false;
                      isCounterattackPhase = true;
                      doubleChain = widget
                          .triggeringValue; // Initialize penalty with triggering value.
                      message = "What do you do?";
                    });
                  },
                )),
          );
        },
      ),
    );
  }

  // Called when the defender accepts the penalty and does not counterattack.
  void acceptFate() {
    setState(() {
      // Apply the accumulated penalty (or initial value if no doubles).
      penalty = doubleChain > 0 ? doubleChain : widget.triggeringValue;
      message =
          "${currentDefender.name} accepts their fate! Penalty: $penalty sips.";
      endDuel();
    });
  }

  // Ends the duel and notifies the parent widget.
  void endDuel() {
    Future.delayed(Duration(seconds: 2), () {
      widget.onDuelComplete(
          penalty, currentDefender); // Notify about the result.
      Navigator.pop(context); // Close the DuelView.
    });
  }
}
