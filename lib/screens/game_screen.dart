import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../data/content_repository.dart';
import '../logic/game_controller.dart';
import '../models/question.dart';
import '../widgets/balance_widgets.dart';
import 'fail_screen.dart';

class GameScreen extends StatefulWidget {
  final ContentRepository repo;
  const GameScreen({super.key, required this.repo});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final CardSwiperController _swiper = CardSwiperController();

  @override
  void dispose() {
    _swiper.dispose();
    super.dispose();
  }

  bool _onSwipe(int prev, int? curr, CardSwiperDirection dir, GameController g) {
    final q = g.questionAt(prev);
    final agree = dir == CardSwiperDirection.left;
    // >>> ЗДЕСЬ ИЗМЕНЕНИЕ ШКАЛ <<<
    final failed = g.applySwipe(q, agree: agree);
    if (failed) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: g,
          child: FailScreen(repo: widget.repo),
        ),
      ));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameController>();
    final m = g.mode;
    return Scaffold(
      backgroundColor: m.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: m.accent,
        elevation: 0,
        title: Text(m.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  for (var i = 0; i < m.params.length; i++)
                    BalanceBar(
                      label: m.paramLabels[i],
                      value: g.values[m.params[i]]!,
                      delta: g.lastDelta?[m.params[i]],
                      color: m.accent,
                      textColor: m.id == 'friends' ? Colors.white : m.text,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(color: m.accent, borderRadius: BorderRadius.circular(20)),
              child: Text('Ход: ${g.currentPlayer}',
                  style: TextStyle(
                      color: m.id == 'friends' ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CardSwiper(
                  controller: _swiper,
                  cardsCount: g.deck.length,
                  isLoop: true,
                  numberOfCardsDisplayed: 2,
                  allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
                  onSwipe: (p, c, d) => _onSwipe(p, c, d, g),
                  cardBuilder: (context, index, hPct, vPct) =>
                      _QuestionCard(q: g.deck[index], g: g, hPct: hPct.toDouble()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('← Согласен        Не согласен →',
                  style: TextStyle(color: m.id == 'friends' ? Colors.white70 : m.text.withOpacity(0.7))),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question q;
  final GameController g;
  final double hPct;
  const _QuestionCard({required this.q, required this.g, required this.hPct});

  @override
  Widget build(BuildContext context) {
    final m = g.mode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: m.card,
        borderRadius: BorderRadius.circular(m.id == 'friends' ? 4 : 28),
        border: Border.all(color: m.accent, width: 3),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(q.text,
                textAlign: TextAlign.center,
                style: TextStyle(color: m.text, fontSize: 24, fontWeight: FontWeight.w700)),
          ),
          if (hPct < -10)
            const Align(alignment: Alignment.topRight, child: Text('СОГЛАСЕН', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 20))),
          if (hPct > 10)
            const Align(alignment: Alignment.topLeft, child: Text('НЕ СОГЛАСЕН', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 20))),
        ],
      ),
    );
  }
}
