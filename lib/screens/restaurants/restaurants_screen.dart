import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/food_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/food_card.dart';
import '../../core/widgets/restaurant_card.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final restaurants = FoodService.instance.getRestaurants();
    final foods = _searchQuery.isNotEmpty
        ? FoodService.instance.searchFoods(_searchQuery)
        : FoodService.instance.getFoodsByCategory(_selectedCategory);

    return MainShell(
      currentIndex: 1,
      child: ScreenScaffold(
        appBar: const CustomAppBar(title: 'Restaurants', showCart: true),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 0),
              child: AppSearchBar(
                hint: 'Search restaurants or dishes...',
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: padding),
                scrollDirection: Axis.horizontal,
                itemCount: FoodService.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = FoodService.categories[index];
                  final isSelected = cat == _selectedCategory;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() {
                      _selectedCategory = cat;
                      _searchQuery = '';
                      _searchController.clear();
                    }),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(padding),
                children: [
                  if (_searchQuery.isEmpty) ...[
                    Text(
                      'All Restaurants',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ).animate().fadeIn(),
                    const SizedBox(height: 12),
                    ...restaurants.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RestaurantCard(
                          restaurant: entry.value,
                          isHorizontal: false,
                          onTap: () {
                            setState(() {
                              _selectedCategory = entry.value.categories.first;
                            });
                          },
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 100 * entry.key))
                            .slideX(begin: 0.1, end: 0),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    _searchQuery.isNotEmpty ? 'Search Results' : 'Menu Items',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.gridCrossAxisCount(context),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
