import 'dart:math';

/// État de mémorisation d’un mot (modèle FSRS).
class SrsCard {
  final double stability; // jours pour que la mémorisation tombe à 90 %
  final double difficulty; // 1 (facile) à 10 (difficile)
  final int due; // jour d’échéance (jours depuis 1970)
  final int last; // jour de la dernière révision
  final int reps, lapses;

  const SrsCard({
    required this.stability,
    required this.difficulty,
    required this.due,
    required this.last,
    required this.reps,
    required this.lapses,
  });

  /// Mot vu en leçon mais jamais noté en révision.
  factory SrsCard.fresh(int due) => SrsCard(
    stability: 0,
    difficulty: 0,
    due: due,
    last: due,
    reps: 0,
    lapses: 0,
  );

  /// Migration depuis l’ancien format (boîtes de Leitner : [boîte, échéance]).
  factory SrsCard.legacy(int box, int due) {
    const days = [1, 1, 3, 7, 16, 35];
    final b = box < 0 ? 0 : (box > 5 ? 5 : box);
    return SrsCard(
      stability: days[b].toDouble(),
      difficulty: 5,
      due: due,
      last: due - days[b],
      reps: b,
      lapses: 0,
    );
  }

  factory SrsCard.fromJson(Map<String, dynamic> m) {
    int i(dynamic v) => v is num ? v.toInt() : 0;
    double d(dynamic v) => v is num ? v.toDouble() : 0;
    return SrsCard(
      stability: d(m['s']),
      difficulty: d(m['d']),
      due: i(m['due']),
      last: i(m['last']),
      reps: i(m['n']),
      lapses: i(m['l']),
    );
  }

  Map<String, dynamic> toJson() => {
    's': stability,
    'd': difficulty,
    'due': due,
    'last': last,
    'n': reps,
    'l': lapses,
  };

  bool get isNew => reps == 0;
}

/// Planificateur de révisions espacées, d’après FSRS 4.5 (poids par défaut).
/// Notes : 1 À revoir, 2 Difficile, 3 Bien, 4 Facile.
class Fsrs {
  static const _w = [
    0.4872,
    1.4003,
    3.7145,
    13.8206,
    5.1618,
    1.2298,
    0.8975,
    0.031,
    1.6474,
    0.1367,
    1.0461,
    2.1072,
    0.0793,
    0.3246,
    1.587,
    0.2272,
    2.8755,
  ];
  static const _factor = 19 / 81;
  static const _decay = -0.5;
  static const retention = 0.9;
  static const maxInterval = 365;

  /// Probabilité de se souvenir après [t] jours pour une stabilité [s].
  static double retrievability(int t, double s) =>
      pow(1 + _factor * t / s, _decay).toDouble();

  static int interval(double s) {
    final days = s / _factor * (pow(retention, 1 / _decay) - 1);
    return max(1, min(maxInterval, days.round()));
  }

  static double _clampD(double d) => min(10.0, max(1.0, d));

  static double _nextD(double d, int g) {
    final init = _w[4] - (4 - 3) * _w[5];
    return _clampD(_w[7] * init + (1 - _w[7]) * (d - _w[6] * (g - 3)));
  }

  static double _recall(double d, double s, double r, int g) {
    final hard = g == 2 ? _w[15] : 1.0;
    final easy = g == 4 ? _w[16] : 1.0;
    return s *
        (1 +
            exp(_w[8]) *
                (11 - d) *
                pow(s, -_w[9]) *
                (exp((1 - r) * _w[10]) - 1) *
                hard *
                easy);
  }

  static double _forget(double d, double s, double r) {
    final v =
        _w[11] *
        pow(d, -_w[12]) *
        (pow(s + 1, _w[13]) - 1) *
        exp((1 - r) * _w[14]);
    return min(v, s);
  }

  /// Nouvelle carte après une révision notée [grade] (1 à 4) le jour [today].
  /// « À revoir » reste due aujourd’hui ; les autres notes donnent au moins 1 jour.
  static SrsCard review(SrsCard c, int grade, int today) {
    assert(grade >= 1 && grade <= 4);
    final t = max(0, today - c.last);
    double s, d;
    var lapses = c.lapses;
    if (c.isNew) {
      s = _w[grade - 1];
      d = _clampD(_w[4] - (grade - 3) * _w[5]);
    } else {
      final r = retrievability(t, c.stability);
      d = _nextD(c.difficulty, grade);
      if (grade == 1) {
        s = _forget(c.difficulty, c.stability, r);
        lapses += 1;
      } else {
        s = _recall(c.difficulty, c.stability, r, grade);
      }
    }
    final gap = grade == 1 ? 0 : interval(s);
    return SrsCard(
      stability: s,
      difficulty: d,
      due: today + gap,
      last: today,
      reps: c.reps + 1,
      lapses: lapses,
    );
  }
}
