class Player {
  Player({required this.name});

  String name;
  bool driver = false;
  DrinkingLevel drinkingLevel = DrinkingLevel.medium; // This can be removed if not needed
  int numberOfSips = 0;
  bool isKnightOf3 = false; // New field to track if the player is a Knight of 3
  bool isDrinkingMost = false; // Tracks if the player is drinking the most
  bool isDrinkingLeast = false; // Tracks if the player is drinking the least
}

enum DrinkingLevel { low, medium, high, nuclear }
