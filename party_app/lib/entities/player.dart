class Player {
  Player({required this.name, required this.characterImage});  // Add characterImage to constructor

  String name;
  bool driver = false;
  DrinkingLevel drinkingLevel = DrinkingLevel.medium;
  int numberOfSips = 0;
  bool isKnightOf3 = false;
  bool isDrinkingMost = false;
  bool isDrinkingLeast = false;
  String characterImage;  // New field for the character image
}

enum DrinkingLevel { low, medium, high, nuclear }
