import 'dart:math';
import 'package:flutter/material.dart';
import '../application_logic/game_logic.dart';
import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';
import 'duel_view.dart';
import 'package:party_app/ui/rules_view.dart';

class RoleDiceView extends StatefulWidget {
  RoleDiceView({super.key, required this.players});

  final List<Player> players;

  @override
  State<RoleDiceView> createState() => _RoleDiceState();
}


class _RoleDiceState extends State<RoleDiceView>
    with SingleTickerProviderStateMixin {
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
          List<int> results = rollDice();
          die1Value = results[0];
          die2Value = results[1];
          sum = results[2];

          String eventMessage =
              "";

          if (die1Value == 3 || die2Value == 3) {
            List<Player> knights =
                widget.players.where((player) => player.isKnightOf3).toList();

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers the content of the Column
                    crossAxisAlignment: CrossAxisAlignment.center, // Centers the content horizontally
                    children: [
                      Text(
                        "Knights of 3",
                        textAlign: TextAlign.center, // Center the first part of the text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lemon',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/beers.png',
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10), // Space between the image and text
                          Text(
                            "DRINK!",
                            textAlign: TextAlign.center, // Center the second part of the text
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lemon',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10), // Space between the text and image
                          Image.asset(
                            'assets/images/beers.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  content: Text(
                    "You rolled a 3!",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );

            if (knights.isNotEmpty) {
              for (var knight in knights) {
                knight.numberOfSips++;
              }
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
                          "${loser.name} DRINK $penalty times!");
                      duelInProgress = false;
                      updateDrinkingStatus(); // Update roles after duel
                    });
                  },
                ),
              ),
            );
          } else if (sum == 7) {
            retainTurn = true;
            int previousPlayerIndex = (currentPlayerIndex == 0)
                ? widget.players.length - 1
                : currentPlayerIndex - 1;
            Player previousPlayer = widget.players[previousPlayerIndex];
            previousPlayer.numberOfSips++;
            eventMessage +=
                " ${previousPlayer.name}, DRINK! ";
            updateDrinkingStatus();
          } else if (sum == 8) {
            retainTurn = true;
            for (var player in widget.players) {
              player.numberOfSips++;
            }
            eventMessage += " Everyone DRINKS!";
            updateDrinkingStatus(); // Update roles after everyone drinks
          } else if (sum == 9) {
            retainTurn = true;
            int nextPlayerIndex =
                (currentPlayerIndex + 1) % widget.players.length;
            Player nextPlayer = widget.players[nextPlayerIndex];
            nextPlayer.numberOfSips++;
            eventMessage +=
                " ${nextPlayer.name}, DRINK!!";
            updateDrinkingStatus();
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers the content of the Row
                    children: [
                      Image.asset(
                        'assets/images/bell.png',
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "New rule!",
                        textAlign: TextAlign.center,  // Center the text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lemon',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'assets/images/bell.png',
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "${widget.players[ruleSetterIndex].name}, you made people drink three times in a row, make a new rule!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                          color: Colors.black,
                        ),
                      ),
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

            currentPlayerIndex =
                (currentPlayerIndex + 1) % widget.players.length;
            consecutiveThrows = 0;
          }

          if (!retainTurn || consecutiveThrows >= 3) {
            setState(() {
              gameEvents.clear();  // Clear the events list when switching players
              currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
              consecutiveThrows = 0;
            });
          }
        });
        _controller.reset();
      }
    });
  }

  void updateDrinkingStatus() {
    if (widget.players.isNotEmpty) {
      // Determine the highest and lowest number of sips
      int maxSips = widget.players.map((p) => p.numberOfSips).reduce((a, b) => a > b ? a : b);
      int minSips = widget.players.map((p) => p.numberOfSips).reduce((a, b) => a < b ? a : b);

      // Find players with the highest and lowest sips
      List<Player> mostDrunk = widget.players.where((p) => p.numberOfSips == maxSips).toList();
      List<Player> leastDrunk = widget.players.where((p) => p.numberOfSips == minSips).toList();

      // Assign roles based on the rules
      if (mostDrunk.length == 1) {
        kingOfTheCastle = mostDrunk.first.name; // Only one King of the Castle
      } else {
        kingOfTheCastle = ""; // No King of the Castle if there's a tie
      }

      if (leastDrunk.length == 1) {
        houseElf = leastDrunk.first.name; // Only one House Elf
      } else {
        houseElf = ""; // No House Elf if there's a tie
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        widget.players[currentPlayerIndex].characterImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  "${widget.players[currentPlayerIndex].name}",
                  style: TextStyle(
                    fontFamily: 'Lemon',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                ": Your Turn",
                style: TextStyle(
                  fontFamily: 'SofadiOne',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ]),
            Divider(
              thickness: 1,
              height: 20,
              indent: Utils.getWidth(context) * 0.1, // Left spacing
              endIndent: Utils.getWidth(context) * 0.1, // Right spacing
            ),
            SizedBox(height: Utils.getHeight(context) * 0.02),

            if (currentRules.isNotEmpty) ...[
              SizedBox(height: Utils.getHeight(context) * 0.01),
              Column(
                children: currentRules
                    .map((rule) => Text(
                          rule,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 80),

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
                          'assets/images/die_$die2Value.png',
                          height: 120,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Utils.getHeight(context) * 0.1),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.players.map((player) {
                bool isKingOfCastle = player.name == kingOfTheCastle;
                bool isHouseElf = player.name == houseElf;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display King's picture if the player is the King of the Castle
                    if (isKingOfCastle)
                      Padding(
                        padding: EdgeInsets.only(right: 14),  // Adjust this value to move it left or right
                        child: Image.asset(
                          'assets/images/kingofthecastle.png',  // Your King image path
                          height: 40,
                          width: 40,
                        ),
                      ),
                    // Display House Elf's picture if the player is the House Elf
                    if (isHouseElf)
                    Padding(
                    padding: EdgeInsets.only(right: 14),  // Adjust this value to move it left or right
                    child: Image.asset(
                    'assets/images/houseofelf.png',  // Your King image path
                    height: 40,
                    width: 40,
                    ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(player.characterImage),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${player.numberOfSips}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: gameEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),  // Adjust margins
                    child: Container(
                      padding: EdgeInsets.all(10),  // Adjust internal padding
                      decoration: BoxDecoration(
                        color: Colors.white,  // Background color for each event
                        borderRadius: BorderRadius.circular(8),  // Rounded corners for each event
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,  // Centers the Row horizontally
                        crossAxisAlignment: CrossAxisAlignment.center,  // Centers the Row vertically
                        children: [
                          Text(
                            gameEvents[index],
                            style: TextStyle(
                              fontSize: 14,  // Font size for the event text
                              fontWeight: FontWeight.bold,  // Bold text
                              fontFamily: 'Lemon',  // Change this to your desired font
                              color: Colors.black,  // Text color
                            ),
                          ),
                          SizedBox(width: 8),  // Optional: adds spacing between the text and image
                          Image.asset(
                            'assets/images/beers.png',  // Replace with your image path
                            width: 20,  // Adjust the size of the image
                            height: 20, // Adjust the size of the image
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Information_button(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget Information_button(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RulesView(), //
          ),
        );
      },
      child: Image.asset(
        'assets/images/information.png', // Replace with the path to your image
        height: 40,
        width: 40,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}




