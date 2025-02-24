import 'dart:io';

class Member {
  int id;
  String name;
  double totalContributed;
  double totalReceived;

  // Constructor
  Member(this.id, this.name) : totalContributed = 0.0, totalReceived = 0.0;
}

class CommitteeManagementSystem {
  List<Member> members = [];
  double fixedContribution;
  int currentMemberIndex = 0;

  CommitteeManagementSystem(this.fixedContribution);

  // Add a new member to the committee
  void addMember() {
    stdout.write("Enter member name: ");
    String? name = stdin.readLineSync()?.trim();

    if (name == null || name.isEmpty) {
      print("Invalid name. Please try again.\n");
      return;
    }

    int id = members.length + 1;
    members.add(Member(id, name));
    print("Member added successfully with ID $id.\n");
  }

  // View all members
  void viewMembers() {
    if (members.isEmpty) {
      print("No members in the committee.\n");
      return;
    }
    print("\nMembers in the Committee:");
    for (var member in members) {
      print(
        "ID: ${member.id}, Name: ${member.name}, "
        "Total Contributed: \$${member.totalContributed.toStringAsFixed(2)}, "
        "Total Received: \$${member.totalReceived.toStringAsFixed(2)}",
      );
    }
  }

  // Collect contributions for the month from all members
  void collectContributions() {
    if (members.isEmpty) {
      print("No members to collect contributions from.\n");
      return;
    }
    for (var member in members) {
      member.totalContributed += fixedContribution;
      print(
        "Member ${member.name} contributed \$${fixedContribution.toStringAsFixed(2)} units.",
      );
    }
  }

  // Distribute collected funds to one member, cyclically
  void distributeFunds() {
    if (members.isEmpty) {
      print("No members to distribute funds to.\n");
      return;
    }
    double totalFunds = fixedContribution * members.length;
    Member recipient = members[currentMemberIndex];
    recipient.totalReceived += totalFunds;
    print(
      "Funds of \$${totalFunds.toStringAsFixed(2)} units distributed to ${recipient.name} (ID: ${recipient.id}).\n",
    );
    currentMemberIndex = (currentMemberIndex + 1) % members.length;
  }

  // Menu to interact with the system
  void menu() {
    while (true) {
      print("\n--- Committee Management System ---");
      print("1. Add Member");
      print("2. View Members");
      print("3. Collect Contributions");
      print("4. Distribute Funds");
      print("5. Exit");
      stdout.write("Enter your choice: ");

      String? input = stdin.readLineSync();
      int? choice = int.tryParse(input ?? '');

      if (choice == null) {
        print("Invalid input. Please enter a number.\n");
        continue;
      }

      switch (choice) {
        case 1:
          addMember();
          break;
        case 2:
          viewMembers();
          break;
        case 3:
          collectContributions();
          break;
        case 4:
          distributeFunds();
          break;
        case 5:
          print("Exiting system.");
          return;
        default:
          print("Invalid choice. Please try again.\n");
      }
    }
  }
}

void main() {
  stdout.write("Enter fixed monthly contribution amount for each member: ");
  String? input = stdin.readLineSync();
  double? fixedContribution = double.tryParse(input ?? '');

  if (fixedContribution == null || fixedContribution <= 0) {
    print(
      "Invalid input. Contribution amount must be a positive number. Exiting program.",
    );
    return;
  }

  CommitteeManagementSystem cms = CommitteeManagementSystem(fixedContribution);
  cms.menu();
}
