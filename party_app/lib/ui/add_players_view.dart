import 'dart:math';
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
  ScrollController _scrollController = ScrollController();

  // List of available character images in assets
  final List<String> characterImages = [
    'assets/images/Characters/Character1.png',
    'assets/images/Characters/Character2.png',
    'assets/images/Characters/Character3.png',
    'assets/images/Characters/Character4.png',
    'assets/images/Characters/Character5.png',
    'assets/images/Characters/Character6.png',
    'assets/images/Characters/Character7.png',
    'assets/images/Characters/Character8.png',
  ];

  // List to track used character images
  List<String> usedCharacterImages = [];

  // Function to pick a random character image and ensure no duplicates
  String getRandomCharacterImage() {
    final availableImages = characterImages
        .where((image) => !usedCharacterImages.contains(image))
        .toList();

    if (availableImages.isEmpty) {
      return ''; // No images left to assign
    }

    final random = Random();
    final selectedImage = availableImages[random.nextInt(availableImages.length)];
    usedCharacterImages.add(selectedImage); // Mark the image as used
    return selectedImage;
  }

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
                  // Title section
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
                            Transform.translate(
                              offset: Offset(0, -5),
                              child: Image.asset(
                                'assets/images/insertplayers2.png',
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Apply offset to the scrolling list
                  Transform.translate(
                    offset: Offset(0, -30), // Move the list up by 30 pixels
                    child: Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Container(
                        height: 400,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: widget.currentPlayers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Character image
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(widget.currentPlayers[index].characterImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      widget.currentPlayers[index].name,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // If less than 8 players, show the input field and add button
                  if (widget.currentPlayers.length < 8) buildAddPlayerButton(),
                  SizedBox(),
                  buildNextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
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
                // Add player with random character image
                String characterImage = getRandomCharacterImage();
                if (characterImage.isNotEmpty) {
                  widget.currentPlayers.add(
                    Player(
                      name: addPlayerController.text,
                      characterImage: characterImage,
                    ),
                  );
                  addPlayerController.clear(); // Clear the input field
                  // Scroll to the last added player
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget buildNextButton() {
    return Transform.translate(
      offset: Offset(0, 20),
      // Adjust the vertical position by 30 pixels
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ElevatedButton(
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
                  builder: (context) => SelectDrinkingLevelView(currentPlayers: widget.currentPlayers),
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
          ),
        ),
      ),
    );
  }
}
