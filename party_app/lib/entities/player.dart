class Player {
  Player({required this.name});

  String name;
  bool driver = false;
  DrinkingLevel drinkingLevel = DrinkingLevel.medium;
}

enum DrinkingLevel { low, medium, high, nuclear }
