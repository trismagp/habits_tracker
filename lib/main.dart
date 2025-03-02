import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'screens/add_habit_screen.dart';

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
  List<Habit> habits = [
    Habit(name: 'Drink Water', streak: 3, completedToday: false),
    Habit(name: 'Exercise', streak: 1, completedToday: false),
  ];

  void _addHabit(Habit newHabit) {
    setState(() {
      habits.add(newHabit);
    });
  }

  void _toggleHabitCompletion(int index) {
    setState(() {
      final habit = habits[index];
      if (habit.completedToday) {
        // Undo completion: decrease streak if it was completed today
        habit.completedToday = false;
        if (habit.streak > 0) habit.streak--;
      } else {
        // Mark as completed: increase streak
        habit.completedToday = true;
        habit.streak++;
      }
    });
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
