import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party_app/application_logic/game_logic.dart';

import '../entities/player.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';

class RoleDiceView extends StatefulWidget {
  RoleDiceView({super.key, required this.players});

  List<Player> players;

  @override
  State<RoleDiceView> createState() => _RoleDiceState();
}

class _RoleDiceState extends State<RoleDiceView> {
  

  //attributes for dice
  Random random = Random();
  int die1Value = 1;
  int die2Value = 1;
  int sum = 0;
  int counter = 1;
  List<String> images = [
    'dummy',
    'assets/images/die_1.png',
    'assets/images/die_2.png',
    'assets/images/die_3.png',
    'assets/images/die_4.png',
    'assets/images/die_5.png',
    'assets/images/die_6.png',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  Timer.periodic(const Duration(microseconds: 80), (timer) {
                    counter++;
                    setState(() {
                      List<int> diceResult = rollDice();
                      die1Value = diceResult[0];
                      die2Value = diceResult[1];
                      sum = diceResult[2];
                    });
                    if (counter >= 500) {
                      timer.cancel();
                      setState(() {
                        counter = 1;
                      });
                    }
                  })
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: random.nextDouble() * 180,
                      child: Image.asset(
                        images[die1Value],
                        height: 100,
                      ),
                    ),
                    Transform.rotate(
                      angle: random.nextDouble() * 180,
                      child: Image.asset(
                        images[die2Value],
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
