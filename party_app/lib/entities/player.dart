class Player {
  Player({required this.name});

  String name;
  bool driver = false;
  DrinkingLevel drinkingLevel = DrinkingLevel.medium;
  int numberOfSips = 0;
}

enum DrinkingLevel { low, medium, high, nuclear }
