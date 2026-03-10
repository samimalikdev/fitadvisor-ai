import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $urlString',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'App Info',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2979FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2979FF).withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.developer_board,
                  size: 60,
                  color: Color(0xFF2979FF),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Developer Information',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Name: Sami Malik',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader(Icons.person, 'About Me'),
            const SizedBox(height: 10),
            Text(
              "I'm a full-stack mobile & web developer with hands-on experience in building Android apps, iOS apps, Flutter apps, and powerful backend systems. I also work on WhatsApp automation, custom bots, and real-world API based solutions. My focus is always on clean, secure, and high-performance development.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader(Icons.code, 'Skills & Expertise'),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                _buildSkillChip('Flutter (Android & iOS)'),
                _buildSkillChip('Native Android (Kotlin)'),
                _buildSkillChip('iOS App Development'),
                _buildSkillChip('Node.js & Express.js'),
                _buildSkillChip('SQL & NoSQL'),
                _buildSkillChip('MongoDB'),
                _buildSkillChip('MySQL'),
                _buildSkillChip('PostgreSQL'),
                _buildSkillChip('Redis'),
                _buildSkillChip('Full-Stack Development'),
                _buildSkillChip('Cloud (AWS, Firebase, Vercel)'),
                _buildSkillChip('Reverse Engineering'),
                _buildSkillChip('WhatsApp Bot & Automation'),
                _buildSkillChip('API Integration & Custom Tools'),
              ],
            ),
            const SizedBox(height: 40),
            _buildSectionHeader(Icons.connect_without_contact, "Let's Connect"),
            const SizedBox(height: 15),
            _buildSocialLink(
              icon: FontAwesomeIcons.whatsapp,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () => _launchUrl(
                  'https://whatsapp.com/channel/0029Va9bWJa3QxS0N7sNcu00'),
            ),
            _buildSocialLink(
              icon: FontAwesomeIcons.instagram,
              label: 'Instagram',
              color: const Color(0xFFE1306C),
              onTap: () => _launchUrl('https://www.instagram.com/iamsamimalik'),
            ),
            _buildSocialLink(
              icon: FontAwesomeIcons.telegram,
              label: 'Telegram',
              color: const Color(0xFF0088cc),
              onTap: () => _launchUrl('https://t.me/SamiGaming'),
            ),
            _buildSocialLink(
              icon: FontAwesomeIcons.linkedinIn,
              label: 'LinkedIn',
              color: const Color(0xFF0077b5),
              onTap: () => _launchUrl(
                  'https://www.linkedin.com/in/sami-malik-950665273'),
            ),
            _buildSocialLink(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              color: Colors.white,
              onTap: () => _launchUrl('https://github.com/samimalikdev'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2979FF), size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2979FF),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialLink({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white30, size: 16),
          ],
        ),
      ),
    );
  }
}
