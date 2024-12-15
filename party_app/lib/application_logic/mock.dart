
/**
import 'dart:io';
import 'dart:math';

void main() {
  // Game setup
  final Random random = Random();
  stdout.write("Enter the number of players (2-8): ");
  final int numPlayers = int.parse(stdin.readLineSync()!); // User decides number of players
  print('Number of players: $numPlayers');

  // Columns for the game log
  final List<String> columns = [
    'Player Throwing',
    'Die 1',
    'Die 2',
    'Sum',
    'Instruction 1',
    'Instruction 2',
    'Rule 1',
    'Rule 2',
    'Rule 3',
    'Commands',
    'Rival Chosen',
    'Counterattack Decision',
    'Lore'
  ];

  // Assign Knights of 3
  print("You must now assign the 'Knights of 3'. These players will drink every time a 3 is rolled.");
  final List<int> knightsOf3 = [];
  while (true) {
    stdout.write("Enter player number to be a Knight of 3 (1-$numPlayers, or 0 to finish): ");
    int knight = int.parse(stdin.readLineSync()!);
    if (knight == 0) break;
    if (!knightsOf3.contains(knight) && knight >= 1 && knight <= numPlayers) {
      knightsOf3.add(knight);
    } else {
      print("Invalid input. Try again.");
    }
  }
  print('Knights of 3: $knightsOf3');

  int currentPlayer = 1;
  int consecutiveThrows = 0;
  final List<String> rules = List.filled(3, '');
  final Map<int, int> sips = {for (var i = 1; i <= numPlayers; i++) i: 0};
  final Map<int, int> knightSips = {for (var i = 1; i <= numPlayers; i++) i: 0};
  bool kingIntroShown = false;
  bool elfIntroShown = false;

  // Dice rolling function
  List<int> rollDice() {
    int die1 = random.nextInt(6) + 1;
    int die2 = random.nextInt(6) + 1;
    return [die1, die2, die1 + die2];
  }

  // Handling sips
  String handleSips(Map<int, int> sips, int player, int amount, String reason) {
    sips[player] = (sips[player] ?? 0) + amount;
    return 'Player $player drinks $amount sip(s) ($reason)';
  }

  // Counterattack logic
  Map<String, dynamic> counterattack(int currentPlayer, int rival, int doubleChain) {
    List<String> decisions = [];
    while (true) {
      stdout.write("Player $rival, do you want to counterattack? (yes/no): ");
      String decision = stdin.readLineSync()!.toLowerCase();
      decisions.add(decision);
      if (decision == "yes") {
        print("Player $rival, press Enter to roll the dice for the counterattack.");
        stdin.readLineSync();
        final dice = rollDice();
        print("Player $rival rolls: ${dice[0]}, ${dice[1]}");
        if (dice[0] == dice[1]) {
          print("Player $rival rolls doubles! Counter continues.");
          doubleChain += dice[0];
          int temp = currentPlayer;
          currentPlayer = rival;
          rival = temp;
        } else {
          int penalty = doubleChain + min(dice[0], dice[1]);
          sips[rival] = (sips[rival] ?? 0) + penalty;
          return {'rival': rival, 'penalty': penalty, 'reason': 'failed counterattack', 'decisions': decisions};
        }
      } else {
        sips[rival] = (sips[rival] ?? 0) + doubleChain;
        return {'rival': rival, 'penalty': doubleChain, 'reason': 'refusal to counterattack', 'decisions': decisions};
      }
    }
  }

  // Game loop
  for (int round = 0; round < 100; round++) {
    print("\nPlayer $currentPlayer, press Enter to roll the dice.");
    stdin.readLineSync();

    final dice = rollDice();
    int die1 = dice[0];
    int die2 = dice[1];
    int sumDice = dice[2];
    bool isDouble = die1 == die2;
    consecutiveThrows++;
    int doubleChain = isDouble ? die1 : 0;
    String instruction1 = '';
    String instruction2 = '';
    String commandMessage = '';
    String loreMessage = '';
    int? rivalChosen;
    List<String> counterattackDecisions = [];

    // Knights of 3 rule
    if (die1 == 3 || die2 == 3) {
      instruction2 = 'all knights drink';
      for (var knight in knightsOf3) {
        sips[knight] = (sips[knight] ?? 0) + 1;
        knightSips[knight] = (knightSips[knight] ?? 0) + 1;
      }
      commandMessage += 'Knights of 3 ($knightsOf3) drink 1 sip. ';
    }

    // Sipping rules
    if (sumDice == 7) {
      int previousPlayer = currentPlayer > 1 ? currentPlayer - 1 : numPlayers;
      commandMessage += handleSips(sips, previousPlayer, 1, 'rolled a 7');
    } else if (sumDice == 8) {
      for (var player in sips.keys) {
        sips[player] = (sips[player] ?? 0) + 1;
      }
      stdout.write("Who was the last to put their cup down? Enter player number: ");
      int lastPlayer = int.parse(stdin.readLineSync()!);
      sips[lastPlayer] = (sips[lastPlayer] ?? 0) + 1;
      commandMessage += 'Everybody drinks 1 sip, Player $lastPlayer drinks an additional sip.';
    } else if (sumDice == 9) {
      int nextPlayer = currentPlayer % numPlayers + 1;
      commandMessage += handleSips(sips, nextPlayer, 1, 'rolled a 9');
    } else if (isDouble) {
      stdout.write("Player $currentPlayer, choose your rival (1-$numPlayers): ");
      rivalChosen = int.parse(stdin.readLineSync()!);
      var result = counterattack(currentPlayer, rivalChosen, doubleChain);
      commandMessage += 'Player ${result['rival']} drinks ${result['penalty']} sip(s) due to ${result['reason']}.';
      counterattackDecisions = result['decisions'];
    }

    // New rule creation
    if (consecutiveThrows == 3 && (sumDice == 7 || sumDice == 8 || sumDice == 9 || sumDice == 11 || sumDice == 12 || isDouble)) {
      stdout.write("Player $currentPlayer, type your new rule: ");
      String newRule = stdin.readLineSync()!;
      rules.removeAt(0);
      rules.add(newRule);
      commandMessage += 'New rule added: $newRule.';
      instruction1 = 'pass the phone';
      consecutiveThrows = 0;
    } else {
      instruction1 = (sumDice == 7 || sumDice == 8 || sumDice == 9 || sumDice == 11 || sumDice == 12 || isDouble) ? 'throw again' : 'pass the phone';
      if (instruction1 == 'pass the phone') consecutiveThrows = 0;
    }

    // Determine "King of the Castle" and "House Elf"
    var adjustedSips = Map.from(sips);
    for (var player in knightsOf3) {
      adjustedSips[player] = (adjustedSips[player] ?? 0) - (knightSips[player] ?? 0);
    }
    int minSips = adjustedSips.values.reduce(min);
    int maxSips = adjustedSips.values.reduce(max);
    var kingOfTheCastle = adjustedSips.entries.where((entry) => entry.value == minSips).map((entry) => entry.key).toList();
    var houseElf = adjustedSips.entries.where((entry) => entry.value == maxSips).map((entry) => entry.key).toList();

    // Lore description
    if (kingOfTheCastle.length == 1) {
      loreMessage += 'Player ${kingOfTheCastle.first} is the King of the Castle. Do not make eye contact!';
      if (!kingIntroShown) {
        loreMessage += ' The King of the Castle may not be looked in the eye. If you do, you must drink a sip.';
        kingIntroShown = true;
      }
    }
    if (houseElf.length == 1) {
      loreMessage += ' Player ${houseElf.first} is the House Elf. Do not let them make eye contact!';
      if (!elfIntroShown) {
        loreMessage += ' The House Elf may not look anyone in the eye. If they do, they must drink a sip.';
        elfIntroShown = true;
      }
    }

    // Print round data
    print('\nRound ${round + 1}');
    print('Player Throwing: $currentPlayer');
    print('Dice: $die1, $die2 (Sum: $sumDice)');
    print('Commands: $commandMessage');
    print('Lore: $loreMessage');
    print('Sips: $sips');

    // Move to next player if phone is passed
    if (instruction1 == 'pass the phone') {
      currentPlayer = currentPlayer % numPlayers + 1;
    }
  }

  // End of game
  print('\nGame Over!');
}
    **/