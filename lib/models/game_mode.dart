import 'package:flutter/material.dart';

/// Тема режима. Идентификаторы шкал совпадают с ключами effects в JSON.
class GameMode {
  final String id;
  final String title;
  final String players;
  final List<String> params;
  final List<String> paramLabels;
  final Color background;
  final Color card;
  final Color text;
  final Color accent;
  final String fontFamily; // добавьте шрифты в pubspec или google_fonts

  const GameMode({
    required this.id,
    required this.title,
    required this.players,
    required this.params,
    required this.paramLabels,
    required this.background,
    required this.card,
    required this.text,
    required this.accent,
    this.fontFamily = 'Roboto',
  });

  int get minPlayers => int.parse(players.replaceAll('+', ''));
}

const gameModes = <GameMode>[
  GameMode(
    id: 'date', title: 'Свидание', players: '2',
    params: ['closeness', 'passion', 'respect'],
    paramLabels: ['🫶 Близость', '🔥 Страсть', '🛡️ Уважение'],
    background: Color(0xFF2A1033), card: Color(0xFFFDE7F3),
    text: Color(0xFF3A1245), accent: Color(0xFFFF5FA2),
  ),
  GameMode(
    id: 'friends', title: 'Свои люди', players: '2+',
    params: ['chaos', 'loyalty', 'vibe'],
    paramLabels: ['🤪 Хаос', '🤝 Верность', '😂 Вайб'],
    background: Color(0xFF0A0A0A), card: Color(0xFFFFFFFF),
    text: Color(0xFF111111), accent: Color(0xFFC6FF00),
  ),
  GameMode(
    id: 'campus', title: 'Универ / Тусовка', players: '3+',
    params: ['solidarity', 'freebie', 'madness'],
    paramLabels: ['📚 Солидарность', '🍕 Халява', '😈 Безумие'],
    background: Color(0xFFFFE14D), card: Color(0xFFFFFBEA),
    text: Color(0xFF1B1B1B), accent: Color(0xFF6B2BD9),
  ),
  GameMode(
    id: 'office', title: 'Офисный планктон', players: '4+',
    params: ['spirit', 'professionalism', 'party'],
    paramLabels: ['☕ Командный дух', '💼 Профессионализм', '🍻 Корпоратив'],
    background: Color(0xFFECEFF1), card: Color(0xFFFFFFFF),
    text: Color(0xFF37474F), accent: Color(0xFF10B981),
  ),
  GameMode(
    id: 'family', title: 'Семейный', players: '3+',
    params: ['wisdom', 'care', 'traditions'],
    paramLabels: ['👵 Мудрость', '🧸 Забота', '🍳 Традиции'],
    background: Color(0xFFF5E9D6), card: Color(0xFFFFF8EC),
    text: Color(0xFF4A2E15), accent: Color(0xFF8B5A2B),
  ),
];
