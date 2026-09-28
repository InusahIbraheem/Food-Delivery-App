import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_routes.dart';
import '../services/cart_service.dart';
import '../theme/app_colors.dart';
import 'app_footer.dart';
import 'primary_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showCart = false,
    this.actions,
  });

  final String title;
  final bool showBack;
  final bool showCart;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconCircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(title),
      actions: [
        if (showCart)
          ListenableBuilder(
            listenable: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.itemCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconCircleButton(
                    icon: Icons.shopping_bag_outlined,
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ...?actions,
        const SizedBox(width: 8),
      ],
    );
  }
}

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.showFooter = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showFooter;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        children: [
          Expanded(child: body),
          if (showFooter)
            const SafeArea(
              top: false,
              child: AppFooter(),
            ),
        ],
      ),
    );
  }
}
