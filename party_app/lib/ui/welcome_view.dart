import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../shared/utils.dart';
import 'add_players_view.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.primaryColor, // Yellow background
        height: Utils.getHeight(context),
        width: Utils.getWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Warning Text at the Top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Warning: This game may cause questionable life choices!",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 50),

            // Image Instead of Text
            Image.asset(
              'assets/images/logo.png',
              width: 250,
            ),

            SizedBox(height: 50),

            // Start Button
            ElevatedButton(
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
                    builder: (context) => AddPlayersView(),
                  ),
                );
              },
              child: Text(
                "Start",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 80),

            // Footer Text
            Text(
              "Life’s too short for boring parties!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}













