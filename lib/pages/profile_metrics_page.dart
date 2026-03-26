import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';

class ProfileMetricsPage extends StatefulWidget {
  const ProfileMetricsPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  State<ProfileMetricsPage> createState() => _ProfileMetricsPageState();
}

class _ProfileMetricsPageState extends State<ProfileMetricsPage> {
  late double currentWeight;
  late double monthlyWeightChange;
  late int proteinRate;

  @override
  void initState() {
    super.initState();
    final data = widget.repository.profileMetrics;
    currentWeight = data.currentWeight;
    monthlyWeightChange = data.monthlyWeightChange;
    proteinRate = data.proteinAchievementRate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Metrics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Current Weight ${currentWeight.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Slider(
            min: 40,
            max: 120,
            value: currentWeight,
            onChanged: (value) {
              setState(() {
                currentWeight = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Weight Change in Last 30 Days ${monthlyWeightChange.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Slider(
            min: -8,
            max: 8,
            value: monthlyWeightChange,
            onChanged: (value) {
              setState(() {
                monthlyWeightChange = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Protein Target Achievement $proteinRate%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: proteinRate.toDouble(),
            onChanged: (value) {
              setState(() {
                proteinRate = value.round();
              });
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await widget.repository.updateProfileMetrics(
                currentWeight: currentWeight,
                monthlyWeightChange: monthlyWeightChange,
                proteinAchievementRate: proteinRate,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
