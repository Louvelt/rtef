import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
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
                      'Terms of Service',
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
                'Welcome to Radio Evangelique Florida. These Terms of Service ("Terms") govern your use of our mobile application and services. By accessing or using our application, you agree to be bound by these Terms.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sections
              _buildSection(
                'Use of Services',
                'Our application provides access to Christian radio content and related services. You may use our services for personal, non-commercial purposes only. You must not use our services in any way that is unlawful, illegal, fraudulent or harmful, or in connection with any unlawful, illegal, fraudulent or harmful purpose or activity.',
              ),
              
              _buildSection(
                'Intellectual Property',
                'The content, organization, graphics, design, compilation, and other matters related to the application are protected under applicable copyrights, trademarks, and other proprietary rights. Copying, redistributing, or reproducing any part of the application is prohibited without our prior written consent.',
              ),
              
              _buildSection(
                'Disclaimers',
                'The services are provided "as is" and "as available" without any warranties of any kind, either express or implied. We do not warrant that the services will be uninterrupted or error-free, that defects will be corrected, or that the services are free of viruses or other harmful components.',
              ),
              
              _buildSection(
                'Limitation of Liability',
                'In no event shall Radio Evangelique Florida be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the services.',
              ),
              
              _buildSection(
                'Changes to Terms',
                'We reserve the right to modify these Terms at any time. If we make changes to these Terms, we will provide notice of such changes by updating the date at the top of these Terms. Your continued use of the application following the posting of revised Terms means that you accept and agree to the changes.',
              ),
              
              _buildSection(
                'Governing Law',
                'These Terms shall be governed by and construed in accordance with the laws of the State of Florida, without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.',
              ),
              
              _buildSection(
                'Contact Us',
                'If you have any questions about these Terms, please contact us at:\nvoltairelouvelt@gmail.com',
              ),
              
              const SizedBox(height: 32),
              
              // Acceptance
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
                      'Your Acceptance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'By using this application, you acknowledge that you have read and understood these Terms of Service and agree to be bound by them.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
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
} 