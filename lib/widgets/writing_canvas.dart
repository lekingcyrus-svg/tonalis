import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Canevas d’écriture au doigt avec grille et caractère modèle.
/// Étape suivante : vérifier les traits avec les données Make Me a Hanzi.
class WritingCanvas extends StatefulWidget {
  final String char;
  const WritingCanvas(this.char, {super.key});
  @override
  State<WritingCanvas> createState() => _WritingCanvasState();
}

class _WritingCanvasState extends State<WritingCanvas> {
  final List<List<Offset>> strokes = [];
  bool ghost = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRect(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (d) =>
                      setState(() => strokes.add([d.localPosition])),
                  onPanUpdate: (d) =>
                      setState(() => strokes.last.add(d.localPosition)),
                  child: CustomPaint(
                    painter: _Painter(
                      strokes,
                      widget.char,
                      ghost,
                      cs.outlineVariant,
                      cs.onSurface,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: strokes.isEmpty
                  ? null
                  : () => setState(() => strokes.removeLast()),
              child: const Text('Annuler le trait'),
            ),
            TextButton(
              onPressed: () => setState(strokes.clear),
              child: const Text('Effacer'),
            ),
            TextButton(
              onPressed: () => setState(() => ghost = !ghost),
              child: Text(ghost ? 'Masquer le modèle' : 'Afficher le modèle'),
            ),
          ],
        ),
      ],
    );
  }
}

class _Painter extends CustomPainter {
  final List<List<Offset>> strokes;
  final String char;
  final bool ghost;
  final Color grid, ink;
  _Painter(this.strokes, this.char, this.ghost, this.grid, this.ink);

  @override
  void paint(Canvas canvas, Size s) {
    final g = Paint()
      ..color = grid
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & s, g);
    canvas.drawLine(Offset.zero, Offset(s.width, s.height), g);
    canvas.drawLine(Offset(s.width, 0), Offset(0, s.height), g);
    canvas.drawLine(Offset(s.width / 2, 0), Offset(s.width / 2, s.height), g);
    canvas.drawLine(Offset(0, s.height / 2), Offset(s.width, s.height / 2), g);
    if (ghost) {
      final tp = TextPainter(
        text: TextSpan(
          text: char,
          style: GoogleFonts.notoSerifSc(fontSize: s.width * .8, color: grid),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((s.width - tp.width) / 2, (s.height - tp.height) / 2),
      );
    }
    final p = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final st in strokes) {
      final path = Path()..moveTo(st.first.dx, st.first.dy);
      for (final o in st.skip(1)) {
        path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant _Painter old) => true;
}
