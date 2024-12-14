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
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: Utils.getWidth(context) * 0.8,
            child: Column(
              children: [
                SizedBox(height: Utils.getHeight(context) * 0.1),
                Container(
                  height: Utils.getHeight(context) * 0.15,
                  color: Constants.accentColor2,
                  child: Text("Insert the players"),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.currentPlayers.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container();
                        }
                        return buildPlayerCard(widget.currentPlayers[index]);
                      }),
                ),
                buildAddPlayerButton(),
                SizedBox(height: Utils.getHeight(context) * 0.1),
                buildNextButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlayerCard(Player player) {
    //Player testPlayer =  Player(name: "Test", driver: false);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person, // Replace with your desired icon
                color: Colors.white, // Icon color
                size: 50, // Icon size
              ),
            ),
            Text(player.name)
          ],
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () => {}, child: AutoSizeText("Designated Driver")),
            ElevatedButton(
                onPressed: () => {}, child: AutoSizeText("Normal Player"))
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
          //height: 0,
        )
      ],
    );
  }

  Widget buildAddPlayerButton() {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: addPlayerController,
        ),
      ),
      IconButton(
          onPressed: () => {
                if (addPlayerController.text.isNotEmpty)
                  {
                    setState(() {
                      widget.currentPlayers
                          .add(Player(name: addPlayerController.text));
                    })
                  }
              },
          icon: Icon(Icons.add))
    ]);
  }

  Widget buildNextButton() {
    return ElevatedButton(
        onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectDrinkingLevelView(
                          currentPlayers: widget.currentPlayers)))
            },
        child: AutoSizeText("Next"));
  }
}
