

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPage extends GetView<QuizController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              controller.questions[controller.currentQuestionIndex.value]['question'].toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...controller.shuffledAnswers.map((answer) =>
                ElevatedButton(
                  child: Text(answer),
                  onPressed: () => controller.nextQuestion(),
                )
            ).toList(),
          ],
        )),
      ),
    );
  }
}


class QuizController extends GetxController {
  final questions = [
    {
      "question": "What is the capital of France?",
      "correctAnswer": "Paris",
      "incorrectAnswers": ["London", "Berlin", "Madrid"]
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "correctAnswer": "Mars",
      "incorrectAnswers": ["Venus", "Jupiter", "Saturn"]
    },
    {
      "question": "Who painted the Mona Lisa?",
      "correctAnswer": "Leonardo da Vinci",
      "incorrectAnswers": ["Pablo Picasso", "Vincent van Gogh", "Michelangelo"]
    },
    {
      "question": "What is the largest mammal in the world?",
      "correctAnswer": "Blue Whale",
      "incorrectAnswers": ["African Elephant", "Giraffe", "Hippopotamus"]
    },
    {
      "question": "In which year did World War II end?",
      "correctAnswer": "1945",
      "incorrectAnswers": ["1939", "1941", "1950"]
    }
  ].obs;

  final currentQuestionIndex = 0.obs;
  final shuffledAnswers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    shuffleQuestionsAndAnswers();
  }

  void shuffleQuestionsAndAnswers() {
    questions.shuffle();
    shuffleAnswers();
  }

  void shuffleAnswers() {
    if (questions.isNotEmpty && currentQuestionIndex.value < questions.length) {
      List<String> answers = [
        questions[currentQuestionIndex.value]['correctAnswer'] as String,
        ...(questions[currentQuestionIndex.value]['incorrectAnswers'] as List<dynamic>).map((answer) => answer as String),
      ];

      shuffledAnswers.value = List.from(answers)..shuffle();
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      shuffleAnswers();
    } else {
      // Quiz finished
      Get.dialog(
        AlertDialog(
          title: Text('Quiz Finished'),
          content: Text('You have completed the quiz!'),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Get.back();
                currentQuestionIndex.value = 0;
                shuffleQuestionsAndAnswers();
              },
            ),
          ],
        ),
      );
    }
  }
}
