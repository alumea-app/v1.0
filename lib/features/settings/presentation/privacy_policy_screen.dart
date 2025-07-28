import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Heading(text: "Our Guiding Principle"),
            _Paragraph(
                text:
                    "Your trust is the foundation of Alumea. This policy is written to be as clear and straightforward as possible."),
            
            _Heading(text: "1. The Information We Collect"),
            _Paragraph(
                text:
                    "To provide you with a personalized and secure experience, we collect the following types of information:"),
            _BulletedItem(
                title: "Account Information:",
                content:
                    "When you create an account, we collect your email address and a hashed (encrypted) password. We also store the name you provide for Lumi to call you."),
            _BulletedItem(
                title: "Your Conversations with Lumi:",
                content:
                    "All messages you send to Lumi and the responses she provides are stored securely. This includes your daily check-ins, journal entries made via chat, and any other thoughts you share."),
            _BulletedItem(
                title: "Technical Data:",
                content:
                    "We may collect anonymous data to help us fix crashes and improve the App's performance. This includes your device type and operating system version. This data is never tied to your personal identity."),

            _Heading(text: "2. How We Use Your Information"),
             _Paragraph(
                text:
                    "We use your information for one purpose: to make Alumea work for you."),
             _BulletedItem(
                title: "To Provide the Core Service:",
                content:
                    "Your Account Information is used to secure your account and personalize your experience (e.g., \"Good morning, Alex\")."),
            _BulletedItem(
                title: "To Power the AI Companion:",
                content:
                    "Your conversations are sent to our AI service provider (Google Cloud's API, which powers Gemini) to generate Lumi's intelligent and empathetic responses. This data is used solely to provide the response and is governed by Google's strict privacy policies."),
             _BulletedItem(
                title: "To Display Your Journey:",
                content:
                    "Your conversations and check-ins are stored so we can display them back to you in your \"Journey\" tab, helping you see your progress over time."),

            _Heading(text: "3. Data Storage and Security"),
            _Paragraph(text: "We take your privacy seriously. All your data (account information, chat history) is stored with Firebase (a Google company) and protected by their industry-leading security measures. All communication between the App and our servers is encrypted using standard Transport Layer Security (TLS)."),

            _Heading(text: "4. Data Sharing"),
             _Paragraph(
                text:
                    "We will never sell, rent, or share your personal data or conversation history with third-party advertisers or data brokers. Your private thoughts are yours and yours alone."),

            _Heading(text: "5. Your Rights and Your Control"),
            _Paragraph(
                text:
                    "You are in control of your data. As implemented in the App's \"Settings\" screen, you have the right to access your data, the right to portability (export), and the right to be forgotten (account deletion). Deletion is permanent and irreversible."),
            
             _Heading(text: "6. Children's Privacy"),
             _Paragraph(
                text:
                    "Alumea is not intended for individuals under the age of 16. We do not knowingly collect personal information from children under 16."),

            _Heading(text: "7. How to Contact Us"),
             _Paragraph(
                text:
                    "If you have any questions about this Privacy Policy, please contact us at privacy@alumea.app."),

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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 16),
      ),
    );
  }
}

class _BulletedItem extends StatelessWidget {
  final String title;
  final String content;
  const _BulletedItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
             '• $title',
             style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
           ),
           const SizedBox(height: 4),
           Text(
             content,
             style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 16),
           ),
        ],
      ),
    );
  }
}