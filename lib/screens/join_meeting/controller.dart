import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../services/meeting_service.dart';

class JoinMeetingController extends ChangeNotifier {
  final GcbMeetingService _meetingService;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  
  JoinMeetingController(this._meetingService);
  
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Dispose controllers
  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  // Join meeting
  Future<void> joinMeeting(BuildContext context) async {
    if (codeController.text.isEmpty) {
      _errorMessage = 'Please enter a meeting code';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _meetingService.joinMeeting(
        codeController.text.trim(),
        passwordController.text.isNotEmpty ? passwordController.text.trim() : null,
      );
      
      if (success) {
        if (context.mounted) {
          context.router.replace(MeetingRoute(code: codeController.text.trim()));
        }
      } else {
        _errorMessage = 'Failed to join meeting. Please check your meeting code and password.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}