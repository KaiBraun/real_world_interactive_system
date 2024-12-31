import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_app/entities/player.dart';
import 'package:party_app/shared/constants.dart';
import 'package:party_app/shared/utils.dart';
import 'package:party_app/ui/select_drinking_level_view.dart';

class AddPlayersView extends StatefulWidget {
  List<Player> currentPlayers = [];

  @override
  _AddPlayersViewState createState() => _AddPlayersViewState();
}

class _AddPlayersViewState extends State<AddPlayersView> {
  TextEditingController addPlayerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              child: Column(
                children: [
                  SizedBox(height: Utils.getHeight(context) * 0.1),
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
                                  'Insert the',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lemon',
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  'players',
                                  style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lemon',
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/insertplayers2.png',
                                width: 65,
                                height: 65,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.currentPlayers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildPlayerCard(widget.currentPlayers[index]);
                    },
                  ),
                  buildAddPlayerButton(),
                  SizedBox(height: Utils.getHeight(context) * 0.1),
                  buildNextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlayerCard(Player player) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(player.name),
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
        )
      ],
    );
  }

  Widget buildAddPlayerButton() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: addPlayerController,
            decoration: InputDecoration(
              hintText: 'Enter player name',
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (addPlayerController.text.isNotEmpty) {
              setState(() {
                widget.currentPlayers.add(Player(name: addPlayerController.text));
                addPlayerController.clear(); // Clear the input field
              });
            }
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget buildNextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectDrinkingLevelView(
              currentPlayers: widget.currentPlayers,
            ),
          ),
        );
      },
      child: Text(
        "Next",
        style: TextStyle(
          fontFamily: 'SofadiOne',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
