import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

void main() {
  runApp(const WeeklyPlannerApp());
}

class WeeklyPlannerApp extends StatelessWidget {
  const WeeklyPlannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
        fontFamily: 'SF Pro Display',
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C5CE7),
              Color(0xFFA29BFE),
              Color(0xFFFF7675),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          size: 60,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'PlanPro',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Haftanı Akıllıca Planla',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _sendToAI() async {
    if (_textController.text.trim().isEmpty) {
      _showSnackBar('Lütfen haftalık planınızı yazın',
          Icons.warning_amber_rounded, Colors.orange);
      return;
    }

    _buttonController.forward().then((_) => _buttonController.reverse());
    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    try {
      final response = await _callAIAPI(_textController.text);

      setState(() => _isLoading = false);

      if (response.isEmpty) {
        _showSnackBar('Görev bulunamadı, lütfen daha detaylı yazın',
            Icons.info_outline, Colors.blue);
        return;
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PlanningScreen(tasks: response),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Bir hata oluştu: $e', Icons.error_outline, Colors.red);
    }
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<List<Task>> _callAIAPI(String text) async {
    // Simülasyon - Gerçek AI API'nizi buraya entegre edin
    await Future.delayed(const Duration(seconds: 2));

    return _parseTasksFromAI('''
    Pazartesi:
    - Sabah koşusu ve kahvaltı (07:00-08:30)
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
    ''');
  }

  List<Task> _parseTasksFromAI(String aiResponse) {
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

        tasks.add(Task(
          title: taskText,
          day: currentDay,
          time: time,
          motivationalQuote:
              motivationalQuotes[tasks.length % motivationalQuotes.length],
        ));
      }
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6C5CE7),
                            Color(0xFFA29BFE),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba! 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Haftanı planlamaya başla',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF6C5CE7),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Haftalık Planın',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Yapacaklarını serbest metin olarak yaz, yapay zeka senin için planlasın! 🚀',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6C5CE7).withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: InputDecoration(
                        hintText:
                            '💭 Örnek:\n\nPazartesi sabah spor yapacağım...\nSalı toplantım var...\nÇarşamba proje teslimi...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ScaleTransition(
                  scale: _buttonAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: _isLoading
                          ? const LinearGradient(
                              colors: [Colors.grey, Colors.grey])
                          : const LinearGradient(
                              colors: [
                                Color(0xFF6C5CE7),
                                Color(0xFFA29BFE),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _sendToAI,
                        borderRadius: BorderRadius.circular(20),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        color: Colors.white, size: 24),
                                    SizedBox(width: 12),
                                    Text(
                                      'AI ile Planla',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanningScreen extends StatefulWidget {
  final List<Task> tasks;

  const PlanningScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen>
    with TickerProviderStateMixin {
  final List<String> _weekDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, List<Task>> _groupTasksByDay() {
    Map<String, List<Task>> grouped = {};
    for (var day in _weekDays) {
      grouped[day] = [];
    }
    for (var task in widget.tasks) {
      if (grouped.containsKey(task.day)) {
        grouped[task.day]!.add(task);
      }
    }
    return grouped;
  }

  int get _completedTasks {
    return widget.tasks.where((task) => task.isCompleted).length;
  }

  double get _progressPercentage {
    if (widget.tasks.isEmpty) return 0;
    return _completedTasks / widget.tasks.length;
  }

  Color _getDayColor(int index) {
    List<Color> colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFFF7675),
      const Color(0xFFFD79A8),
      const Color(0xFFFF9FF3),
      const Color(0xFF00CEC9),
      const Color(0xFFFDCB6E),
    ];
    return colors[index % colors.length];
  }

  IconData _getDayIcon(int index) {
    List<IconData> icons = [
      Icons.wb_sunny_outlined,
      Icons.brightness_5_outlined,
      Icons.star_outline,
      Icons.celebration_outlined,
      Icons.favorite_outline,
      Icons.beach_access_outlined,
      Icons.nightlight_outlined,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final groupedTasks = _groupTasksByDay();
    final totalTasks = widget.tasks.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C5CE7).withOpacity(0.1),
              const Color(0xFFA29BFE).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                            color: const Color(0xFF6C5CE7),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✨ Haftalık Planın Hazır!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Hedeflerine ulaşmak için adım adım ilerle',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6C5CE7),
                            Color(0xFFA29BFE),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📊 İlerleme',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Devam et, harikasın! 🎯',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$_completedTasks/$totalTasks',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              tween: Tween<double>(
                                begin: 0,
                                end: _progressPercentage,
                              ),
                              builder: (context, value, _) =>
                                  LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                minHeight: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(_progressPercentage * 100).toInt()}% Tamamlandı',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: widget.tasks.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_rounded,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Henüz görev yok',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _weekDays.length,
                        itemBuilder: (context, index) {
                          String day = _weekDays[index];
                          List<Task> dayTasks = groupedTasks[day] ?? [];

                          if (dayTasks.isEmpty) return const SizedBox.shrink();

                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final slideAnimation = Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  index * 0.1,
                                  0.6 + (index * 0.1),
                                  curve: Curves.easeOutCubic,
                                ),
                              ));

                              final fadeAnimation = Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  index * 0.1,
                                  0.6 + (index * 0.1),
                                  curve: Curves.easeIn,
                                ),
                              ));

                              return FadeTransition(
                                opacity: fadeAnimation,
                                child: SlideTransition(
                                  position: slideAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getDayColor(index).withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getDayColor(index),
                                            _getDayColor(index)
                                                .withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              _getDayIcon(index),
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  day,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  '${dayTasks.length} görev',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: dayTasks.map((task) {
                                          return TaskItem(
                                            task: task,
                                            onChanged: (value) {
                                              setState(() {
                                                task.isCompleted =
                                                    value ?? false;
                                              });
                                              HapticFeedback.lightImpact();
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted
              ? Colors.grey[300]!
              : const Color(0xFF6C5CE7).withOpacity(0.2),
          width: 2,
        ),
        boxShadow: task.isCompleted
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              activeColor: const Color(0xFF6C5CE7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                if (task.time != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.time!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.isCompleted) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(0xFF00B894),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.motivationalQuote,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF00B894),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
