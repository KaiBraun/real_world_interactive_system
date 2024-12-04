import random
import pandas as pd

# Game setup
num_players = int(input("Enter the number of players (2-8): "))  # User chooses the number of players
columns = [
    'Player Throwing', 'Die 1', 'Die 2', 'Sum', 'Instruction 1', 'Instruction 2',
    'Rule 1', 'Rule 2', 'Rule 3', 'Commands', 'Rival Chosen', 'Counterattack Decision', 'Lore'
]
results_df = pd.DataFrame(columns=columns + [f'Player {i} Sips' for i in range(1, num_players + 1)])

# User assigns "Knights of 3"
print("You must now assign the 'Knights of 3'. These players will drink every time a 3 is rolled.")
knights_of_3 = []
while True:
    knight = int(input(f"Enter player number to be a Knight of 3 (1-{num_players}, or 0 to finish): "))
    if knight == 0:
        break
    elif knight not in knights_of_3 and 1 <= knight <= num_players:
        knights_of_3.append(knight)
    else:
        print("Invalid input. Try again.")
print(f"Knights of 3: {knights_of_3}")

current_player = 1
consecutive_throws = 0
rules = [""] * 3
sips = {player: 0 for player in range(1, num_players + 1)}
knight_sips = {player: 0 for player in range(1, num_players + 1)}  # Track Knight-only sips separately
king_intro_shown = False  # Tracks if the King explanation has been shown
elf_intro_shown = False  # Tracks if the House Elf explanation has been shown

# Functions
def roll_dice():
    """Roll two dice and return their values and sum."""
    die1, die2 = random.randint(1, 6), random.randint(1, 6)
    return die1, die2, die1 + die2

def handle_sips(sips, player, amount, reason):
    """Add sips to a player and return a message."""
    sips[player] += amount
    return f"Player {player} drinks {amount} sip(s) ({reason})"

def counterattack(current_player, rival, double_chain):
    """Handle the counterattack logic."""
    decisions = []
    while True:
        decision = input(f"Player {rival}, do you want to counterattack? (yes/no): ").strip().lower()
        decisions.append(decision)
        if decision == "yes":
            print(f"\nPlayer {rival}, it's your turn to counterattack. Press Enter to roll the dice.")
            input(">> Press Enter to roll... ")  # Prompt to roll dice
            rival_die1, rival_die2, _ = roll_dice()
            print(f"Player {rival} rolls: {rival_die1}, {rival_die2}")
            
            if rival_die1 == rival_die2:  # Rival rolls doubles
                print(f"Player {rival} rolls doubles! Counter continues.")
                double_chain += rival_die1
                current_player, rival = rival, current_player  # Switch roles
            else:  # Rival fails
                penalty = double_chain + min(rival_die1, rival_die2)
                message = f"Player {rival} failed the counterattack and drinks {penalty} sip(s)."
                print(message)
                sips[rival] += penalty
                return rival, penalty, "failed counterattack", decisions
        else:  # Rival refuses to counterattack
            message = f"Player {rival} refuses to counterattack and drinks {double_chain} sip(s)."
            print(message)
            sips[rival] += double_chain
            return rival, double_chain, "refusal to counterattack", decisions

# Game loop
for _ in range(100):
    print(f"\nPlayer {current_player}, it's your turn. Press Enter to roll the dice.")
    input(">> Press Enter to roll... ")  # Prompt to roll dice

    die1, die2, sum_dice = roll_dice()
    is_double = die1 == die2
    consecutive_throws += 1
    double_chain = die1 if is_double else 0
    instruction2 = ""
    command_message = ""
    rival_chosen = None
    counterattack_decisions = []

    print(f"Player {current_player} rolls: {die1}, {die2} (Sum: {sum_dice})")

    # Determine "Knights of 3" rule
    if 3 in [die1, die2]:
        instruction2 = "all knights drink"
        for knight in knights_of_3:
            sips[knight] += 1
            knight_sips[knight] += 1  # Track Knight-only sips separately
        knight_message = f"Knights of 3 ({', '.join(map(str, knights_of_3))}) drink 1 sip."
        print(knight_message)
        command_message += knight_message

    # Sipping rules
    if sum_dice == 7:
        previous_player = current_player - 1 if current_player > 1 else num_players
        message = handle_sips(sips, previous_player, 1, "rolled a 7")
        print(message)
        command_message += f" | {message}"
    elif sum_dice == 8:
        for player in range(1, num_players + 1):
            sips[player] += 1
        print("Everybody drinks 1 sip!")
        last_player = int(input("Who was the last to put their cup down? Enter player number: "))
        sips[last_player] += 1
        message = f"Player {last_player} drinks an additional sip for being last."
        print(message)
        command_message += f" | Everybody drinks 1 sip, {message}"
    elif sum_dice == 9:
        next_player = (current_player % num_players) + 1
        message = handle_sips(sips, next_player, 1, "rolled a 9")
        print(message)
        command_message += f" | {message}"
    elif is_double:
        rival_chosen = int(input(f"Player {current_player}, choose your rival (1-{num_players}): "))
        rival, penalty, reason, counterattack_decisions = counterattack(current_player, rival_chosen, double_chain)
        message = f"Player {rival} drinks {penalty} sip(s) due to {reason}."
        command_message += f" | {message}"

    # New rule creation
    if consecutive_throws == 3 and (sum_dice in [7, 8, 9, 11, 12] or is_double):
        input_new_rule = input(f"Player {current_player}, type your new rule: ")
        rules.pop(0)
        rules.append(f"Rule: {input_new_rule}")
        print(f"New rule added: {input_new_rule}")
        instruction1 = "pass the phone"
        consecutive_throws = 0
    else:
        if (sum_dice in [7, 8, 9, 11, 12] or is_double):
            instruction1 = "throw again"
        else:
            instruction1 = "pass the phone"
            consecutive_throws = 0

    # Determine "King of the Castle" and "House Elf"
    adjusted_sips = {player: sips[player] - knight_sips[player] for player in sips}  # Exclude Knight sips
    min_sips = min(adjusted_sips.values())
    max_sips = max(adjusted_sips.values())
    king_of_the_castle = [player for player, total_sips in adjusted_sips.items() if total_sips == min_sips]
    house_elf = [player for player, total_sips in adjusted_sips.items() if total_sips == max_sips]

    # Lore description
    lore_message = ""
    if len(king_of_the_castle) == 1:
        lore_message += f"Player {king_of_the_castle[0]} is the King of the Castle. Do not make eye contact!"
        if not king_intro_shown:
            lore_message += " The King of the Castle may not be looked in the eye. If you do, you must drink a sip as punishment."
            king_intro_shown = True
        print(lore_message)
    if len(house_elf) == 1:
        lore_message += f" Player {house_elf[0]} is the House Elf. Do not let them make eye contact!"
        if not elf_intro_shown:
            lore_message += " The House Elf may not look anyone in the eye. If he dares to do so, he must drink a sip as punishment."
            elf_intro_shown = True
        print(lore_message)

    # Record round data
    data = {
        'Player Throwing': current_player,
        'Die 1': die1,
        'Die 2': die2,
        'Sum': sum_dice,
        'Instruction 1': instruction1,
        'Instruction 2': instruction2,
        'Rule 1': rules[0],
        'Rule 2': rules[1],
        'Rule 3': rules[2],
        'Commands': command_message.strip(' |'),
        'Rival Chosen': rival_chosen,
        'Counterattack Decision': " -> ".join(counterattack_decisions) if counterattack_decisions else None,
        'Lore': lore_message
    }
    for i in range(1, num_players + 1):
        data[f'Player {i} Sips'] = sips[i]

    results_df = pd.concat([results_df, pd.DataFrame([data])], ignore_index=True)

    # Move to next player if phone is passed
    if instruction1 == "pass the phone":
        current_player = (current_player % num_players) + 1

# Display results
print("\nGame Log:")
print(results_df)