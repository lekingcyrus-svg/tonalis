class Word {
  final String h, p, f; // hanzi, pinyin, français
  const Word(this.h, this.p, this.f);

  // Deux mots sont identiques s’ils ont les mêmes caractères.
  @override
  bool operator ==(Object other) => other is Word && other.h == h;

  @override
  int get hashCode => h.hashCode;
}

class Unit {
  final String name;
  final List<Word> words;
  const Unit(this.name, this.words);
}

/// Ton d’une syllabe pinyin (1 à 4, 5 = ton neutre).
int toneOf(String syl) {
  const m = {1: 'āēīōūǖ', 2: 'áéíóúǘ', 3: 'ǎěǐǒǔǚ', 4: 'àèìòùǜ'};
  for (final c in syl.split('')) {
    for (final e in m.entries) {
      if (e.value.contains(c)) return e.key;
    }
  }
  return 5;
}
