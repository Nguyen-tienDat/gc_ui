// lib/screens/meeting/widgets/language_selection_panel.dart
import 'package:flutter/material.dart';

class LanguageSelectionPanel extends StatefulWidget {
  final String sourceLanguage;
  final String targetLanguage;
  final Map<String, String> availableLanguages;
  final Function(String) onSourceLanguageChanged;
  final Function(String) onTargetLanguageChanged;
  final VoidCallback onClose;

  const LanguageSelectionPanel({
    Key? key,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.availableLanguages,
    required this.onSourceLanguageChanged,
    required this.onTargetLanguageChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  State<LanguageSelectionPanel> createState() => _LanguageSelectionPanelState();
}

class _LanguageSelectionPanelState extends State<LanguageSelectionPanel> {
  String _searchQuery = '';
  bool _autoDetectEnabled = true;
  bool _realTimeTranslationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final filteredLanguages = widget.availableLanguages.entries.where((entry) {
      return entry.value.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border(
          left: BorderSide(color: Colors.grey.shade700, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade700, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.translate, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Language Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current language setup
                  _buildCurrentLanguageSetup(),

                  const SizedBox(height: 24),

                  // Language settings
                  _buildLanguageSettings(),

                  const SizedBox(height: 24),

                  // Language selection
                  _buildLanguageSelection(filteredLanguages),

                  const SizedBox(height: 24),

                  // Advanced settings
                  _buildAdvancedSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLanguageSetup() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Setup',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Source language
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Speaking',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getLanguageName(widget.sourceLanguage),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Translation arrow
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_downward, color: Colors.white, size: 20),
            ),
          ),

          const SizedBox(height: 16),

          // Target language
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.hearing, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Listening',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getLanguageName(widget.targetLanguage),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Swap button
          Center(
            child: ElevatedButton.icon(
              onPressed: _swapLanguages,
              icon: const Icon(Icons.swap_vert),
              label: const Text('Swap Languages'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Auto-detect language
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: _autoDetectEnabled ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auto-detect Language',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Automatically detect speaking language',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _autoDetectEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoDetectEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Real-time translation
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.translate,
                color: _realTimeTranslationEnabled ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Real-time Translation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Translate speech in real-time',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _realTimeTranslationEnabled,
                onChanged: (value) {
                  setState(() {
                    _realTimeTranslationEnabled = value;
                  });
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelection(List<MapEntry<String, String>> filteredLanguages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Languages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Search bar
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search languages...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade800,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Language list
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredLanguages.length,
            itemBuilder: (context, index) {
              final entry = filteredLanguages[index];
              final languageCode = entry.key;
              final languageName = entry.value;
              final isSource = widget.sourceLanguage == languageCode;
              final isTarget = widget.targetLanguage == languageCode;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: (isSource || isTarget) ? Colors.blue.withOpacity(0.2) : null,
                  borderRadius: BorderRadius.circular(6),
                  border: (isSource || isTarget)
                      ? Border.all(color: Colors.blue.withOpacity(0.5))
                      : null,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: isSource
                        ? Colors.blue
                        : isTarget
                        ? Colors.purple
                        : Colors.grey.shade600,
                    child: Text(
                      languageCode.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    languageName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      if (isSource) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'SPEAKING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (isTarget) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LISTENING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade400, size: 16),
                    color: Colors.grey.shade700,
                    onSelected: (value) => _handleLanguageAction(languageCode, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'set_speaking',
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: Colors.blue, size: 16),
                            SizedBox(width: 8),
                            Text('Set as Speaking', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'set_listening',
                        child: Row(
                          children: [
                            Icon(Icons.hearing, color: Colors.purple, size: 16),
                            SizedBox(width: 8),
                            Text('Set as Listening', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showLanguageOptions(languageCode, languageName),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Advanced',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Translation quality
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Translation Quality',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Standard',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ),
                  Text(
                    'High Quality',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
              Slider(
                value: 0.7,
                onChanged: (value) {
                  // TODO: Implement quality setting
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey.shade600,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Download offline languages
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.download, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offline Languages',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Download for offline translation',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _showOfflineLanguages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: const Text('Manage', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Reset to defaults
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('Reset to Defaults'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _getLanguageName(String languageCode) {
    return widget.availableLanguages[languageCode] ?? languageCode.toUpperCase();
  }

  void _swapLanguages() {
    final tempSource = widget.sourceLanguage;
    widget.onSourceLanguageChanged(widget.targetLanguage);
    widget.onTargetLanguageChanged(tempSource);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Languages swapped')),
    );
  }

  void _handleLanguageAction(String languageCode, String action) {
    switch (action) {
      case 'set_speaking':
        widget.onSourceLanguageChanged(languageCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speaking language set to ${_getLanguageName(languageCode)}')),
        );
        break;
      case 'set_listening':
        widget.onTargetLanguageChanged(languageCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listening language set to ${_getLanguageName(languageCode)}')),
        );
        break;
    }
  }

  void _showLanguageOptions(String languageCode, String languageName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: Text(
          languageName,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mic, color: Colors.blue),
              title: const Text('Set as Speaking Language', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                widget.onSourceLanguageChanged(languageCode);
              },
            ),
            ListTile(
              leading: const Icon(Icons.hearing, color: Colors.purple),
              title: const Text('Set as Listening Language', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                widget.onTargetLanguageChanged(languageCode);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showOfflineLanguages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          'Offline Languages',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Offline language packs will be available in a future update.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          'Reset Language Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will reset all language settings to their default values. Continue?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onSourceLanguageChanged('en');
              widget.onTargetLanguageChanged('fr');
              setState(() {
                _autoDetectEnabled = true;
                _realTimeTranslationEnabled = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings reset to defaults')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}