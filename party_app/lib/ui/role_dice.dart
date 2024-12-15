import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../shared/utils.dart';

class RoleDiceView extends StatefulWidget {
  const RoleDiceView({super.key});

  @override
  State<RoleDiceView> createState() => _RoleDiceState();
}

class _RoleDiceState extends State<RoleDiceView> {
  Random random = Random();
  int currentImageIndex = 0;
  int counter = 1;
  List<String> images = [
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
            children: [
              Transform.rotate(
                angle: random.nextDouble() * 180,
                child: Image.asset(
                  images[currentImageIndex],
                  height: 100,
                ),
              ),
              const SizedBox(height: 60,),
              ElevatedButton(onPressed: () {
                Timer.periodic(const Duration(microseconds: 80), (timer) {
                  counter++;
                  setState(() {
                    currentImageIndex = random.nextInt(6);
                  });
                  if (counter >= 100) {
                    timer.cancel();
                    setState(() {
                      counter = 1;
                    });
                  }
                });
              }, child: Text("Roll"))
            ],
          ),
        ),
      ),
    );
  }

}