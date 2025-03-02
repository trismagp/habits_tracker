class Habit {
  int? id; // Null for new habits, set by database
  String name;
  int streak;
  bool completedToday;

  Habit({
    this.id,
    required this.name,
    this.streak = 0,
    this.completedToday = false,
  });

  // Convert Habit to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'streak': streak,
      'completedToday': completedToday ? 1 : 0, // SQLite uses 1/0 for bool
    };
  }

  // Create Habit from Map (from SQLite)
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      streak: map['streak'],
      completedToday: map['completedToday'] == 1,
    );
  }
}
