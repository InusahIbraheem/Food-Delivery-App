import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _locationServices = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);

    return ScreenScaffold(
      appBar: const CustomAppBar(title: 'Settings', showBack: true),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          _SectionTitle(title: 'Preferences'),
          _SettingsSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Order updates and promotions',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ).animate().fadeIn(delay: 50.ms),
          _SettingsSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ).animate().fadeIn(delay: 100.ms),
          _SettingsSwitchTile(
            icon: Icons.location_on_outlined,
            title: 'Location Services',
            subtitle: 'For accurate delivery tracking',
            value: _locationServices,
            onChanged: (v) => setState(() => _locationServices = v),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 16),
          _SectionTitle(title: 'Account'),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: Text(
              _language,
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
            onTap: () => _showLanguagePicker(context),
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'About'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            trailing: Text(
              '1.0.0',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.star_outline,
            title: 'Rate App',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: 'Share App',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final languages = ['English', 'French', 'Spanish', 'Arabic'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Select Language',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...languages.map(
                (lang) => ListTile(
                  title: Text(lang, style: GoogleFonts.poppins()),
                  trailing: _language == lang
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _language = lang);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
        ),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        trailing: trailing ??
            const Icon(Icons.chevron_right, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
