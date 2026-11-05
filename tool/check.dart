// Vérifications sans dépendance : `dart run tool/check.dart`
import 'dart:math';

import '../lib/data/words.dart';
import '../lib/logic/fsrs.dart';
import '../lib/logic/text.dart';
import '../lib/models/word.dart';

int failures = 0;
void check(bool ok, String msg) {
  if (!ok) {
    failures++;
    print('ÉCHEC : $msg');
  }
}

void main() {
  // --- Vocabulaire ---
  check(kWords.length >= 150, 'au moins 150 mots (${kWords.length})');
  final hanzi = <String>{}, gloss = <String>{};
  for (final w in kWords) {
    check(hanzi.add(w.h), 'hanzi en double : ${w.h}');
    check(gloss.add(w.f), 'traduction en double : ${w.f} (${w.h})');
    final syl = w.p.split(' ');
    final erhua = w.h == '哪儿' || w.h == '一点儿';
    final expected = w.h.runes.length - (erhua ? 1 : 0);
    check(syl.length == expected, 'nombre de syllabes : ${w.h} ${w.p}');
    check(
      !w.p.contains('  ') && w.p.trim() == w.p,
      'espaces dans le pinyin : ${w.h}',
    );
  }
  for (final l in kLessons) {
    check(
      l.words.length >= 3 && l.words.length <= 5,
      'taille de leçon ${l.id} : ${l.words.length}',
    );
  }
  check(
    kLessons.fold<int>(0, (a, l) => a + l.words.length) == kWords.length,
    'toutes les leçons couvrent tous les mots une seule fois',
  );
  check(
    toneOf('nǐ') == 3 && toneOf('ba') == 5 && toneOf('shuì') == 4,
    'toneOf',
  );

  // --- Recherche ---
  check(foldPinyin('nǚ ér') == 'nuer', 'foldPinyin nǚ ér');
  check(
    foldPinyin('nv') == 'nu' && foldPinyin('Xiè xie') == 'xiexie',
    'foldPinyin variantes',
  );
  check(foldFrench('Désolé(e) — s’il') == "desole(e) — s'il", 'foldFrench');
  check(
    kWords.any((w) => foldPinyin(w.p).contains(foldPinyin('xie xie'))),
    'recherche sans tons',
  );

  // --- FSRS ---
  const today = 20000;
  final fresh = SrsCard.fresh(today);
  final again = Fsrs.review(fresh, 1, today),
      hard = Fsrs.review(fresh, 2, today);
  final good = Fsrs.review(fresh, 3, today),
      easy = Fsrs.review(fresh, 4, today);
  check(again.due == today, 'À revoir : échéance aujourd’hui');
  check(hard.due >= today + 1, 'Difficile : au moins 1 jour');
  check(
    good.due - today >= 3 && good.due - today <= 5,
    'Bien (nouveau) ~4 jours : ${good.due - today}',
  );
  check(
    again.due <= hard.due && hard.due <= good.due && good.due <= easy.due,
    'ordre des intervalles (nouveau)',
  );

  var c = good, day = good.due, prev = good.due - today;
  for (var k = 0; k < 6; k++) {
    c = Fsrs.review(c, 3, day);
    final gap = c.due - day;
    check(
      gap >= prev,
      'intervalle croissant à la révision ${k + 1} ($prev → $gap)',
    );
    check(gap <= Fsrs.maxInterval, 'intervalle plafonné');
    prev = gap;
    day = c.due;
  }
  final lapsed = Fsrs.review(c, 1, day);
  check(
    lapsed.stability < c.stability && lapsed.lapses == 1 && lapsed.due == day,
    'oubli : stabilité réduite',
  );
  for (final card in [c, SrsCard.legacy(3, today)]) {
    final t = max(card.due, today);
    final p = [for (var g = 1; g <= 4; g++) Fsrs.review(card, g, t).due - t];
    check(
      p[0] <= p[1] && p[1] <= p[2] && p[2] <= p[3],
      'ordre des intervalles (révision) $p',
    );
  }
  check(
    SrsCard.legacy(9, 5).reps == 5 && SrsCard.legacy(-2, 5).reps == 0,
    'migration borne les boîtes',
  );
  final round = SrsCard.fromJson(good.toJson());
  check(
    round.due == good.due && (round.stability - good.stability).abs() < 1e-9,
    'JSON aller-retour',
  );
  check(
    Fsrs.retrievability(0, 5) == 1 &&
        Fsrs.retrievability(5, 5) > .89 &&
        Fsrs.retrievability(5, 5) < .91,
    'rétention ≈ 90 % à t = S',
  );

  print(
    failures == 0
        ? 'OK : ${kWords.length} mots, ${kLessons.length} leçons, FSRS cohérent.'
        : '$failures échec(s).',
  );
  if (failures != 0) throw StateError('vérifications échouées');
}
