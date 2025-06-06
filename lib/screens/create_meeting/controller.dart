import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../services/meeting_service.dart';

class CreateMeetingController extends ChangeNotifier {
  final GcbMeetingService _meetingService;
  final TextEditingController topicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  int _durationMinutes = 60;
  DateTime _startTime = DateTime.now();
  String _primaryLanguage = 'english';
  final List<String> _translationLanguages = ['spanish', 'french'];
  bool _isLoading = false;
  String? _errorMessage;
  
  CreateMeetingController(this._meetingService);
  
  // Getters
  int get durationMinutes => _durationMinutes;
  DateTime get startTime => _startTime;
  String get primaryLanguage => _primaryLanguage;
  List<String> get translationLanguages => _translationLanguages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Language options
  List<String> get languageOptions => [
    'english', 'spanish', 'french', 'german', 
    'chinese', 'japanese', 'korean', 'arabic', 'russian'
  ];
  
  // Duration options
  List<int> get durationOptions => [30, 60, 90, 120, 180];
  
  // Dispose controllers
  @override
  void dispose() {
    topicController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  // Update duration
  void updateDuration(int duration) {
    _durationMinutes = duration;
    notifyListeners();
  }
  
  // Update start time
  void updateStartTime(DateTime time) {
    _startTime = time;
    notifyListeners();
  }
  
  // Update primary language
  void updatePrimaryLanguage(String language) {
    _primaryLanguage = language;
    notifyListeners();
  }
  
  // Add translation language
  void addTranslationLanguage(String language) {
    if (!_translationLanguages.contains(language)) {
      _translationLanguages.add(language);
      notifyListeners();
    }
  }
  
  // Remove translation language
  void removeTranslationLanguage(String language) {
    _translationLanguages.remove(language);
    notifyListeners();
  }
  
  // Create meeting
  Future<void> createMeeting(BuildContext context) async {
    if (topicController.text.isEmpty) {
      _errorMessage = 'Please enter a meeting topic';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final meeting = await _meetingService.createMeeting(
        topic: topicController.text.trim(),
        durationMinutes: _durationMinutes,
        startTime: _startTime,
        primaryLanguage: _primaryLanguage,
        translationLanguages: _translationLanguages,
        description: null,
        password: passwordController.text.isNotEmpty ? passwordController.text.trim() : null,
      );
      
      if (context.mounted) {
        context.router.replace(MeetingRoute(code: meeting.code));
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}