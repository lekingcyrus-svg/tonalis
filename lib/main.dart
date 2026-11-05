import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/more_screens.dart';
import 'screens/review_screen.dart';
import 'state/app_state.dart';
import 'widgets/pinyin_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(ChangeNotifierProvider.value(value: state, child: const TonalisApp()));
}

ThemeData _theme(Brightness b) {
  final dark = b == Brightness.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFB83A3A), // rouge cinabre
      secondary: const Color(0xFFC9A227), // or
      brightness: b,
    ),
    scaffoldBackgroundColor: dark
        ? const Color(0xFF0F1626)
        : const Color(0xFFFAF7F2),
  );
  return base.copyWith(textTheme: GoogleFonts.manropeTextTheme(base.textTheme));
}

class TonalisApp extends StatelessWidget {
  const TonalisApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tonalis',
    debugShowCheckedModeBanner: false,
    theme: _theme(Brightness.light),
    darkTheme: _theme(Brightness.dark),
    home: const Shell(),
  );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final due = context.watch<AppState>().dueCount;
    final pages = <Widget>[
      HomeScreen(onReview: () => setState(() => tab = 1)),
      const ReviewScreen(),
      const DictionaryScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: [
          NavigationDestination(
            icon: Text('学', style: zh(20)),
            label: 'Parcours',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: due > 0,
              label: Text(due > 99 ? '99+' : '$due'),
              child: Text('复', style: zh(20)),
            ),
            label: 'Réviser',
          ),
          NavigationDestination(
            icon: Text('典', style: zh(20)),
            label: 'Dico',
          ),
          NavigationDestination(
            icon: Text('我', style: zh(20)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
