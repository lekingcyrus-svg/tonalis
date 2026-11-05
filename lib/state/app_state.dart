import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/words.dart';
import '../logic/fsrs.dart';
import '../models/word.dart';

class AppState extends ChangeNotifier {
  static const dailyGoal = 20; // XP par jour
  static const _version = 2;

  int xp = 0,
      streak = 0,
      lastDay = 0,
      dayXp = 0,
      dayXpDate = 0,
      reviewCount = 0;
  Set<int> done = {};
  Map<String, SrsCard> cards = {}; // hanzi -> état de mémorisation
  late SharedPreferences _p;

  /// Jour local (et non UTC) : la série ne se coupe plus à minuit UTC.
  static int today() {
    final n = DateTime.now();
    return DateTime.utc(n.year, n.month, n.day).millisecondsSinceEpoch ~/
        86400000;
  }

  int get level => xp ~/ 100 + 1;
  int get xpToday => dayXpDate == today() ? dayXp : 0;

  /// Série en cours : retombe à 0 dès qu’un jour entier a été manqué.
  int get streakNow => lastDay >= today() - 1 ? streak : 0;

  int get learnedCount => cards.length;
  int get masteredCount =>
      cards.values.where((c) => c.reps > 0 && c.stability >= 21).length;

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    final j = _p.getString('state');
    if (j != null) {
      try {
        _restore(jsonDecode(j) as Map<String, dynamic>);
      } catch (_) {
        // Données illisibles : on garde une copie au lieu de les écraser.
        await _p.setString('state_corrupt_backup', j);
      }
    }
    notifyListeners();
  }

  int _i(dynamic v) => v is num ? v.toInt() : 0;

  void _restore(Map<String, dynamic> m) {
    xp = _i(m['xp']);
    streak = _i(m['streak']);
    lastDay = _i(m['last']);
    dayXp = _i(m['dayXp']);
    dayXpDate = _i(m['dayXpDate']);
    reviewCount = _i(m['reviews']);
    // Avant la v2, les leçons avaient une autre numérotation : on repart de zéro
    // pour le parcours, mais les mots déjà appris sont conservés.
    done = _i(m['v']) >= 2
        ? {for (final v in (m['done'] as List? ?? const [])) _i(v)}
        : <int>{};
    cards = {};
    final raw = (m['srs'] as Map?) ?? const {};
    raw.forEach((k, v) {
      if (v is List && v.length >= 2) {
        cards[k as String] = SrsCard.legacy(
          _i(v[0]),
          _i(v[1]),
        ); // boîtes de Leitner
      } else if (v is Map) {
        cards[k as String] = SrsCard.fromJson(Map<String, dynamic>.from(v));
      }
    });
  }

  Future<void> _save() => _p.setString(
    'state',
    jsonEncode({
      'v': _version,
      'xp': xp,
      'streak': streak,
      'last': lastDay,
      'dayXp': dayXp,
      'dayXpDate': dayXpDate,
      'reviews': reviewCount,
      'done': done.toList(),
      'srs': cards.map((k, v) => MapEntry(k, v.toJson())),
    }),
  );

  void _gain(int n) {
    final d = today();
    if (dayXpDate != d) {
      dayXpDate = d;
      dayXp = 0;
    }
    xp += n;
    dayXp += n;
  }

  void _touch() {
    final d = today();
    if (lastDay == d) return;
    streak = lastDay == d - 1 ? streak + 1 : 1;
    lastDay = d;
  }

  /// Termine une leçon et renvoie l’XP gagné.
  int completeLesson(int id, int correct) {
    final gain = 10 + correct * 2;
    _gain(gain);
    done.add(id);
    _touch();
    for (final w in kLessons[id].words) {
      cards.putIfAbsent(w.h, () => SrsCard.fresh(today() + 1));
    }
    _save();
    notifyListeners();
    return gain;
  }

  List<Word> get due {
    final d = today();
    final list = kWords.where((w) => (cards[w.h]?.due ?? d + 1) <= d).toList();
    list.sort((a, b) => cards[a.h]!.due.compareTo(cards[b.h]!.due));
    return list;
  }

  int get dueCount => due.length;

  /// Jours avant la prochaine révision pour chacune des 4 notes.
  List<int> preview(Word w) {
    final d = today();
    final c = cards[w.h] ?? SrsCard.fresh(d);
    return [for (var g = 1; g <= 4; g++) Fsrs.review(c, g, d).due - d];
  }

  /// g : 0 À revoir, 1 Difficile, 2 Bien, 3 Facile
  void grade(Word w, int g) {
    final d = today();
    final c = cards[w.h] ?? SrsCard.fresh(d);
    cards[w.h] = Fsrs.review(c, g + 1, d);
    reviewCount++;
    _gain(2);
    _touch();
    _save();
    notifyListeners();
  }
}
