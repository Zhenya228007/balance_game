import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

class ContentRepository {
  final List<Question> questions;
  final List<GameTask> tasks;
  ContentRepository(this.questions, this.tasks);

  static Future<ContentRepository> load() async {
    final raw = await rootBundle.loadString('assets/questions.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final qs = (data['questions'] as List)
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
    final ts = (data['tasks'] as List)
        .map((e) => GameTask.fromJson(e as Map<String, dynamic>))
        .toList();
    return ContentRepository(qs, ts);
  }

  List<Question> questionsFor(String mode) =>
      questions.where((q) => q.mode == mode).toList()..shuffle(Random());

  GameTask randomTask(String mode) {
    final list = tasks.where((t) => t.mode == mode).toList();
    return list[Random().nextInt(list.length)];
  }
}
