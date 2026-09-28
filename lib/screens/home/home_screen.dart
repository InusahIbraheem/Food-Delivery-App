import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/food_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/food_card.dart';
import '../../core/widgets/restaurant_card.dart';
import '../../core/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final user = AuthService.instance.user;
    final featured = FoodService.instance.getFeaturedRestaurants();
    final popular = FoodService.instance.getPopularFoods();
    final categories = FoodService.categories.where((c) => c != 'All').toList();

    return MainShell(
      currentIndex: 0,
      child: ScreenScaffold(
        showFooter: true,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 16, padding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.homeGreeting,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              user?.name.split(' ').first ?? 'Guest',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.profile),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: user != null
                                ? NetworkImage(user.avatarUrl)
                                : null,
                            child: user == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                        ),
                      ],
                    ).animate().fadeIn().slideY(begin: -0.1, end: 0),
                    const SizedBox(height: 20),
                    AppSearchBar(
                      hint: AppStrings.searchHint,
                      readOnly: true,
                      onTap: () => context.push(AppRoutes.restaurants),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return ActionChip(
                            label: Text(cat),
                            onPressed: () => context.push(AppRoutes.restaurants),
                            backgroundColor: index == 0
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.surface,
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: index == 0
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: AppStrings.featuredRestaurants,
                      actionLabel: AppStrings.seeAll,
                      onActionTap: () => context.push(AppRoutes.restaurants),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return RestaurantCard(
                      restaurant: featured[index],
                      onTap: () => context.push(AppRoutes.restaurants),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 300 + index * 100))
                        .slideX(begin: 0.2, end: 0);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 28, padding, 16),
                child: SectionHeader(
                  title: AppStrings.popularDishes,
                  actionLabel: AppStrings.seeAll,
                  onActionTap: () => context.push(AppRoutes.restaurants),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.gridCrossAxisCount(context),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = popular[index];
                    return ListenableBuilder(
                      listenable: FavoritesService.instance,
                      builder: (context, _) {
                        return FoodCard(
                          food: food,
                          isFavorite: FavoritesService.instance.isFavorite(food.id),
                          onTap: () => context.push('/food/${food.id}'),
                          onFavoriteTap: () =>
                              FavoritesService.instance.toggleFavorite(food.id),
                        );
                      },
                    );
                  },
                  childCount: popular.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
