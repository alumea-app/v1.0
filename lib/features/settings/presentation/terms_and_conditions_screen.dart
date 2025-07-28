import 'package:alumea/core/app_theme.dart'; // Make sure your theme import is correct
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We can reuse the helper widgets from the Privacy Policy by defining them here again.
    // Or you could move them to a shared file. For simplicity, we'll define them here.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CriticalWarningBox(
                text:
                    "Alumea is a wellness tool, not a medical service. It is not a substitute for professional medical advice, diagnosis, or treatment. If you are in crisis, please call your local emergency services immediately."),
            _Heading(text: "1. Your Account"),
            _Paragraph(
                text:
                    "You are responsible for safeguarding your account. Keep your password confidential and notify us immediately of any unauthorized use. You must be at least 16 years of age to use the App."),
            _Heading(text: "2. Acceptable Use"),
            _Paragraph(
                text:
                    "You agree not to use the App to share unlawful content, attempt to gain unauthorized access to our systems, or disrupt the service."),
            _Heading(text: "3. Intellectual Property"),
            _Paragraph(
                text:
                    "The App, its design, logo, and names \"Alumea\" and \"Lumi\" are the exclusive property of [Your Company Name]. You retain full ownership of the personal content you enter into the App."),
            _Heading(text: "4. Termination"),
            _Paragraph(
                text:
                    "You are free to stop using our App at any time and can permanently delete your account and all associated data from the \"Manage Data\" section in the App's settings."),
            _Heading(text: "5. Disclaimer of Warranties"),
            _Paragraph(
                text:
                    "The App is provided \"as is,\" without any warranties of any kind. While we strive for excellence, we cannot guarantee it will be 100% accurate, reliable, or available at all times."),
            _Heading(text: "6. Contact Information"),
            _Paragraph(
                text:
                    "For any questions about these Terms, please contact us at legal@alumea.app."),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets for Styling ---

class _Heading extends StatelessWidget {
  final String text;
  const _Heading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(height: 1.5, fontSize: 16),
      ),
    );
  }
}

class _CriticalWarningBox extends StatelessWidget {
  final String text;
  const _CriticalWarningBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: AppTheme.accentCoral.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentCoral)),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.accentCoral),
          const SizedBox(width: 16),
          Expanded(
              child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                fontSize: 16,
                color: AppTheme.accentCoral.withOpacity(0.9)),
          ))
        ],
      ),
    );
  }
}
