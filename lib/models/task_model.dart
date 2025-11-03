class Task {
  final String title;
  final String day;
  final String? time;
  final String motivationalQuote;
  bool isCompleted;

  Task({
    required this.title,
    required this.day,
    this.time,
    this.motivationalQuote = 'Harika bir adım!',
    this.isCompleted = false,
  });
}
