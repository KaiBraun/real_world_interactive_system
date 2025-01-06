import 'package:flutter/material.dart';
import 'package:party_app/shared/constants.dart';
import 'package:party_app/shared/utils.dart';
import 'package:party_app/ui/role_dice.dart';

import '../entities/player.dart';

class SelectDrinkingLevelView extends StatefulWidget {
  final List<Player> currentPlayers;

  SelectDrinkingLevelView({required this.currentPlayers});

  @override
  _SelectDrinkingLevelState createState() => _SelectDrinkingLevelState();
}

class _SelectDrinkingLevelState extends State<SelectDrinkingLevelView> {
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
            // Updated title section
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select the',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lemon',
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Knights of 3',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lemon',
                              color: Colors.black,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Transform.translate(
                        offset: Offset(0, -5), // Shift the image 10 pixels upward
                        child: Image.asset(
                          'assets/images/insertplayers2.png', // Update with your desired image
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Smaller scrollable list section
            // Smaller scrollable list section
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: List.generate(
                      widget.currentPlayers.length,
                          (index) => buildPlayerCard(widget.currentPlayers[index]),
                    ),
                  ),
                ),
              ),
            ),
// Button section with adjusted spacing
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: buildNextAndBackButtons(context),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildPlayerCard(Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Character image and player's name
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(player.characterImage), // Displaying the character image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      player.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            // Option to select Knight of 3 status
            Row(
              children: [
                Text(
                  "Knight of 3",
                  style: TextStyle(fontSize: 18),
                ),
                Checkbox(
                  value: player.isKnightOf3,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        player.isKnightOf3 = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Next and Back buttons
  Widget buildNextAndBackButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center both buttons
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Back",
            style: TextStyle(
              fontFamily: 'SofadiOne',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 30), // Adjust spacing between buttons
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoleDiceView(players: widget.currentPlayers),
            ),
          ),
          child: Text(
            "Start Game",
            style: TextStyle(
              fontFamily: 'SofadiOne',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
