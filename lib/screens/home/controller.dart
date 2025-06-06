import 'package:flutter/material.dart';

import '../../services/meeting_service.dart';

class HomeController extends ChangeNotifier {
  final GcbMeetingService _meetingService;
  
  HomeController(this._meetingService);
  
  // Getters
  List<dynamic> get myMeetings => _meetingService.myMeetings;
  bool get isLoading => _meetingService.isLoading;
  
  // Navigate to join meeting
  void joinMeeting(BuildContext context, String code) {
    _meetingService.joinMeeting(code);
  }
}