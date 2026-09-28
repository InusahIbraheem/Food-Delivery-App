import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/favorites_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/food_card.dart';
import '../../core/widgets/primary_button.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);

    return MainShell(
      currentIndex: 2,
      child: ScreenScaffold(
        appBar: const CustomAppBar(title: 'Favorites', showCart: true),
        body: ListenableBuilder(
          listenable: FavoritesService.instance,
          builder: (context, _) {
            final favorites = FavoritesService.instance.favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: AppColors.textLight.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.emptyFavorites,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save dishes you love for quick access',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Explore Menu',
                      width: 200,
                      onPressed: () => context.go(AppRoutes.restaurants),
                    ),
                  ],
                ).animate().fadeIn(),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridCrossAxisCount(context),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final food = favorites[index];
                return FoodCard(
                  food: food,
                  isFavorite: true,
                  onTap: () => context.push('/food/${food.id}'),
                  onFavoriteTap: () =>
                      FavoritesService.instance.toggleFavorite(food.id),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 * index))
                    .scale(begin: const Offset(0.9, 0.9));
              },
            );
          },
        ),
      ),
    );
  }
}
