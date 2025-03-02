import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'screens/add_habit_screen.dart';
import 'services/database_service.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final loadedHabits = await _dbService.getHabits();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var habit in loadedHabits) {
      // Reset completedToday if it's a new day
      final lastCompletedDay =
          habit.lastCompleted != null
              ? DateTime(
                habit.lastCompleted!.year,
                habit.lastCompleted!.month,
                habit.lastCompleted!.day,
              )
              : null;
      if (lastCompletedDay != today) {
        habit.completedToday = false;
        if (lastCompletedDay != null &&
            today.difference(lastCompletedDay).inDays > 1) {
          habit.streak = 0; // Reset streak if a day was missed
        }
      }
    }
    setState(() {
      habits = loadedHabits;
    });
  }

  void _addHabit(Habit newHabit) async {
    await _dbService.insertHabit(newHabit);
    _loadHabits();
  }

  void _toggleHabitCompletion(int index) async {
    final habit = habits[index];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCompletedDay =
        habit.lastCompleted != null
            ? DateTime(
              habit.lastCompleted!.year,
              habit.lastCompleted!.month,
              habit.lastCompleted!.day,
            )
            : null;

    setState(() {
      if (habit.completedToday) {
        habit.completedToday = false;
        if (habit.streak > 0) habit.streak--;
        habit.lastCompleted = null; // Clear last completed if undone
      } else {
        habit.completedToday = true;
        if (lastCompletedDay == today.subtract(const Duration(days: 1))) {
          habit.streak++; // Continue streak if yesterday was completed
        } else {
          habit.streak = 1; // Start new streak
        }
        habit.lastCompleted = now;
      }
    });
    await _dbService.updateHabit(habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body:
          habits.isEmpty
              ? const Center(child: Text('No habits yet!'))
              : ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return ListTile(
                    title: Text(habit.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Streak: ${habit.streak}'),
                        const SizedBox(width: 8),
                        Checkbox(
                          value: habit.completedToday,
                          onChanged: (value) => _toggleHabitCompletion(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitScreen(onHabitAdded: _addHabit),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
