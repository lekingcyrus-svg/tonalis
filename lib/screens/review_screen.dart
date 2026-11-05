import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';
import '../services/speech.dart';
import '../state/app_state.dart';
import '../widgets/pinyin_text.dart';

const _labels = ['À revoir', 'Difficile', 'Bien', 'Facile'];
const _sessionSize = 30;

String _gap(int d) =>
    d <= 0 ? 'aujourd’hui' : (d < 30 ? '$d j' : '${(d / 30).round()} mois');

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<Word> queue;
  int i = 0, reviewed = 0;
  bool show = false;

  @override
  void initState() {
    super.initState();
    queue = _fresh();
  }

  List<Word> _fresh() =>
      context.read<AppState>().due.take(_sessionSize).toList()..shuffle();

  void _grade(Word w, int g) {
    context.read<AppState>().grade(w, g);
    if (g == 0) queue.add(w); // redemandé avant la fin de la session
    setState(() {
      i++;
      reviewed++;
      show = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    if (i >= queue.length) {
      final left = st.dueCount;
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(
                reviewed == 0
                    ? 'Rien à revoir pour l’instant'
                    : '$reviewed carte${reviewed > 1 ? 's' : ''} revue${reviewed > 1 ? 's' : ''}',
              ),
              if (left > 0) ...[
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => setState(() {
                    queue = _fresh();
                    i = 0;
                    show = false;
                  }),
                  child: Text('Continuer ($left restantes)'),
                ),
              ],
            ],
          ),
        ),
      );
    }
    final w = queue[i];
    final prev = st.preview(w);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: i / queue.length),
            const SizedBox(height: 32),
            Text(w.h, style: zh(84)),
            const SizedBox(height: 12),
            if (!show)
              FilledButton(
                onPressed: () {
                  setState(() => show = true);
                  Speech.say(w.h);
                },
                child: const Text('Afficher la réponse'),
              )
            else ...[
              PinyinText(w.p),
              Text(
                w.f,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () => Speech.say(w.h),
                icon: const Icon(Icons.volume_up),
              ),
              Row(
                children: [
                  for (var g = 0; g < 4; g++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: OutlinedButton(
                          onPressed: () => _grade(w, g),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _labels[g],
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                _gap(prev[g]),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
