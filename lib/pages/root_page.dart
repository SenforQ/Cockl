import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import 'discover_page.dart';
import 'plan_page.dart';
import 'profile_page.dart';
import 'workout_home_page.dart';

class FitnessRootPage extends StatefulWidget {
  const FitnessRootPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  State<FitnessRootPage> createState() => _FitnessRootPageState();
}

class _FitnessRootPageState extends State<FitnessRootPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      WorkoutHomePage(repository: widget.repository),
      DiscoverPage(repository: widget.repository),
      PlanPage(repository: widget.repository),
      ProfilePage(repository: widget.repository),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
