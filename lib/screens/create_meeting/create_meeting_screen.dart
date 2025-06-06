// lib/screens/create_meeting/create_meeting_screen.dart - COMPLETE FIXED VERSION
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:globecast_ui/router/app_router.dart';
import 'package:globecast_ui/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/meeting_service.dart';

@RoutePage()
class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _topicController = TextEditingController();
  String _selectedDuration = '60 min';
  String _selectedLanguage = 'English';
  final List<String> _selectedTranslationLanguages = ['French', 'Spanish'];
  final _passwordController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _topicController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _generateMeetingId() {
    const uuid = Uuid();
    return 'GCM-${uuid.v4().substring(0, 8)}';
  }

  // FIXED: Complete create meeting method with proper language handling
  Future<void> _createMeeting() async {
    if (_topicController.text.trim().isEmpty) {
      _showSnackBar('Please enter a meeting topic', isError: true);
      return;
    }

    if (_selectedTranslationLanguages.isEmpty) {
      _showSnackBar('Please select at least one translation language', isError: true);
      return;
    }

    setState(() => _isCreating = true);

    try {
      final meetingService = Provider.of<GcbMeetingService>(context, listen: false);

      // FIXED: Set user details with proper host name
      meetingService.setUserDetails(displayName: 'Host');

      // FIXED: Convert language names to lowercase for internal use
      final speakingLang = _selectedLanguage.toLowerCase();
      final translationLangs = _selectedTranslationLanguages
          .map((lang) => lang.toLowerCase())
          .toList();

      // IMPORTANT: Set primary target language as the first translation language
      final primaryTargetLang = translationLangs.first;

      print('🌐 Creating meeting with languages:');
      print('   Speaking: $speakingLang');
      print('   Primary Target: $primaryTargetLang');
      print('   All Translations: $translationLangs');

      // Set language preferences
      meetingService.setLanguagePreferences(
        speaking: speakingLang,
        listening: primaryTargetLang, // Set primary target as listening language
      );

      // Create meeting with all translation languages
      final meetingId = await meetingService.createMeeting(
        topic: _topicController.text.trim(),
        password: _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
        translationLanguages: translationLangs, hostLanguage: '',
      );

      print('✅ Meeting created successfully: $meetingId');
      print('🌐 Translation flow will be: $speakingLang → $translationLangs');

      // Show success message
      _showSnackBar('Meeting created successfully!', isError: false);

      // Navigate to meeting screen
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        context.router.replaceAll([MeetingRoute(code: meetingId)]);
      }

    } catch (e) {
      print('❌ Error creating meeting: $e');
      _showSnackBar('Failed to create meeting: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GcbAppTheme.background,
      appBar: AppBar(
        backgroundColor: GcbAppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Create Meeting',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meeting Topic
              const Text(
                'Meeting Topic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Meeting Topic Input
              TextField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter meeting topic',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.title, color: Colors.grey),
                  filled: true,
                  fillColor: GcbAppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Meeting Duration
              const Text(
                'Meeting Duration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Duration Dropdown
              Container(
                decoration: BoxDecoration(
                  color: GcbAppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDuration,
                    dropdownColor: GcbAppTheme.surface,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    isExpanded: true,
                    items: ['30 min', '60 min', '90 min', '2 hours']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDuration = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Speaking Language
              const Text(
                'Speaking Language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Language Dropdown
              Container(
                decoration: BoxDecoration(
                  color: GcbAppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: GcbAppTheme.surface,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    isExpanded: true,
                    items: ['English', 'Spanish', 'French', 'German', 'Chinese', 'Vietnamese', 'Japanese', 'Korean']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                          // Remove selected language from translation languages if present
                          _selectedTranslationLanguages.remove(newValue);
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Translation Languages - IMPROVED
              Row(
                children: [
                  const Text(
                    'Translation Languages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${_selectedTranslationLanguages.length}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Selected Languages Chips
              Container(
                constraints: const BoxConstraints(minHeight: 50),
                child: _selectedTranslationLanguages.isEmpty
                    ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GcbAppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Please select at least one translation language',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                )
                    : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedTranslationLanguages.map((language) {
                      return Chip(
                        label: Text(
                          language,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Colors.blue.withOpacity(0.3),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedTranslationLanguages.remove(language);
                          });
                        },
                      );
                    }).toList(),

                    // Add Language Button
                    ActionChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            'Add Language',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      onPressed: _showLanguageSelectionDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Password
              const Text(
                'Password (optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Password Input
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Set meeting password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  filled: true,
                  fillColor: GcbAppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

              const Spacer(),

              // Create Button - IMPROVED
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isCreating ? null : _createMeeting,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.blue;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: _isCreating
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Creating Meeting...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                      : const Text(
                    'Create Meeting',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // IMPROVED: Language selection dialog
  void _showLanguageSelectionDialog() {
    final availableLanguages = [
      'Spanish', 'French', 'German', 'Chinese', 'Vietnamese',
      'Japanese', 'Korean', 'Russian', 'Arabic', 'Portuguese',
      'Italian', 'Dutch', 'Swedish', 'Norwegian', 'Danish'
    ].where((language) =>
    !_selectedTranslationLanguages.contains(language) &&
        language != _selectedLanguage
    ).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: GcbAppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Select Translation Language',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: availableLanguages.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No more languages available',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: availableLanguages.length,
              itemBuilder: (context, index) {
                final language = availableLanguages[index];
                return ListTile(
                  title: Text(
                    language,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.add, color: Colors.blue),
                  onTap: () {
                    setState(() {
                      _selectedTranslationLanguages.add(language);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}