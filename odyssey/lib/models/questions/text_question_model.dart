import 'package:odyssey/models/questions/question_model.dart';

class TextQuestionModel extends QuestionModel{
  final String placeholder;

  const TextQuestionModel({required super.question, required this.placeholder});
}
