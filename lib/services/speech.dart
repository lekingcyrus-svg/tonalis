import 'package:flutter_tts/flutter_tts.dart';

/// Voix système. À remplacer par des enregistrements natifs (just_audio + CDN).
class Speech {
  static final _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> say(String text, {bool slow = false}) async {
    try {
      if (!_ready) {
        await _tts.setLanguage('zh-CN');
        _ready = true;
      }
      await _tts.setSpeechRate(slow ? 0.25 : 0.4);
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Pas de voix chinoise installée : l’appli reste utilisable sans son.
    }
  }
}
