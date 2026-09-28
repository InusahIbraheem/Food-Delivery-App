import '../../core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/order_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final user = AuthService.instance.user;

    return MainShell(
      currentIndex: 4,
      child: ScreenScaffold(
        appBar: const CustomAppBar(title: 'Profile', showCart: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: user != null
                          ? NetworkImage(user.avatarUrl)
                          : null,
                      child: user == null ? const Icon(Icons.person, size: 48) : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Guest',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.1, end: 0),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.receipt_long_rounded,
                      value: '${OrderService.instance.orders.length}',
                      label: 'Orders',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: FavoritesService.instance,
                      builder: (context, _) {
                        return _StatCard(
                          icon: Icons.favorite_rounded,
                          value: '${FavoritesService.instance.favorites.length}',
                          label: 'Favorites',
                        );
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 24),
              _ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () => context.push(AppRoutes.settings),
              ),
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Addresses',
                subtitle: user?.address,
                onTap: () => context.push(AppRoutes.settings),
              ),
              _ProfileMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                onTap: () => context.push(AppRoutes.settings),
              ),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () => context.push(AppRoutes.settings),
              ),
              _ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SecondaryButton(
                label: 'Sign Out',
                icon: Icons.logout_rounded,
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (context.mounted) context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
    );
  }
}


