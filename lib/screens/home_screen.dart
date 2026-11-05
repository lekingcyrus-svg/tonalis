import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/words.dart';
import '../state/app_state.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onReview;
  const HomeScreen({required this.onReview, super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final due = s.dueCount;
    final goal = min(1.0, s.xpToday / AppState.dailyGoal);
    final next = kLessons.firstWhere(
      (l) => !s.done.contains(l.id),
      orElse: () => kLessons.last,
    );
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tonalis',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Chip(label: Text('🔥 ${s.streakNow} · ${s.xp} XP')),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal >= 1
                ? 'Objectif du jour atteint 🎯'
                : 'Objectif du jour : ${s.xpToday} / ${AppState.dailyGoal} XP',
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: goal,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          if (due > 0)
            Card(
              margin: const EdgeInsets.only(top: 14),
              child: ListTile(
                leading: const Icon(Icons.replay),
                title: Text('$due mot${due > 1 ? 's' : ''} à réviser'),
                subtitle: const Text(
                  'Quelques minutes suffisent pour tout retenir',
                ),
                trailing: FilledButton(
                  onPressed: onReview,
                  child: const Text('Réviser'),
                ),
              ),
            ),
          for (var u = 0; u < kUnits.length; u++) _UnitCard(u, next.id),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final int unit, nextId;
  const _UnitCard(this.unit, this.nextId);

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final lessons = kLessons.where((l) => l.unit == unit).toList();
    final doneCount = lessons.where((l) => s.done.contains(l.id)).length;
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${unit + 1}. ${kUnits[unit].name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('$doneCount/${lessons.length}'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: doneCount / lessons.length),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final l in lessons) _lessonButton(context, s, l)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonButton(BuildContext context, AppState s, Lesson l) {
    final locked = l.id > 0 && !s.done.contains(l.id - 1);
    final label = Text('Leçon ${l.number}${s.done.contains(l.id) ? ' ✓' : ''}');
    void open() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LessonScreen(l.id)),
    );
    if (l.id == nextId && !locked) {
      return FilledButton(onPressed: open, child: label);
    }
    return OutlinedButton(onPressed: locked ? null : open, child: label);
  }
}
