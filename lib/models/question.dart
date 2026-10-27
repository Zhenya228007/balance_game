class SwipeOption {
  final String label;
  final Map<String, int> effects;
  const SwipeOption({required this.label, required this.effects});

  factory SwipeOption.fromJson(Map<String, dynamic> j) => SwipeOption(
        label: j['label'] as String,
        effects: (j['effects'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toInt())),
      );
}

class Question {
  final String id;
  final String mode;
  final String text;
  final SwipeOption swipeLeft; // «Согласен»
  final SwipeOption swipeRight; // «Не согласен»

  const Question({
    required this.id,
    required this.mode,
    required this.text,
    required this.swipeLeft,
    required this.swipeRight,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as String,
        mode: j['mode'] as String,
        text: j['text'] as String,
        swipeLeft: SwipeOption.fromJson(j['swipe_left'] as Map<String, dynamic>),
        swipeRight: SwipeOption.fromJson(j['swipe_right'] as Map<String, dynamic>),
      );
}

class GameTask {
  final String id;
  final String mode;
  final String text;
  const GameTask({required this.id, required this.mode, required this.text});

  factory GameTask.fromJson(Map<String, dynamic> j) => GameTask(
        id: j['id'] as String,
        mode: j['mode'] as String,
        text: j['text'] as String,
      );
}
