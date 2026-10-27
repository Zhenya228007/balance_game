import 'package:flutter/material.dart';
import 'data/content_repository.dart';
import 'screens/mode_select_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await ContentRepository.load();
  runApp(BalanceApp(repo: repo));
}

class BalanceApp extends StatelessWidget {
  final ContentRepository repo;
  const BalanceApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Баланс',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: ModeSelectScreen(repo: repo),
    );
  }
}
