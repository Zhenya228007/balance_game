import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/content_repository.dart';
import '../logic/game_controller.dart';
import '../models/game_mode.dart';
import 'game_screen.dart';

class ModeSelectScreen extends StatefulWidget {
  final ContentRepository repo;
  const ModeSelectScreen({super.key, required this.repo});

  @override
  State<ModeSelectScreen> createState() => _ModeSelectScreenState();
}

class _ModeSelectScreenState extends State<ModeSelectScreen> {
  Future<void> _start(GameMode mode) async {
    final players = await showDialog<List<String>>(
      context: context,
      builder: (_) => _PlayersDialog(mode: mode),
    );
    if (players == null || !mounted) return;
    final g = GameController(mode: mode, players: players, deck: widget.repo.questionsFor(mode.id));
    Navigator.of(context).push(MaterialPageRoute(
      settings: const RouteSettings(name: '/game'),
      builder: (_) => ChangeNotifierProvider.value(value: g, child: GameScreen(repo: widget.repo)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Баланс')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final m in gameModes)
            Card(
              color: m.background,
              child: ListTile(
                title: Text(m.title,
                    style: TextStyle(color: m.id == 'friends' ? Colors.white : m.text, fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text('Игроков: ${m.players}', style: TextStyle(color: m.accent)),
                onTap: () => _start(m),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlayersDialog extends StatefulWidget {
  final GameMode mode;
  const _PlayersDialog({required this.mode});
  @override
  State<_PlayersDialog> createState() => _PlayersDialogState();
}

class _PlayersDialogState extends State<_PlayersDialog> {
  late final List<TextEditingController> _c =
      List.generate(widget.mode.minPlayers, (i) => TextEditingController(text: 'Игрок ${i + 1}'));

  @override
  Widget build(BuildContext context) {
    final fixed = widget.mode.players == '2';
    return AlertDialog(
      title: Text(widget.mode.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in _c) TextField(controller: c, decoration: const InputDecoration(labelText: 'Имя')),
            if (!fixed)
              TextButton(
                onPressed: () => setState(() => _c.add(TextEditingController(text: 'Игрок ${_c.length + 1}'))),
                child: const Text('+ игрок'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        FilledButton(
          onPressed: () => Navigator.pop(
              context, _c.map((e) => e.text.trim()).where((s) => s.isNotEmpty).toList()),
          child: const Text('Начать'),
        ),
      ],
    );
  }
}
