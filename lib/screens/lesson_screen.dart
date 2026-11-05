import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/words.dart';
import '../models/word.dart';
import '../services/speech.dart';
import '../state/app_state.dart';
import '../widgets/pinyin_text.dart';
import '../widgets/writing_canvas.dart';

enum _Kind { intro, mcq, reverse, listen, write }

class _Step {
  final _Kind kind;
  final Word w;
  final List<Word> opts;
  const _Step(this.kind, this.w, [this.opts = const []]);
}

const _good = Color(0x334CAF50);
const _bad = Color(0x33F44336);

class LessonScreen extends StatefulWidget {
  final int id;
  const LessonScreen(this.id, {super.key});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _rng = Random();
  late final List<_Step> steps;
  final Set<Word> missed = {};
  int i = 0, ok = 0, tried = 0, gained = 0;
  int? picked;
  bool retried = false, finished = false;

  @override
  void initState() {
    super.initState();
    final ws = kLessons[widget.id].words;
    final writeWord = ws.firstWhere(
      (w) => w.h.length == 1,
      orElse: () => ws.first,
    );
    steps = [
      for (final w in ws) _Step(_Kind.intro, w),
      for (final w in ws) _Step(_Kind.mcq, w, _options(w)),
      for (var k = 0; k < ws.length; k++)
        _Step(k.isEven ? _Kind.reverse : _Kind.listen, ws[k], _options(ws[k])),
      _Step(_Kind.write, writeWord),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoplay());
  }

  List<Word> _options(Word w) {
    final pool = kWords.where((x) => x.h != w.h && x.f != w.f).toList()
      ..shuffle(_rng);
    return [w, ...pool.take(3)]..shuffle(_rng);
  }

  void _autoplay() {
    if (!mounted || finished) return;
    final s = steps[i];
    if (s.kind == _Kind.intro || s.kind == _Kind.listen) Speech.say(s.w.h);
  }

  void _pick(_Step s, int k) {
    final good = s.opts[k] == s.w;
    if (!retried) {
      tried++;
      if (good) ok++;
    }
    if (!good) missed.add(s.w);
    setState(() => picked = k);
  }

  void _next() {
    picked = null;
    if (i + 1 >= steps.length) {
      if (!retried && missed.isNotEmpty) {
        // Les mots ratés reviennent une fois, à la fin de la leçon.
        retried = true;
        steps.addAll([
          for (final w in missed) _Step(_Kind.mcq, w, _options(w)),
        ]);
      } else {
        final gain = context.read<AppState>().completeLesson(widget.id, ok);
        setState(() {
          gained = gain;
          finished = true;
        });
        return;
      }
    }
    setState(() => i++);
    _autoplay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: LinearProgressIndicator(
          value: finished ? 1 : i / steps.length,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: finished ? _result() : _lesson(steps[i]),
        ),
      ),
    );
  }

  Widget _lesson(_Step s) {
    final content = _content(s);
    return Column(
      children: [
        Expanded(
          // Le canevas d’écriture capte les glissements : pas de défilement à cette étape.
          child: s.kind == _Kind.write
              ? Center(child: content)
              : SingleChildScrollView(child: content),
        ),
        const SizedBox(height: 12),
        _bottom(s),
      ],
    );
  }

  Widget _bottom(_Step s) {
    final label = s.kind == _Kind.write ? 'Terminer la leçon' : 'Continuer';
    final show =
        s.kind == _Kind.intro || s.kind == _Kind.write || picked != null;
    if (!show) return const SizedBox(height: 48);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(onPressed: _next, child: Text(label)),
    );
  }

  Widget _content(_Step s) {
    switch (s.kind) {
      case _Kind.intro:
        return Column(
          children: [
            const SizedBox(height: 24),
            Text(s.w.h, style: zh(84)),
            PinyinText(s.w.p),
            Text(
              s.w.f,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => Speech.say(s.w.h),
                  child: const Text('🔊 Normal'),
                ),
                OutlinedButton(
                  onPressed: () => Speech.say(s.w.h, slow: true),
                  child: const Text('🐢 Lent'),
                ),
              ],
            ),
          ],
        );
      case _Kind.mcq:
        return _quiz(
          s,
          Text(s.w.h, style: zh(72)),
          'Que signifie ce mot ?',
          (o) => Text(
            o.f,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );
      case _Kind.reverse:
        return _quiz(
          s,
          Text(
            s.w.f,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          'Quel est ce mot en chinois ?',
          (o) => Text(o.h, style: zh(28)),
        );
      case _Kind.listen:
        return _quiz(
          s,
          FilledButton.icon(
            onPressed: () => Speech.say(s.w.h),
            icon: const Icon(Icons.volume_up),
            label: const Text('Écouter'),
          ),
          'Quel mot entendez-vous ?',
          (o) => Text(o.h, style: zh(28)),
        );
      case _Kind.write:
        final ch = s.w.h.substring(0, 1);
        return Column(
          children: [
            Text('Tracez $ch', style: const TextStyle(fontSize: 18)),
            PinyinText(s.w.p, size: 18),
            const SizedBox(height: 8),
            WritingCanvas(ch),
          ],
        );
    }
  }

  Widget _quiz(
    _Step s,
    Widget prompt,
    String question,
    Widget Function(Word) label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: prompt),
        const SizedBox(height: 8),
        Center(child: Text(question)),
        const SizedBox(height: 12),
        for (var k = 0; k < s.opts.length; k++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                backgroundColor: picked == null
                    ? null
                    : s.opts[k] == s.w
                    ? _good
                    : (picked == k ? _bad : null),
              ),
              onPressed: picked == null ? () => _pick(s, k) : null,
              child: label(s.opts[k]),
            ),
          ),
        if (picked != null) ...[const SizedBox(height: 8), _feedback(s)],
      ],
    );
  }

  Widget _feedback(_Step s) {
    final good = s.opts[picked!] == s.w;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: good ? _good : _bad,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            good ? 'Bonne réponse !' : 'Réponse : ${s.w.h} · ${s.w.f}',
            style: const TextStyle(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          PinyinText(s.w.p, size: 18),
        ],
      ),
    );
  }

  Widget _result() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 8),
        Text(
          'Leçon terminée !',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text('$ok / $tried bonnes réponses du premier coup'),
        Text('+$gained XP', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuer'),
          ),
        ),
      ],
    );
  }
}
