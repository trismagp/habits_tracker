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
    setState(() {
      habits = loadedHabits;
    });
  }

  void _addHabit(Habit newHabit) async {
    await _dbService.insertHabit(newHabit);
    _loadHabits(); // Refresh list
  }

  void _toggleHabitCompletion(int index) async {
    final habit = habits[index];
    if (habit.completedToday) {
      habit.completedToday = false;
      if (habit.streak > 0) habit.streak--;
    } else {
      habit.completedToday = true;
      habit.streak++;
    }
    await _dbService.updateHabit(habit);
    setState(() {
      habits[index] = habit;
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
