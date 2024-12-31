class Player {
  Player({required this.name});

  String name;
  bool driver = false;
  DrinkingLevel drinkingLevel = DrinkingLevel.medium; // This can be removed if not needed
  int numberOfSips = 0;
  bool isKnightOf3 = false; // New field to track if the player is a Knight of 3
}


enum DrinkingLevel { low, medium, high, nuclear }
