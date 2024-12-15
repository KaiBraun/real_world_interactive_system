import 'dart:math';

List<int> rollDice() {
  // Roll two dice and return their values and sum as a list.
  final random = Random();
  int die1 = random.nextInt(6)+1; // Random value between 1 and 6
  int die2 = random.nextInt(6)+1;
  int sum = die1 + die2;

  return [die1, die2, sum];
}




