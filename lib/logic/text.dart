const _pinyinFrom = 'āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜü';
const _pinyinTo = 'aaaaeeeeiiiioooouuuuuuuuu';

/// Pinyin sans tons ni espaces, « v » et « ü » ramenés à « u » :
/// « nǚ ér », « nu er » et « nver » se retrouvent mutuellement.
String foldPinyin(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    final c = String.fromCharCode(r);
    if (c == ' ' || c == "'" || c == '’') continue;
    final i = _pinyinFrom.indexOf(c);
    if (i >= 0) {
      b.write(_pinyinTo[i]);
    } else {
      b.write(c == 'v' ? 'u' : c);
    }
  }
  return b.toString();
}

const _frFrom = 'àâäçéèêëîïôöùûüœ’';
const _frTo = "aaaceeeeiioouuuo'";

/// Français sans accents, en minuscules.
String foldFrench(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    final c = String.fromCharCode(r);
    final i = _frFrom.indexOf(c);
    b.write(i >= 0 ? _frTo[i] : c);
  }
  return b.toString();
}
