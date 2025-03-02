import 'package:flutter/material.dart';
import 'models/habit.dart';

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Hardcoded list of habits for testing
  final List<Habit> habits = [
    Habit(name: 'Drink Water', streak: 3),
    Habit(name: 'Exercise', streak: 1),
  ];

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
                    trailing: Text('Streak: ${habit.streak}'),
                  );
                },
              ),
    );
  }
}
