import 'package:planpro/models/task_model.dart';
import 'dart:math' as math; // Gerekliyse, ancak burada kullanılmamış.

class AiPlannerService {
  // Simülasyon - Gerçek AI API'nizi buraya entegre edin
  static Future<List<Task>> callAIAPI(String text) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock (sahte) yanıt. Gerçek API'den gelen yanıtı buraya koyacaksınız.
    const String mockResponse = '''
    Pazartesi:
    - Sabah koşusu  (07:00-08:30)
    - Proje sunumu hazırlığı (09:00-12:00)
    - Ekip toplantısı (14:00-15:30)
    
    Salı:
    - Yoga dersi (07:30-08:30)
    - Müşteri görüşmesi (10:00-11:30)
    - Kod geliştirme (13:00-18:00)
    
    Çarşamba:
    - Sprint planlama toplantısı (09:00-11:00)
    - Dokümantasyon yazma (14:00-16:00)
    - Takım yemeği (18:30-20:00)
    
    Perşembe:
    - Bire bir görüşmeler (09:00-12:00)
    - Tasarım incelemesi (14:00-15:30)
    - Kod review (16:00-17:30)
    
    Cuma:
    - Haftalık retrospektif (09:00-10:30)
    - Proje teslimi (11:00-13:00)
    - Hafta sonu planlaması (15:00-16:00)
    ''';

    return _parseTasksFromAI(mockResponse);
  }

  static List<Task> _parseTasksFromAI(String aiResponse) {
    List<Task> tasks = [];
    List<String> lines = aiResponse.split('\n');
    String? currentDay;
    List<String> motivationalQuotes = [
      'Harika bir adım!',
      'Başarıya giden yoldasın!',
      'Sen yaparsın!',
      'İleriye doğru!',
      'Mükemmel planlama!',
    ];

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.contains('Pazartesi') ||
          line.contains('Salı') ||
          line.contains('Çarşamba') ||
          line.contains('Perşembe') ||
          line.contains('Cuma') ||
          line.contains('Cumartesi') ||
          line.contains('Pazar')) {
        currentDay = line.replaceAll(':', '').trim();
      } else if (line.startsWith('-') && currentDay != null) {
        String taskText = line.substring(1).trim();
        String? time;

        RegExp timeRegex = RegExp(r'\((\d{2}:\d{2}-\d{2}:\d{2}|\d{2}:\d{2})\)');
        Match? match = timeRegex.firstMatch(taskText);
        if (match != null) {
          time = match.group(1);
          taskText = taskText.replaceAll(timeRegex, '').trim();
        }

        tasks.add(
          Task(
            title: taskText,
            day: currentDay,
            time: time,
            motivationalQuote:
                motivationalQuotes[tasks.length % motivationalQuotes.length],
          ),
        );
      }
    }
    return tasks;
  }
}
