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
  // Dynamic list, starting with Step 2’s static data
  List<Habit> habits = [
    Habit(name: 'Drink Water', streak: 3),
    Habit(name: 'Exercise', streak: 1),
  ];

  void _addHabit(Habit newHabit) {
    setState(() {
      habits.add(newHabit);
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
                    trailing: Text('Streak: ${habit.streak}'),
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
