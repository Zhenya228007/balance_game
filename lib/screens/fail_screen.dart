import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/content_repository.dart';
import '../logic/game_controller.dart';
import '../widgets/balance_widgets.dart';

/// Сводная таблица + пульсирующая кнопка «Выполнить задание» + карточка задания.
class FailScreen extends StatelessWidget {
  final ContentRepository repo;
  const FailScreen({super.key, required this.repo});

  Color _c(int v) => v > 0 ? Colors.green : (v < 0 ? Colors.red : Colors.grey);

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameController>();
    final m = g.mode;
    if (!g.isFailed) return Scaffold(backgroundColor: m.background); // после «Выполнено!»
    final failedIdx = m.params.indexOf(g.failedParam!);
    return Scaffold(
      backgroundColor: m.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Шкала упала: ${m.paramLabels[failedIdx]}',
                  style: TextStyle(color: m.accent, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      const DataColumn(label: Text('Игрок')),
                      for (final l in m.paramLabels) DataColumn(label: Text(l.split(' ').first)),
                      const DataColumn(label: Text('Итого')),
                    ],
                    rows: [
                      for (final p in g.players)
                        DataRow(cells: [
                          DataCell(Text(p)),
                          for (final param in m.params)
                            DataCell(Text('${g.contributions[p]![param]}',
                                style: TextStyle(color: _c(g.contributions[p]![param]!), fontWeight: FontWeight.bold))),
                          DataCell(Text('${g.total(p)}',
                              style: TextStyle(color: _c(g.total(p)), fontWeight: FontWeight.bold))),
                        ]),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                color: m.accent.withOpacity(0.2),
                child: Text(
                  'Вердикт: ${g.culprit} уронил(а) шкалу «${m.paramLabels[failedIdx]}» '
                  '(${g.contributions[g.culprit]![m.params[failedIdx]]})',
                  style: TextStyle(color: m.id == 'friends' ? Colors.white : m.text, fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              PulseButton(
                text: 'Выполнить задание',
                color: m.accent,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: g,
                    child: TaskScreen(repo: repo),
                  ),
                )),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final ContentRepository repo;
  const TaskScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final g = context.read<GameController>();
    final m = g.mode;
    final task = repo.randomTask(m.id);
    return Scaffold(
      backgroundColor: m.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Задание для ${g.culprit}',
                  style: TextStyle(color: m.accent, fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: m.card,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: m.accent, width: 3),
                  ),
                  child: Center(
                    child: Text(task.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: m.text, fontSize: 24, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.all(18)),
                  onPressed: () {
                    g.restoreFailed();
                    Navigator.of(context).popUntil((r) => r.settings.name == '/game' || r.isFirst);
                  },
                  child: const Text('Выполнено!', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.all(16)),
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Отказ (Штраф)', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
