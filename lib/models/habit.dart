class Habit {
  int? id;
  String name;
  int streak;
  bool completedToday;
  DateTime? lastCompleted; // Tracks last completion date

  Habit({
    this.id,
    required this.name,
    this.streak = 0,
    this.completedToday = false,
    this.lastCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'streak': streak,
      'completedToday': completedToday ? 1 : 0,
      'lastCompleted': lastCompleted?.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      streak: map['streak'],
      completedToday: map['completedToday'] == 1,
      lastCompleted:
          map['lastCompleted'] != null
              ? DateTime.parse(map['lastCompleted'])
              : null,
    );
  }
}
