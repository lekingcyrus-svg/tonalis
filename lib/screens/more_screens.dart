import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/words.dart';
import '../logic/text.dart';
import '../services/speech.dart';
import '../state/app_state.dart';
import '../widgets/pinyin_text.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final raw = q.trim();
    final py = foldPinyin(raw), fr = foldFrench(raw);
    // Recherche sans accents ni tons : « xie xie », « merci », « nv » ou « 谢 » fonctionnent.
    final r = raw.isEmpty
        ? kWords
        : kWords
              .where(
                (w) =>
                    w.h.contains(raw) ||
                    (py.isNotEmpty && foldPinyin(w.p).contains(py)) ||
                    foldFrench(w.f).contains(fr),
              )
              .toList();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Caractère, pinyin ou français',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => q = v),
            ),
          ),
          Expanded(
            child: r.isEmpty
                ? const Center(child: Text('Aucun résultat'))
                : ListView.builder(
                    itemCount: r.length,
                    itemBuilder: (_, k) {
                      final w = r[k];
                      return ListTile(
                        leading: Text(w.h, style: zh(28)),
                        title: PinyinText(w.p, size: 18),
                        subtitle: Text(w.f),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (s.cards.containsKey(w.h))
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: Color(0xFF2E8B57),
                              ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => Speech.say(w.h),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

const _titles = [
  'Apprenti pinceau',
  'Lettré en herbe',
  'Calligraphe',
  'Érudit',
  'Sage du pinceau',
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final title = _titles[min(s.level - 1, _titles.length - 1)];
    final stats = [
      ('XP', '${s.xp}'),
      ('Jours d’affilée', '${s.streakNow}'),
      ('Leçons', '${s.done.length}/${kLessons.length}'),
      ('Mots appris', '${s.learnedCount}/${kWords.length}'),
      ('Bien maîtrisés', '${s.masteredCount}'),
      ('Révisions', '${s.reviewCount}'),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
          Text('Niveau ${s.level} · $title'),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (s.xp % 100) / 100,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            children: [
              for (final e in stats)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e.$2,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          e.$1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
