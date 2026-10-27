import 'package:flutter/foundation.dart';
import '../models/game_mode.dart';
import '../models/question.dart';

/// Состояние партии: шкалы, очередь игроков, вклад каждого игрока.
class GameController extends ChangeNotifier {
  static const int startValue = 50;
  static const int maxValue = 100;

  final GameMode mode;
  final List<String> players;
  final List<Question> deck;

  late final Map<String, int> values;
  late final Map<String, Map<String, int>> contributions; // игрок -> шкала -> вклад
  int turn = 0;
  String? failedParam; // шкала, упавшая до 0
  Map<String, int>? lastDelta;

  GameController({required this.mode, required this.players, required this.deck}) {
    values = {for (final p in mode.params) p: startValue};
    contributions = {
      for (final pl in players) pl: {for (final p in mode.params) p: 0}
    };
  }

  String get currentPlayer => players[turn % players.length];
  Question questionAt(int i) => deck[i % deck.length];
  bool get isFailed => failedParam != null;

  /// ГЛАВНОЕ МЕСТО ЛОГИКИ. Вызывается из onSwipe.
  /// [agree] true = свайп влево («Согласен»), false = вправо («Не согласен»).
  /// Возвращает true, если шкала упала до 0.
  bool applySwipe(Question q, {required bool agree}) {
    final effects = (agree ? q.swipeLeft : q.swipeRight).effects;
    lastDelta = effects;
    effects.forEach((param, delta) {
      values[param] = (values[param]! + delta).clamp(0, maxValue);
      contributions[currentPlayer]![param] =
          contributions[currentPlayer]![param]! + delta;
    });
    failedParam = null;
    for (final p in mode.params) {
      if (values[p]! <= 0) {
        failedParam = p;
        break;
      }
    }
    if (!isFailed) turn++;
    notifyListeners();
    return isFailed;
  }

  /// Виновник: игрок с наименьшим суммарным вкладом по упавшей шкале.
  String get culprit {
    final p = failedParam!;
    return players.reduce(
        (a, b) => contributions[a]![p]! <= contributions[b]![p]! ? a : b);
  }

  int total(String player) =>
      contributions[player]!.values.fold(0, (a, b) => a + b);

  /// «Выполнено!» — восстановить упавшую шкалу.
  void restoreFailed() {
    final p = failedParam;
    if (p != null) values[p] = startValue;
    failedParam = null;
    turn++;
    notifyListeners();
  }
}
