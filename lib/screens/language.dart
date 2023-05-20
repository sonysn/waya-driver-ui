import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Language Selection',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LanguageOption(
              language: 'English',
              isSelected: selectedLanguage == 'English',
              onPressed: () {
                setState(() {
                  selectedLanguage = 'English';
                });
              },
            ),
            LanguageOption(
              language: 'Yoruba',
              isSelected: selectedLanguage == 'Yoruba',
              onPressed: () {
                setState(() {
                  selectedLanguage = 'Yoruba';
                });
              },
            ),
            LanguageOption(
              language: 'Igbo',
              isSelected: selectedLanguage == 'Igbo',
              onPressed: () {
                setState(() {
                  selectedLanguage = 'Igbo';
                });
              },
            ),
            LanguageOption(
              language: 'Hausa',
              isSelected: selectedLanguage == 'Hausa',
              onPressed: () {
                setState(() {
                  selectedLanguage = 'Hausa';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onPressed;

  const LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,
              size: 24.0,
            ),
            SizedBox(width: 12.0),
            Text(
              language,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
