import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: March 2023',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Introduction
              Text(
                'Radio Evangelique Florida ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose information about you when you use our mobile application and related services.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sections
              _buildSection(
                'Information We Collect',
                'We do not require you to create an account or provide personal information to use this app.\n\n'
                'We may automatically collect certain information about your device and how you interact with our application, including your device type, operating system, and anonymous usage statistics. This information is used solely to improve app functionality and user experience.',
              ),
              
              _buildSection(
                'How We Use Your Information',
                'We use the information we collect to:\n'
                '• Provide, maintain, and improve our services\n'
                '• Respond to your comments, questions, and requests\n'
                '• Monitor and analyze trends, usage, and activities in connection with our services\n'
                '• Detect, investigate, and prevent fraudulent transactions and other illegal activities\n'
                '• Personalize and improve your experience with our application',
              ),
              
              _buildSection(
                'Sharing of Information',
                'We may share the information we collect as follows:\n'
                '• With service providers who perform services on our behalf\n'
                '• In response to a request for information if we believe disclosure is in accordance with, or required by, any applicable law or legal process\n'
                '• If we believe your actions are inconsistent with our user agreements or policies, or to protect the rights, property, and safety of us or others',
              ),
              
              _buildSection(
                'Data Security',
                'We take reasonable measures to help protect the information we collect from loss, theft, misuse, and unauthorized access, disclosure, alteration, and destruction. When you make a donation through our app, your personal and payment information is transmitted securely using industry-standard encryption and security protocols. We do not store your payment information on our servers, and your donation details are not made public. Donations can be made securely through Bank of America, Zelle, Cash App, and Stripe, all of which employ robust security measures to protect your financial data. However, no security system is impenetrable, and we cannot guarantee the absolute security of our systems.',
              ),
              
              _buildSection(
                'Your Choices',
                'You are not required to provide any personal information to use this app. If you contact us for support, we may receive your email address or other contact information, which will only be used to respond to your inquiry.',
              ),
              
              _buildSection(
                'Changes to This Privacy Policy',
                'We may change this Privacy Policy from time to time. If we make changes, we will notify you by revising the date at the top of the policy. We encourage you to review the Privacy Policy whenever you access the application to stay informed about our information practices.',
              ),
              
              _buildSection(
                'Children\'s Privacy',
                'Our application is not directed to children under the age of 13, and we do not knowingly collect personal information from children under 13. If we learn that we have collected personal information from a child under 13, we will promptly delete this information.',
              ),
              
              _buildSection(
                'Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at:\nrtvemedia@gmail.com',
              ),
              
              const SizedBox(height: 32),
              
              // Data collection summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Collection Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow('Location Data', 'Not collected'),
                    _buildDataRow('Usage Statistics', 'Collected anonymously'),
                    _buildDataRow('Device Information', 'Collected for functionality'),
                    _buildDataRow('Cookies', 'Used for essential functions only'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildDataRow(String dataType, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dataType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.indigo,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Not collected'
                  ? Colors.green.withOpacity(0.1)
                  : status == 'Optional'
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: status == 'Not collected'
                    ? Colors.green.withOpacity(0.3)
                    : status == 'Optional'
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 13,
                color: status == 'Not collected'
                    ? Colors.green.shade800
                    : status == 'Optional'
                        ? Colors.blue.shade800
                        : Colors.orange.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 